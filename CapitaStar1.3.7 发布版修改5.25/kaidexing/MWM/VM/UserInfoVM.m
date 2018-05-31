//
//  UserInfoVM.m
//  用户信息VM
//
//  Created by dwolf on 2017/5/6.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "UserInfoVM.h"
#import "UserInfo.h"

@implementation UserInfoVM{
    @private
    UserInfo* userInfo;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

-(void) getUserInfo{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @"1000", @"source", nil];
    RACSignal* racSignal = [HttpClient  racPOSTWthURL:[Util makeRequestUrl:@"member" tp:@"pinfo"]  params:params];
    [racSignal subscribeNext:^(id result) {
                //成功返回(result class is NSDictionary)
        NSString *starScore = result[@"integralcount"];
        [[NSUserDefaults standardUserDefaults]setObject:result[@"nick_name"] forKey:@"nick_name"];
        
        [[NSUserDefaults standardUserDefaults]setObject:starScore forKey:@"integralcount"];
        userInfo = [[UserInfo alloc] initWithDictionary:result];
        [self.successObject sendNext:userInfo];
            } error:^(NSError *error) {
             //错误处理
            [self.errorObject sendNext:error];
            }];
}

@end
