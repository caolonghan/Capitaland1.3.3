//
//  CodePopView.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "CodePopView.h"

@interface CodePopView()

//弹窗
@property (nonatomic,retain) UIView *alertView;

@end
@implementation CodePopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{

    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [cancelBtn setImage:[UIImage imageNamed:@"Combined Shape"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelTouch) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-60, 10, 120, 21)];
    titleLabel.text = @"输入支付密码";
    UIView *line= [[UIView alloc]initWithFrame:CGRectMake(10, 44, self.frame.size.width-20, 1)];
    
    BJPasswordView * bjPass = [[BJPasswordView alloc]initWithFrame:CGRectMake(10, 60, self.frame.size.width-20, 45)];
    bjPass.delegate = self;
    [self addSubview:titleLabel];
    [self addSubview:bjPass];
    [self addSubview:cancelBtn];
    [self addSubview:line];
    
}
- (void)validatePass:(NSString*)pass{
    [self.delegate makeSureCode:pass];
    
}
- (void)cancelTouch{
    [self.delegate cancel];
}
@end
