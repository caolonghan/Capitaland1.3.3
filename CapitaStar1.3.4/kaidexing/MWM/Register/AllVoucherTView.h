//
//  AllVoucherTView.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "MyVoucherViewController.h"

@interface AllVoucherTView : PullingRefreshTableView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain)NSMutableArray * dataArr;
@property(nonatomic, retain)MyVoucherViewController * parent;
@property(nonatomic, retain)UIView * allfooterView;
@end
