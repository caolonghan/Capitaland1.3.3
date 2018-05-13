//
//  MyNBTabBar.h
//  NB2
//
//  Created by kohn on 13-11-16.
//  Copyright (c) 2013年 Kohn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyNBTabController;
@protocol MyNBTabBarDelegate <NSObject>

- (void)switchViewController:(MyNBTabController *)viewController;
-(void)afterTouchUp;

@end


@interface MyNBTabBar : UIView
@property (nonatomic,assign)id<MyNBTabBarDelegate> delegate;


- (id)initWithItems:(NSArray *)items;

//frame 由外围设置
- (id)initWithItemsNoFrame:(NSArray *)items;

//设置底部导航背景颜色
//- (void) setBackgroundColor:(UIColor *)backgroundColor;

- (void)showDefauls;
- (void)showIndex:(NSInteger)index;

- (void)touchDownForButton:(UIButton *)button;
- (void)touchUpForButton:(UIButton *)button;

-(void) setButtonsBackColor;
@end
