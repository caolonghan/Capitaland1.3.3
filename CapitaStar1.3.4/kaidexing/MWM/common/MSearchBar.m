//
//  MSearchBar.m
//  ABAS
//
//  Created by dwolf on 16/6/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MSearchBar.h"

@implementation MSearchBar
@synthesize bgColor,tfColor, newFrame,reSize,cornerRadius;

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    if(bgColor){
        self.backgroundImage = [self imageWithColor:bgColor size:rect.size];
    }
    if(tfColor){
        searchTextField.backgroundColor = tfColor;
    }
}

-(void) layoutSubviews{
    [super layoutSubviews];
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    self.barTintColor = [UIColor whiteColor];
    searchTextField = [[[self.subviews firstObject] subviews] lastObject];
    if(reSize){
        searchTextField.frame = newFrame;
    }
    searchTextField.layer.masksToBounds = YES;
    searchTextField.layer.cornerRadius = cornerRadius;
    
}

@end
