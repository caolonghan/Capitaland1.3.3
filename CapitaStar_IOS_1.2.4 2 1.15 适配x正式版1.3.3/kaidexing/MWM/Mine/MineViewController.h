//
//  MineViewController.h
//  ZhuJC
//
//  Created by Kunee Hwang on 15/7/4.
//  Copyright (c) 2015年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "MyNBTabController.h"

@interface MineViewController : MyNBTabController

@property (strong,nonatomic)NSString *typeStr;//判断是否从主界面进入的

- (void)getUserInfo;
@end
