//
//  ReTableView.m
//  RefreshTableView
//
//  Created by 朱巩拓 on 2016/11/2.
//  Copyright © 2016年 朱巩拓. All rights reserved.
//

#import "ReTableView.h"
#import "MJRefresh.h"
#import "Const.h"
@interface ReTableView()

@property (strong,nonatomic)NSMutableArray *idleImages;
@property (strong,nonatomic)NSMutableArray *refreshingImages;

@end

@implementation ReTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (![Global sharedClient].is_EndRefresh) {
            NSLog(@"刷新");
            if (![Global sharedClient].is_EndheadRefresh){
                // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
                MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
                [header setImages:self.idleImages forState:MJRefreshStateIdle];//设置普通状态的动画图片
                // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
                [header setImages:self.refreshingImages forState:MJRefreshStatePulling];
                // 设置正在刷新状态的动画图片
                [header setImages:self.refreshingImages forState:MJRefreshStateRefreshing];
                header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间
                header.stateLabel.hidden = YES;// 隐藏状态
                self.mj_header = header;
            }
            if (![Global sharedClient].is_EndFooderRefresh) {
                
                MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
                // 设置文字
                [footer setTitle:@"  " forState:MJRefreshStateIdle];
                [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
                [footer setTitle:@"  " forState:MJRefreshStateNoMoreData];//隐藏加载完成文字
                // 设置尾部
                self.mj_footer = footer;
            }
        }
    }
    return self;
}

-(void)loadNewData{
    NSLog(@"刷新tableView");
    [self endFooderRefresh];
    if(_refreshTVDelegate &&[_refreshTVDelegate respondsToSelector:@selector(tableView_refresh:)]){
        [_refreshTVDelegate tableView_refresh:REFRESH_METHOD];
    }
}

//底部刷新代理
-(void)loadMoreData{
    NSLog(@"加载tableView");
    [self endHeadRefresh];
    if(_refreshTVDelegate &&[_refreshTVDelegate respondsToSelector:@selector(tableView_refresh:)]){
        [_refreshTVDelegate tableView_refresh:MORE_METHOD];
    }
}


-(void)tableViewDidFinishedLoading{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
-(void)endHeadRefresh{
    [self.mj_header endRefreshing];
}
-(void)endFooderRefresh{
    [self.mj_footer endRefreshing];
}
-(void)noticeNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

-(NSMutableArray*)idleImages{
    if (!_idleImages) {
        // 设置普通状态的动画图片
        _idleImages = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"smallLogo"]];
        [_idleImages addObject:image];
    }
    return _idleImages;
}

-(NSMutableArray*)refreshingImages{
    if (!_refreshingImages) {
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        _refreshingImages = [NSMutableArray array];
        for (int i = 1; i<=32; i++) {
            UIImage *image = [UIImage imageNamed:@"smallLogo"];
            [_refreshingImages addObject:image];
        }
    }
    return _refreshingImages;
}

@end
