//
//  OverdueTView.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTicketViewController;

@interface OverdueTView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain)MyTicketViewController * viewController;
@property(nonatomic, retain)NSArray * dataArr;

@end
