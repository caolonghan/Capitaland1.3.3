//
//  AddressVM.m
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "AddressVM.h"

@implementation AddressVM

{
    
}


-(void) loadData{
    page = 1;
    [self loadDataFromNet:REFRESH_METHOD];
}

-(void) loadMore{
    if(isEnd){
        [self.successObject sendNext:nil];
        return;
    }
    page++;
        [self loadDataFromNet:MORE_METHOD];
}

-(void) loadDataFromNet:(NSString*) type{
   
    
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(page),@"page",@(40),@"pageSize",
                                                    [Global sharedClient].member_id, @"member_id",@"list",@"rtype",nil];
    RACSignal* racSignal = [HttpClient  racPOSTWthURL:[Util makeRequestUrl:@"integralmall" tp:@"getaddress"]  params:diction];
    [racSignal subscribeNext:^(id result) {
        NSError* erro;
        if(![type isEqualToString:MORE_METHOD]){
            
            [self.tableData removeAllObjects];
        }
        
//        self.dataArr =[AddressModel arrayOfModelsFromDictionaries:result[@"list"] error:&erro];
//        [self.tableData addObjectsFromArray:self.dataArr];
            
        [self.tableData addObjectsFromArray: [AddressModel arrayOfModelsFromDictionaries:result[@"list"] error:&erro]];
        isEnd =     [result[@"isEnd"] isEqualToString:@"true"] ? YES : NO;
        
        
       
        [self.successObject sendNext:@"0"];
        
        //解析数据
    } error:^(NSError *error) {
        //错误处理
        page--;
        [self.errorObject sendNext:error];
    }];

}

-(void) updateAddress:(int) index{
    AddressModel* model = self.tableData[index];
    [self addAddress:model];
    
}

-(void) addAddress:(AddressModel*) model{
    
    NSMutableDictionary*diction= [[NSMutableDictionary alloc] initWithDictionary: [model toDictionary]];
    [diction setObject:[Global sharedClient].member_id forKey:@"member_id"];
    RACSignal* racSignal = [HttpClient  racPOSTWthURL:[Util makeRequestUrl:@"integralmall" tp:@"addaddress"]  params:diction];
    [racSignal subscribeNext:^(id result) {
        NSError* erro;
        [self.successObject sendNext:@"1"];
        //解析数据
    } error:^(NSError *error) {
        //错误处理
        page--;
        [self.errorObject sendNext:error];
    }];
    
}

-(void) deleteAddress:(AddressModel*) model{
    NSMutableDictionary*diction= [[NSMutableDictionary alloc] initWithDictionary: [model toDictionary]];
    RACSignal* racSignal = [HttpClient  racPOSTWthURL:[Util makeRequestUrl:@"integralmall" tp:@"deladdress"]  params:@{@"id":model.id}];
    [racSignal subscribeNext:^(id result) {
        NSError* erro;
        [self.successObject sendNext:@"3"];
        //解析数据
    } error:^(NSError *error) {
        //错误处理
        page--;
        [self.errorObject sendNext:error];
    }];
    
}


-(instancetype) init{
    self = [super init];
    if(self != nil){
        page = 0;
    }
    return self;
}

@end
