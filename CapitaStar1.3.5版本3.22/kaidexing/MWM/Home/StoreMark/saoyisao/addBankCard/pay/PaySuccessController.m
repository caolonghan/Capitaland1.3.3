//
//  PaySuccessController.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "PaySuccessController.h"

@interface PaySuccessController ()

@end

@implementation PaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.moneyLabel.text = _money;
    self.bankLabel.text = _bankName;
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}



@end
