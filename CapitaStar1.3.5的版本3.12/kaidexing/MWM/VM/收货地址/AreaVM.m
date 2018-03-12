//
//  AreaVM.m
//  kaidexing
//
//  Created by dwolf on 2017/6/10.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "AreaVM.h"
#import "DBDeal.h"

@implementation AreaVM


-(void) loadData:(NSString*) pId level:(int)level{
    RACSignal* racSignal = [HttpClient  racPOSTWthURL:[Util makeRequestUrl:@"integralmall" tp:@"city"]  params:@{@"id":pId}];
    [racSignal subscribeNext:^(id result) {
        NSError* erro;
        [self.successObject sendNext:@{@"level":@(level),@"data":result }];
        //解析数据
    } error:^(NSError *error) {
        //错误处理
        page--;
        [self.errorObject sendNext:error];
    }];
}

-(void)loadArea:(NSString *)pid type:(int)type
{
    
    NSArray *array1=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@ %@",@" where pid = ",pid]];
    [self.successObject sendNext:@{@"level":@(type),@"data":array1 }];
}

-(id)loadArea:(NSString *)id
{
    NSArray *array1=[[DBDeal sharedClient] queryArea:[NSString stringWithFormat:@"%@ %@",@" where id = ",id]];
    return array1[0];
}

@end
