//
//  FemaleView.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "FemaleView.h"

#import "Const.h"

@implementation FemaleView

-(void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFemale:) name:@"CancelFemale" object:nil];
    
    [self createSubviews:self.frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFemale:) name:@"CancelFemale" object:nil];
        
        [self createSubviews:frame];
    }
    return self;
}

- (void)createSubviews:(CGRect)frame {
    
    CGFloat self_Width = CGRectGetWidth(frame);
    CGFloat self_Height = CGRectGetHeight(frame);
    
    CGFloat bigView_WorH = self_Height;
    
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, bigView_WorH, bigView_WorH)];
    _bigView.layer.cornerRadius = self_Height / 2;
    _bigView.layer.masksToBounds = YES;
    _bigView.layer.borderWidth = 1;
    _bigView.layer.borderColor = COLOR_FONT_SECOND.CGColor;
    
    [self addSubview:_bigView];
    
    
    CGFloat smallView_Width = bigView_WorH * 0.55;
    CGFloat xOrY = (bigView_WorH - smallView_Width) / 2;
    
    _smallView = [[UIView alloc] initWithFrame:CGRectMake(xOrY, xOrY, smallView_Width, smallView_Width)];
    _smallView.layer.cornerRadius = smallView_Width / 2;
    _smallView.layer.masksToBounds = YES;
    _smallView.backgroundColor = COLOR_RED;
    _smallView.hidden = YES;
    
    [_bigView addSubview:_smallView];
    
    
    CGFloat femaleLab_Wdith = self_Width - 1 - bigView_WorH - 6;
    CGFloat femaleLab_Height = self_Height * 2 / 3;
    CGFloat femaleLab_Y = (self_Height-femaleLab_Height) / 2;
    
    _femaleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bigView.frame)+6, femaleLab_Y, femaleLab_Wdith, femaleLab_Height)];
    _femaleLab.font = DESC_FONT;
    _femaleLab.textColor = COLOR_FONT_SECOND;
    _femaleLab.text = @"女";
    
    [self addSubview:_femaleLab];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_smallView.hidden) {
        
        self.bigView.layer.borderColor = [UIColor redColor].CGColor;
        self.smallView.hidden = NO;
        self.isSelect = YES;
        self.femaleLab.textColor = COLOR_FONT_BLACK;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CancelMale" object:_group];
    }
}

- (void)cancelFemale:(NSNotification *)notification {
    NSString* group = [notification object];
    if(![group isEqualToString:_group]){
        return;
    }
    self.bigView.layer.borderColor = COLOR_FONT_SECOND.CGColor;
    self.smallView.hidden = YES;
    self.isSelect = NO;
    self.femaleLab.textColor = COLOR_FONT_SECOND;
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
