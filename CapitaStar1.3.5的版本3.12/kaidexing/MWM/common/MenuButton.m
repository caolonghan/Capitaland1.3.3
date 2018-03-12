//
//  MenuButton.m
//  HNGant-HaoLan
//
//  Created by jsyuchi on 15/7/6.
//  Copyright (c) 2015年 jsyuci. All rights reserved.
//

#import "MenuButton.h"
#import "UIUtil.h"
#define kImageRate 0.5
#define imgTop_H 10
#define text_Img_Top_H 7
@implementation MenuButton

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
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height/2+M_WIDTH(4);
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = M_WIDTH(25);
    return CGRectMake(titleX, titleY, titleW, titleH);

}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX = (contentRect.size.width  - M_WIDTH(22))/2;
    CGFloat imageY = M_WIDTH(18);
//    CGFloat imageW = contentRect.size.width;
//    CGFloat imageH = contentRect.size.height * kImageRate;
    CGFloat imageW = M_WIDTH(22);
    CGFloat imageH = M_WIDTH(22);
    return CGRectMake(imageX, imageY, imageW, imageH);

}

@end
