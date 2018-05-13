//
//  EndedTableView.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "ReTableView.h"
@class ActivityViewController;

@interface EndedTableView : ReTableView <UITableViewDataSource, UITableViewDelegate,ZhuRefreshTableView>

@property(nonatomic, strong)ActivityViewController * viewController;
@property(nonatomic, strong)NSMutableArray * dataArr;

@end
