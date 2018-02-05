//
//  SKCommonButton.m
//  SKKit
//
//  Created by darren on 16/8/5.
//  Copyright © 2016年 maxin. All rights reserved.
//

#import "SKCommonButton.h"

@interface SKCommonButton()

/**图片的尺寸*/
@property (nonatomic,assign) CGRect imageFame;

/**图片的尺寸*/
@property (nonatomic,assign) CGRect titleFame;

@end

@implementation SKCommonButton

- (instancetype)initWithButtonFrame:(CGRect)frame andImageFrame:(CGRect)imageFrame andTitleFrame:(CGRect)titleFrame
{
    if (self == [super initWithFrame:frame]) {
        //设置图片居中
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        self.imageFame = imageFrame;
        self.titleFame = titleFrame;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{}

/*覆盖父类的方法，设置button的文字位置*/
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    return self.titleFame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    return self.imageFame;
}

@end
