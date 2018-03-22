//
//  FindStoreController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/23.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectionBoxView.h"
#import "ScreenViewController.h"

@interface FindStoreController : BaseViewController<selectionDelegate,screeViewDelegate>

@property (strong,nonatomic)NSString        *setInType;//0 不需要商场id登录   1 需要
@property (strong,nonatomic)NSString        *caixiID;//业态id
@property (strong,nonatomic)NSString        *pushkeyStr;//从上个界面传过来的搜索字符串
@property (strong,nonatomic)NSString        *yetaiStr;//业态名字
@end
