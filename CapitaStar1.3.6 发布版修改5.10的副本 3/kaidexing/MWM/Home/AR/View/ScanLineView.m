//
//  ScanLineView.m
//  sightpDemo
//
//  Created by YangTengJiao on 2016/10/26.
//  Copyright © 2016年 YangTengJiao. All rights reserved.
//

#import "ScanLineView.h"

@interface ScanLineView()
@property (strong, nonatomic)UIImageView *lineImageView;
@property (nonatomic)double Width;
@property (nonatomic)double height;
@property (nonatomic)float time;
@property (nonatomic)BOOL isAnimation;
@end

@implementation ScanLineView 

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.Width = frame.size.width;
        self.height = frame.size.height;
        self.time = 3.0f;
        [self creatView];
        [self creatAnimation];
        [self hiddenScanLineView];
    }
    return self;
}

- (void)creatView {
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.Width, 10)];
    [self.lineImageView setImage:[UIImage imageNamed:@"scanLine"]];
    [self addSubview:self.lineImageView];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 20, 55, 55);
    [self.backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
}
- (void)creatAnimation {
    CABasicAnimation *positionOne = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionOne.toValue = [NSNumber numberWithFloat:self.height];
    positionOne.duration = self.time;
    positionOne.repeatCount = HUGE_VALF;
    positionOne.autoreverses = YES;
    positionOne.cumulative = NO;
    positionOne.removedOnCompletion = NO;
    positionOne.fillMode = kCAFillModeForwards;
    positionOne.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.isAnimation = YES;
    [self.lineImageView.layer addAnimation:positionOne forKey:@"AnimationMoveY"];
    [self pauseAnimation];
}
- (void)showScanLineView {
    self.hidden = NO;
    self.lineImageView.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    [self startAnimation];
}
- (void)hiddenScanLineView {
    [self pauseAnimation];
    self.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
}
- (void)showScanLine {
    self.lineImageView.hidden = NO;
//    self.backButton.hidden = NO;
    [self startAnimation];
}
- (void)hiddenScanLine {
    [self pauseAnimation];
    self.lineImageView.hidden = YES;
//    self.backButton.hidden = YES;
}
- (void)startAnimation {
    if (self.isAnimation)
        return;
    self.isAnimation = YES;
    CFTimeInterval pausedTime = [self.lineImageView.layer timeOffset];
    self.lineImageView.layer.speed = 1.0;
    self.lineImageView.layer.timeOffset = 0.0;
    self.lineImageView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.lineImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.lineImageView.layer.beginTime = timeSincePause;
}
- (void)pauseAnimation {
    CFTimeInterval pausedTime = [self.lineImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.lineImageView.layer.speed = 0.0;
    self.lineImageView.layer.timeOffset = pausedTime;
    self.isAnimation = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
