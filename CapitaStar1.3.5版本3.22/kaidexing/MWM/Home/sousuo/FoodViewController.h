//
//  FoodViewController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/20.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectionBoxView.h"
#import "ScreenViewController.h"

@interface FoodViewController : BaseViewController<selectionDelegate,screeViewDelegate>

@property (strong,nonatomic)NSString    *setInType;//0 不需要商场id登录   1 需要

@end
