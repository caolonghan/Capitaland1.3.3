//
//  MaleView.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MaleView.h"

#import "Const.h"

@implementation MaleView

-(void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelMale:) name:@"CancelMale" object:nil];
    
    [self createSubviews:self.frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelMale:) name:@"CancelMale" object:nil];
        
        [self createSubviews:frame];
    }
    return self;
}

- (void)createSubviews:(CGRect)frame {
    
    CGFloat self_Width = CGRectGetWidth(frame);
    CGFloat self_Height = CGRectGetHeight(frame);
    
    CGFloat bigView_WorH = self_Height ;
    
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, bigView_WorH, bigView_WorH)];
    _bigView.layer.cornerRadius = self_Height / 2.0;
    _bigView.layer.masksToBounds = YES;
    _bigView.layer.borderWidth = 1;
    _bigView.layer.borderColor = COLOR_RED.CGColor;
    
    [self addSubview:_bigView];
    
    
    CGFloat smallView_Width = bigView_WorH * 0.55;
    CGFloat xOrY = (bigView_WorH - smallView_Width) / 2.0;
    
    _smallView = [[UIView alloc] initWithFrame:CGRectMake(xOrY, xOrY, smallView_Width, smallView_Width)];
    _smallView.layer.cornerRadius = smallView_Width / 2.0;
    _smallView.layer.masksToBounds = YES;
    _smallView.backgroundColor = COLOR_RED;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelFemale" object:nil];
    
    [_bigView addSubview:_smallView];
    
    
    CGFloat maleLab_Wdith = self_Width - 1 - bigView_WorH - 6;
    CGFloat maleLab_Height = self_Height * 2 / 3;
    CGFloat maleLab_Y = (self_Height-maleLab_Height) / 2.0;
    
    _maleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bigView.frame)+6, maleLab_Y, maleLab_Wdith, maleLab_Height)];
    _maleLab.font = DESC_FONT;
    _maleLab.textColor = COLOR_FONT_BLACK;
    _maleLab.text = @"男";
    
    [self addSubview:_maleLab];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_smallView.hidden) {
        
        self.bigView.layer.borderColor = COLOR_RED.CGColor;
        self.smallView.hidden = NO;
        self.maleLab.textColor = COLOR_FONT_BLACK;
        self.isSelect = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelFemale" object:_group];
    }
}

- (void)cancelMale:(NSNotification *)notification {
    NSString* group = [notification object];
    if(![group isEqualToString:_group]){
        return;
    }
    self.bigView.layer.borderColor = COLOR_FONT_SECOND.CGColor;
    self.smallView.hidden = YES;
    self.maleLab.textColor = COLOR_FONT_SECOND;
    self.isSelect = NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
