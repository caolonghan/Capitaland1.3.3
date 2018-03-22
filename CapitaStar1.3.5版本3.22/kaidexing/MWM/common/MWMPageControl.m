//
//  MWMPageControl.m
//  ShouYi
//
//  Created by Hwang Kunee on 14-1-6.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "MWMPageControl.h"

@implementation MWMPageControl


@synthesize activeImage = _activeImage,inactiveImage =_inactiveImage;

- (id)initWithFrame:(CGRect)frame
{
    // if the super init was successfull the overide begins.
    if ((self = [super initWithFrame:frame]))
    {
        // allocate two bakground images, one as the active page and the other as the inactive
        //_activeImage = [UIImage imageNamed:@"pagecontrol_dot_selected"];
        //_inactiveImage = [UIImage imageNamed:@"pagecontrol_dot"];
    }
    return self;
}

// Update the background images to be placed at the right position
-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        
        for (UIView* subview in dotView.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView*)subview;
                break;
            }
        }
        
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dotView.frame.size.width, dotView.frame.size.height)];
            [dotView addSubview:dot];
        }
        
        if (i == self.currentPage)
        {
            if(self.activeImage)
                dot.image = _activeImage;
        }
        else
        {
            if (self.inactiveImage)
                dot.image = _inactiveImage;
        }
    }
}

// overide the setCurrentPage
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}
@end
