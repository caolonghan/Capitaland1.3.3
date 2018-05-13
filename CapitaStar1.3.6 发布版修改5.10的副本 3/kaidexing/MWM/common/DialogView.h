//
//  DialogView.h
//  ZhuJC
//
//  Created by Kunee Hwang on 15/7/22.
//  Copyright (c) 2015年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogView : UIView

@property (nonatomic, weak)UIViewController *parentVC;


+ (instancetype)defaultPopupView;
- (UIImage *)imageWithColor:(UIColor *)color;

-(void)setTitle:(NSString*) title;
-(void)setList:(NSArray*) list defaultIndex:(int) defaultIndex;
@end
