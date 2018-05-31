//
//  搜索列表 SearchListController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/16.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "PullingRefreshTableView.h"
#import "ReTableView.h"
@interface SearchListController : BaseViewController
@property (strong,nonatomic)ReTableView     *tableView1;
@property (strong,nonatomic)NSString                    *typeStr;
@end
