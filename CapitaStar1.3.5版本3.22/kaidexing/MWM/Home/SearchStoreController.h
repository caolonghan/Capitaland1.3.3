//
//  SearchStoreController.h
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "TextSearchController.h"
@interface SearchStoreController : BaseViewController<textTouch>


@property (strong,nonatomic)NSArray   *idArray;//接收id，根据ID跳转不同界面和展示图标
@property (strong,nonatomic)NSArray   *titleAry;//接收标题文字

@property (strong,nonatomic)NSString    *hotType;// 0 表示从app进入，1 表示从商城首页进入

@end
