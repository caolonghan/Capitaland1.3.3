//
//  UIView+category.m
//  cooba-iOS
//
//  Created by 郭四虎 on 16/4/25.
//  Copyright © 2016年 YouKu. All rights reserved.
//

#import "UIView+category.h"

@implementation UIView (category)

@dynamic bottom;

- (CGSize)size
{
    return self.frame.size;
}
-(void)setSize:(CGSize)newsize
{
    CGRect newframe = self.frame;
    newframe.size = newsize;
    self.frame = newframe;
}

- (CGPoint)origin
{
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin
{
    CGRect newframe = self.frame;
    newframe.origin = origin;
    self.frame = newframe;
}

- (float)x
{
    return CGRectGetMinX(self.frame);
    //return self.origin.x;
}
- (void)setX:(float)x
{
    CGRect newframe = self.frame;
    newframe.origin.x = x;
    self.frame = newframe;
}

- (float)y
{
    return CGRectGetMinY(self.frame);
    //return self.origin.y;
}
-(void)setY:(float)y
{
    CGRect newframe = self.frame;
    newframe.origin.y = y;
    self.frame = newframe;
}

- (float)width
{
    return CGRectGetWidth(self.frame);
    //return self.size.width;
}
- (void)setWidth:(float)width
{
    CGRect newframe = self.frame;
    newframe.size.width = width;
    self.frame = newframe;
}

- (float)height
{
    return CGRectGetHeight(self.frame);
    //return self.size.height;
}
- (void)setHeight:(float)height
{
    CGRect newframe = self.frame;
    newframe.size.height = height;
    self.frame = newframe;
}

- (float)bottom
{
    return CGRectGetMaxY(self.frame);
    //return self.y + self.height;
}

- (float)right
{
    return CGRectGetMaxX(self.frame);
}

@end
