//
//  CitySearchController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectionBoxView.h"
#import "TextSearchController.h"
@interface CitySearchController : BaseViewController<selectionDelegate,textTouch>

@property (strong,nonatomic)NSString        *caixiID; //业态
@property (strong,nonatomic)NSString        *pushkeyStr;//从上个界面传过来的搜索字符串
@property (strong,nonatomic)NSString        *yetaiStr;//业态名字
@end
