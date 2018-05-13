//
//  ViewController.h
//  Foodspotting
//
//  Created by jetson  on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MyNBTabBar.h"
#import "DXPopover.h"


@interface RootViewController : BaseViewController


@property (weak, nonatomic) IBOutlet MyNBTabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) MyNBTabController * currentVC;
@property (nonatomic, strong) DXPopover *popover;
@property (assign, nonatomic) BOOL haveRemotemsg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabbarHeight;


@end
