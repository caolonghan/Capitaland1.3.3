//
//  IndexMallVM.m
//  kaidexing
//
//  Created by dwolf on 2017/5/27.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "IndexMallVM.h"

@implementation IndexMallVM{

}

@synthesize nearMall,cityMalls,recMalls;

-(void) getMallList:(LocationModel*) locModel{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                                locModel.lat, @"lat",
                                locModel.lng, @"lng", nil];
    RACSignal* racSignal = [HttpClient  racPOSTWthURL:
                            [Util makeRequestUrl:@"index" tp:@"getmalllist"]  params:params];
    [racSignal subscribeNext:^(id result) {
        //成功返回(result class is NSDictionary)
        NSError* error;
        nearMall = [[MallInfoModel alloc] initWithDictionary:result[@"near_mall"] error:&error ];
        recMalls = [MallInfoModel arrayOfModelsFromDictionaries:result[@"rec_malllist"] error:&error ];
        cityMalls = [CityMall arrayOfModelsFromDictionaries:result[@"city_malllist"] error:&error];
        [self.successObject sendNext:nil];
    } error:^(NSError *error) {
        //错误处理
        [self.errorObject sendNext:error];
    }];
    
}

@end
