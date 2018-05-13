//
//  MarketRootController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MyNBTabBar.h"
#import "DXPopover.h"
#import "StoreDetailsController.h"

@interface MarketRootController : BaseViewController<rootIndex>

@property (strong, nonatomic) MyNBTabBar *tabBar;
@property (strong,nonatomic)  UIView     *container;
@property (weak, nonatomic)   MyNBTabController * currentVC;
@property (nonatomic, strong) DXPopover *popover;



@end
