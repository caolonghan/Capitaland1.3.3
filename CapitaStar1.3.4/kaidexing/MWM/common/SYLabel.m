//
//  SYLabel.m
//  ShouYi
//
//  Created by Hwang Kunee on 13-12-30.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "SYLabel.h"

@implementation SYLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setMinimumScaleFactor:9.0f];
        [self setNumberOfLines:0];
        [self setFont:[UIFont systemFontOfSize:12.0f]];
        [self setTextColor: [UIColor blackColor]];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentLeft];
    }
    return self;
}
@end
