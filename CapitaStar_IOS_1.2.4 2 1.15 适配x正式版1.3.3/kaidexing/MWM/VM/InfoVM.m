//
//  InfoVM.m
//  kaidexing
//
//  Created by dwolf on 2017/5/12.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "InfoVM.h"

@implementation InfoVM{
    @private
    NSMutableArray<InfoModel*>* infoModelList;
    InfoModel* recInfo;
    int page;
    Boolean isEnd;
}

-(NSMutableArray<InfoModel*>*) getInfoModeList{
    return infoModelList;
}

-(void) getConsultList:(NSString*) type{
    if(![type isEqualToString:MORE_METHOD]){
        page = 1;
    }else{
        if(isEnd){
            [self.successObject sendNext:nil];
            return;
        }
        page++;
    }
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].markID,@"mall_id",@(page),@"page",@(20),@"pageSize",[Global sharedClient].member_id, @"member_id",nil];
    RACSignal* racSignal = [HttpClient  racPOSTWthURL:[Util makeRequestUrl:@"index" tp:@"getallconsultlist"]  params:diction];
    
    [racSignal subscribeNext:^(id result) {
        NSError* erro;

        @try {
            recInfo = [[InfoModel alloc] initWithDictionary:result[@"rec_consult"] error:&erro];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        if(![type isEqualToString:MORE_METHOD]){
            [infoModelList removeAllObjects];
        }
        [infoModelList addObjectsFromArray: [InfoModel arrayOfModelsFromDictionaries:result[@"consultlist"] error:&erro]];
        isEnd =     [result[@"isend"] isEqualToString:@"true"] ? YES : NO;
        [self.successObject sendNext:nil];
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
        infoModelList = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
