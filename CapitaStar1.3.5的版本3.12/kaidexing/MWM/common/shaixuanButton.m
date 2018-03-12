//
//  shaixuanButton.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "shaixuanButton.h"
#import "UIUtil.h"
#define kImageRate 0.5
#define imgTop_H 10
#define text_Img_Top_H 7

@implementation shaixuanButton


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode    = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = M_WIDTH(5);
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width-M_WIDTH(10);
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
    
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}

@end
