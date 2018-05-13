//
//  KDSearchBar.m
//  kaidexing
//
//  Created by dwolf on 16/6/20.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "KDSearchBar.h"
#import "Const.h"

@implementation KDSearchBar

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.cornerRadius = 5;
        self.bgColor = [UIColor clearColor];
        self.tfColor = DEFAULT_BG_COLOR;
        self.reSize = YES;
    }
    return self;
}

-(id) init{
    self = [super init];
    if(self){
        self.bgColor = [UIColor clearColor];
        self.tfColor = DEFAULT_BG_COLOR;
        self.reSize = YES;
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    self.cornerRadius = rect.size.height/2;
}



@end
