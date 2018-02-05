//
//  LognAlerView.m
//  Community
//
//  Created by 未来社区 on 16/8/6.
//  Copyright © 2016年 李江. All rights reserved.
//

#import "LognAlerView.h"
#import "UIViewExt.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height



@implementation LognAlerView


- (IBAction)done:(id)sender {
    
//    if ([self.delegate respondsToSelector:@selector(clickindex:)]) {
    
//        [self.delegate clickindex:1];
//    }
    
//
    
    if ([_enter.titleLabel.text isEqualToString:@"我知道了"]) {
        [self.delegate clickindex:1];
    }else{
    
        [self.delegate clickindex:2];
        
    }
    
    [self dismiss];
    
}

- (instancetype)initWithTitle:(NSString *)title
                       title2:(NSString *)title2
                     delegate:(id<LognAlerViewdelegate>)delgate
{
    self = [super init];
    if (self) {
        self  = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
        self.titleLabel.text = title;
        self.tLabel2.text = title2;
        
        _delegate = delgate;
        self.width = SCREEN_WIDTH - 20;
        self.height = self.enter.bottom;
        self.center = [self topView].center;
        
    }
    return self;
    
    
}

- (void)awakeFromNib
{
    
    UIView *view = [UIView new];
    view.width = 5;
    
    //
    UIView *view1 = [UIView new];
    view1.width = 5;
    
}



- (void)show {
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    [[self topView] addSubview:_maskView];
    
    [[self topView] addSubview:self];
    self.center = [self topView].center;
    [self showAnimation];
    
}
- (void)dismiss {
    
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
    [self hideAnimation];

}

- (void)showAnimation {
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration             = 1;
    popAnimation.values               = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0)],
                                          [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 1.0f)],
                                          [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes             = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions      = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    
    [UIView animateWithDuration:.5 animations:^{
        
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}



-(UIView*)topView{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[0];
    
}
@end
