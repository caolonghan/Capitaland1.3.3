//
//  DownLoadAnimationView.m
//  sightpDemo
//
//  Created by YangTengJiao on 16/9/14.
//  Copyright © 2016年 YangTengJiao. All rights reserved.
//

#import "DownLoadAnimationView.h"

@implementation DownLoadAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self creatView];
    }
    return self;
}

- (void)creatView{
    [[NSBundle mainBundle] loadNibNamed:@"DownLoadAnimationView" owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    [self startScrollAnimation];
}


- (void)startScrollAnimation {
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.2f;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = FLT_MAX;
    [self.scrollImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self .scrollImageView startAnimating];
}

@end
