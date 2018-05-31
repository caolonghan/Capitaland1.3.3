//
//  CardInfoView.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "CardInfoView.h"

@implementation CardInfoView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewWithType:type];
    }
    return self;
}
- (void)createViewWithType:(NSInteger)type
{
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-80)/2, 10, 80, 21)];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:headLabel];
   
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-54, self.frame.size.width, 44)];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(knownTouch:) forControlEvents:UIControlEventTouchUpInside];
   
    [self addSubview:btn];
    if (type==0) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headLabel.frame)+10, self.frame.size.width-20, 60)];
        mainLabel.font = [UIFont systemFontOfSize:15];
        mainLabel.numberOfLines = 0;
        UIImageView *bankImageView = [[UIImageView alloc]init];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bankImageView.frame), self.frame.size.width, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        mainLabel.frame = CGRectMake(10, CGRectGetMaxY(headLabel.frame)+10, self.frame.size.width-20, 60);
        bankImageView.frame = CGRectMake(10, CGRectGetMaxY(mainLabel.frame), self.frame.size.width-20, 80);
        headLabel.text = @"有效期";
        mainLabel.text = @"有效期是信用卡正面卡号下方的四位数字，格式为月份/年，如04/20";
        bankImageView.image = [UIImage imageNamed:@"showBank"];
        [self addSubview:mainLabel];
        [self addSubview:bankImageView];
        [self addSubview:line];
    }else if (type==1){
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headLabel.frame)+10, self.frame.size.width-20, 60)];
        mainLabel.font = [UIFont systemFontOfSize:15];
        mainLabel.numberOfLines = 0;
        UIImageView *bankImageView = [[UIImageView alloc]init];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bankImageView.frame), self.frame.size.width, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        mainLabel.frame = CGRectMake(10, CGRectGetMaxY(headLabel.frame)+10, self.frame.size.width-20, 60);
        bankImageView.frame = CGRectMake(10, CGRectGetMaxY(mainLabel.frame), self.frame.size.width-20, 80);
        headLabel.text = @"有效期";
        mainLabel.text = @"有效期是信用卡正面卡号下方的四位数字，格式为月份/年，如04/20";
        bankImageView.image = [UIImage imageNamed:@"showBank"];
        [self addSubview:mainLabel];
        [self addSubview:bankImageView];
        [self addSubview:line];
    }else{
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headLabel.frame)+10, self.frame.size.width-20,90)];
        mainLabel.font = [UIFont systemFontOfSize:15];
        mainLabel.numberOfLines = 0;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(mainLabel.frame), self.frame.size.width, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        headLabel.text = @"手机号";
        mainLabel.text = @"银行卡预留手机号是在银行办卡时填写的手机号，若遗忘、换号可以联系银行客服电话处理";
        
        [self addSubview:mainLabel];
        [self addSubview:line];
    }
    
    
   
}
- (void)knownTouch:(UIButton *)sender {
    [self.delegate known];
}

@end
