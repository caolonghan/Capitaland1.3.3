//
//  SYView.m
//  ShouYi
//
//  Created by Hwang Kunee on 14-2-26.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "SYView.h"

@implementation SYView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(_delegate && [_delegate respondsToSelector:@selector(syOnTap:)]){
        [_delegate performSelectorOnMainThread:@selector(syOnTap:) withObject:self waitUntilDone:NO];
    }else{
        [super touchesEnded:touches withEvent:event];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
