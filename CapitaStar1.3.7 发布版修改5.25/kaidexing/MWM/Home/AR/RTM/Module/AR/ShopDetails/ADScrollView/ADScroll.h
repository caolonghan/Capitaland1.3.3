//
//  ADScroll.h
//  ADScroll
//
//  Created by ZhaoChenHong on 15/8/27.
//  Copyright (c) 2015年 ZhaoChenHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ADScrollDelegate;
@protocol ADScrollDataSource;

@interface ADScroll : UIView
@property (nonatomic, assign) id<ADScrollDelegate> delegate;
@property (nonatomic, assign) id<ADScrollDataSource> dateSource;

@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) BOOL loop;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, assign) CGFloat scrollTimeInterval;

-(void)reloadData;
@end


@protocol ADScrollDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInADScroll:(ADScroll *) scrollView;

- (UIView *)ADScroll:(ADScroll *) scrollView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;
@end

@protocol  ADScrollDelegate <NSObject>
@optional
- (void)adScroll:(ADScroll *) scrollView selectedIndex:(NSInteger) index;
- (void)adScroll:(ADScroll *) scrollView changeTo:(NSInteger) index;
@end