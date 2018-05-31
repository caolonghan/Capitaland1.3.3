//
//  ReTableView.h
//  RefreshTableView
//
//  Created by 朱巩拓 on 2016/11/2.
//  Copyright © 2016年 朱巩拓. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZhuRefreshTableView <NSObject>

-(void)tableView_refresh:(NSString*)type;

@end

@interface ReTableView : UITableView
-(void)tableViewDidFinishedLoading;//结束所有刷新
-(void)endHeadRefresh;//结束顶部刷新
-(void)endFooderRefresh;//结束底部刷新
-(void)noticeNoMoreData;//底部显示加载完毕

@property (assign,nonatomic)id<ZhuRefreshTableView>refreshTVDelegate;

@end
