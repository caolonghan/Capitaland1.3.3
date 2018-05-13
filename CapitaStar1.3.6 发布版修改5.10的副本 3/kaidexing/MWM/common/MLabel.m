//
//  MLabel.m
//  ABAS
//
//  Created by dwolf on 16/6/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MLabel.h"

@implementation MLabel
@synthesize maxHeight, autoHeight;


-(void) autoSize{
    //设置一个行高上限
    CGSize size = CGSizeMake(self.frame.size.width,maxHeight);
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect tmpRect = [self.text boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil];
    
    CGSize labelsize = tmpRect.size;
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, labelsize.width, labelsize.height);
    
}

-(void) setAttrColor:(int) begin end:(int)length color:(UIColor*) color{
    NSMutableAttributedString *strAttr = nil;
    if(self.attributedText != nil){
        strAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else{
        strAttr = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    [strAttr addAttribute:NSForegroundColorAttributeName  value:color range:NSMakeRange(begin,length)];

    self.attributedText = strAttr;
}

-(void) setAttrFont:(int) begin end:(int)length font:(UIFont*) font{
    NSMutableAttributedString *strAttr = nil;
    if(self.attributedText != nil){
        strAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else{
        strAttr = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    [strAttr addAttribute:NSFontAttributeName value:font range:NSMakeRange(begin,length)];
    self.attributedText = strAttr;
}

-(void) setUnderLine:(int) begin end:(int)length{
    NSMutableAttributedString *strAttr = nil;
    if(self.attributedText != nil){
        strAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }else{
        strAttr = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    [strAttr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(begin,length)];
    self.attributedText = strAttr;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // Drawing code
   
}


@end
