//
//  BankPayProtocolController.m
//  kaidexing
//
//  Created by companycn on 2018/3/26.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BankPayProtocolController.h"

@interface BankPayProtocolController ()

@end

@implementation BankPayProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"用户规则";
    [self loadHtmlByPath:BANKPAYPROTOCOLURL];
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
