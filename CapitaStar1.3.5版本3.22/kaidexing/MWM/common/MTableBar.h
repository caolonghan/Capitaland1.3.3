//
//  MTableBar.h
//  EAM
//
//  Created by dwolf on 16/6/21.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

//协议定义
@protocol MTableBarDelegate <NSObject>
- (void)afterSelect:(int) index;
@end

@interface MTableBar : UIView
@property(nonatomic,strong) NSArray* names;
@property(nonatomic,strong) NSArray* imgs;
@property(nonatomic,strong) id delegate;
@property(nonatomic,strong) UIColor* textColor;
@property(nonatomic,strong) UIColor* textSelectColor;
@property(nonatomic,strong) UIColor* lineColor;
@property(nonatomic,strong) UIColor* lineSelectColor;
@property(nonatomic,strong) UIFont* textFont;
@property int defaultSelect;
@property int lineMargin;
-(void) loadInitData;
-(void) loadInitDataImg;
-(void) resizeTab;

@end
