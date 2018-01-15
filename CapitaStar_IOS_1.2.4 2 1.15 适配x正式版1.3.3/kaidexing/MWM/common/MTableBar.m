//
//  MTableBar.m
//  EAM
//
//  Created by dwolf on 16/6/21.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MTableBar.h"
#import "Const.h"
#import "MLabel.h"
@implementation MTableBar

-(void) loadInitData{
    float width = self.frame.size.width/_names.count;
    for(int i = 0 ; i < _names.count; i ++){
        UIView* itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(i * width, 0, width, self.frame.size.height);
        itemView.tag = i;
        [self addSubview:itemView];
        MLabel* label = [[MLabel alloc] init];
        label.frame = CGRectMake(0, 0, width, CGRectGetHeight(itemView.frame) - 5);
        label.textColor = _textColor;
        label.font = _textFont;
        label.text = _names[i];
        label.tag = 200;
        label.textAlignment = NSTextAlignmentCenter;
        [itemView addSubview:label];
        
        UIView* lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(_lineMargin, CGRectGetMaxY(label.frame), width - 2*_lineMargin, 2);
        lineView.backgroundColor = _lineColor;
        lineView.tag = 201;
        [itemView addSubview:lineView];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap:)];
        [itemView addGestureRecognizer:tap];
    }
//    UIView* lineView = [[UIView alloc] init];
//    lineView.backgroundColor = COLOR_LINE;
//    lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
//    [self addSubview:lineView];
    [self selectIndex:_defaultSelect];
}

-(void) loadInitDataImg{
    [UIUtil removeSubView:self];
    float width = self.frame.size.width/_names.count;
    for(int i = 0 ; i < _names.count; i ++){
        UIView* itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(i * width, 0, width, self.frame.size.height);
        itemView.tag = i;
        [self addSubview:itemView];
        MLabel* label = [[MLabel alloc] init];
        label.frame = CGRectMake(0, 0, width, CGRectGetHeight(itemView.frame)-4);
        label.textColor = _textColor;
        label.font = _textFont;
        label.text = _names[i];
        label.tag = 200;
        label.textAlignment = NSTextAlignmentCenter;
        if(i < _imgs.count && ![Util isNull:_imgs[i]]){
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_names[i]];
            
            if(true){
                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                
                // 表情图片
                attch.image = [UIImage imageNamed:_imgs[i]];
                // 设置图片大小
                attch.bounds = CGRectMake(4, -2, 16 , 12);
                
                // 创建带有图片的富文本
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri appendAttributedString:string];
            }
            // 用label的attributedText属性来使用富文本
            label.attributedText = attri;

        }
        [itemView addSubview:label];
        
        UIView* lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(_lineMargin,CGRectGetHeight(self.frame)-1, width - 2*_lineMargin, CGRectGetHeight(itemView.frame) - CGRectGetHeight(label.frame) - 1);
        lineView.backgroundColor = _lineColor;
        lineView.tag = 201;
        [itemView addSubview:lineView];                               
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap:)];
        [itemView addGestureRecognizer:tap];
    }
//    UIView* lineView = [[UIView alloc] init];
//    lineView.backgroundColor = COLOR_LINE;
//    lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
//    [self addSubview:lineView];
    [self selectIndex:_defaultSelect];
}

-(void) onItemTap:(UITapGestureRecognizer*) tap{
    [self selectIndex:(int)tap.view.tag];
}

-(void) selectIndex:(int) index{
    for(UIView* itemView in self.subviews){
        int tag = (int)itemView.tag;
        MLabel* label = [itemView viewWithTag:200];
        UIView* lineView =[itemView viewWithTag:201];
        if(tag == index){
            label.textColor = _textSelectColor;
            lineView.backgroundColor = _lineSelectColor;
        }else{
            label.textColor = _textColor;
            lineView.backgroundColor = _lineColor;
        }
    }
    if([_delegate respondsToSelector:@selector(afterSelect:)]){
        [_delegate afterSelect:index];
    }
}

-(void) resizeTab{
    int i = 0;
    for(UIView* itemView in self.subviews){
        MLabel* label = [itemView viewWithTag:200];
        if(label != nil){
            label.text = _names[i];
            i++;
        }
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) layoutSubviews{
    [super layoutSubviews];
    
}

@end
