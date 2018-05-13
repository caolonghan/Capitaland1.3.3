//
//  WXCameraCoverView.m
//  WXCustomCamera
//
//  Created by wx on 16/7/8.
//  Copyright © 2016年 WX. All rights reserved.
//

#import "WXCameraCoverView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@interface WXCameraCoverView()
{
    float roundX;
    float roundY;
    float roundWidth;
}
@end
@implementation WXCameraCoverView
-(id)initWithRoundFrame:(CGRect)theFrame
{
    if (self = [super initWithFrame:CGRectMake(0, 179, SCREEN_WIDTH, SCREEN_HEIGHT-179)]) {
        self.opaque = NO;
        roundWidth = theFrame.size.width;
        roundX = theFrame.origin.x;
        roundY = theFrame.origin.y;
        self.image = [UIImage imageNamed:@"bg"];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        // MARK: circlePath
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH / 2, roundWidth/2) radius:roundWidth/2 startAngle:0 endAngle:2*M_PI clockwise:NO]];
        
        // MARK: roundRectanglePath
//        [path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 400, SCREEN_WIDTH - 22 * 20, 100) cornerRadius:15] ];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = path.CGPath;
        
        [self.layer setMask:shapeLayer];
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    // Get the current graphics context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor( context, [UIColor whiteColor].CGColor );
//    CGContextFillRect( context, rect );
//    
//    CGRect roundRect = CGRectMake(roundX, roundY, roundWidth, roundWidth);
//    if( CGRectIntersectsRect( roundRect, rect ) )
//    {
//        CGContextSetBlendMode(context, kCGBlendModeClear);
//        [[UIColor clearColor] set];
//        CGContextFillEllipseInRect( context, roundRect);
//    }
//}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // UIView will be "transparent" for touch events if we return NO
    //return (point.y < MIDDLE_Y1 || point.y > MIDDLE_Y2);
    return NO;
}
@end
