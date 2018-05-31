//
//  ODRefreshControl.h
//  ODRefreshControl
//
//  Created by Fabio Ritrovato on 6/13/12.
//  Copyright (c) 2012 orange in a day. All rights reserved.
//
// https://github.com/Sephiroth87/ODRefreshControl
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void(^StartRefresh)();

/** 刷新控件的状态 */
typedef enum {
    /** 普通闲置状态 */
    GYRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    GYRefreshStatePulling,
    /** 正在刷新中的状态 */
    GYRefreshStateRefreshing,
    /** 即将刷新的状态 */
    GYRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    GYRefreshStateNoMoreData
} GYRefreshState;

@interface ODRefreshControl : UIControl {
    CAShapeLayer *_shapeLayer;
    CAShapeLayer *_arrowLayer;
    CAShapeLayer *_highlightLayer;
    UIView *_activity;
    BOOL _refreshing;
    BOOL _canRefresh;
    BOOL _ignoreInset;
    BOOL _ignoreOffset;
    BOOL _didSetInset;
    BOOL _hasSectionHeaders;
    CGFloat _lastOffset;
}

@property (nonatomic, readonly) BOOL refreshing;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@property (nonatomic, strong) UIColor *activityIndicatorViewColor; // iOS5 or more

@property ( nonatomic ,  strong )  StartRefresh block;

@property ( nonatomic  )  GYRefreshState  refreshState;

- (id)initInScrollView:(UIScrollView *)scrollView;

// use custom activity indicator
- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(UIView *)activity;

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing;

// Tells the control the refresh operation has ended
- (void)endRefreshing;

@end
