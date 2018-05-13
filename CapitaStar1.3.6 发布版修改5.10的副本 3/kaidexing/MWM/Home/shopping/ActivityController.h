//
//  ActivityController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyNBTabController.h"
#import "SelectionBoxView.h"
#import "MTableBar.h"
#import "ScreenViewController.h"

@interface ActivityController : MyNBTabController<MTableBarDelegate,screeViewDelegate>


@property (strong,nonatomic)NSString  *isType;//0 未选择商场进入  1已选择商场进入

@property (strong,nonatomic)NSString  *buttomH;//底部有tabBar的  1是有

@end
