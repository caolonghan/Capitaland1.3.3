//
//  TextSearchController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "PullingRefreshTableView.h"

@protocol textTouch <NSObject>

-(void)settexthidden:(id)hidden;

@end

@interface TextSearchController : BaseViewController


@property (strong,nonatomic)NSString      *typrStr;//  0 是从城市搜索商店   1是商场搜索商店
@property (strong,nonatomic)NSString      *textFStr;//
@property (nonatomic)float                tableview_H;
@property (nonatomic)float                tableview_top;
@property (assign,nonatomic)id<textTouch>textdelegate;
@property (strong,nonatomic)PullingRefreshTableView     *tableView1;
-(void)NetWorkRequest:(NSString*)type;
-(void)refreshInterface;

@end
