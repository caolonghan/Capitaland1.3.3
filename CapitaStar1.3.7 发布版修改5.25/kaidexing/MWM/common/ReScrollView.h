//
//  ReScrollView.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZhuRefreshScrollView <NSObject>

-(void)tableView_refresh:(NSString*)type;

@end

@interface ReScrollView : UIScrollView

-(void)tableViewDidFinishedLoading;//结束所有刷新
-(void)endHeadRefresh;//结束顶部刷新
-(void)endFooderRefresh;//结束底部刷新

@property (assign,nonatomic)id<ZhuRefreshScrollView>refreshScrollDelegate;

@end
