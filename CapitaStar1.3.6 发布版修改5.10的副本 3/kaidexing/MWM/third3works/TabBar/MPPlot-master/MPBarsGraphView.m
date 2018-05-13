//
//  MPBarsGraphView.m
//  MPPlot
//
//  Created by Alex Manzella on 22/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPBarsGraphView.h"
#import "Const.h"

@implementation MPBarsGraphView

#define  BOTTOM_HEIGHT 14
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        currentTag=-1;
        
        self.topCornerRadius=-1;
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    
    if (self.values.count && !self.waitToUpdate) {
        
        
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        
        [self addBarsAnimated:shouldAnimate];
        
        [self.graphColor setStroke];

        UIBezierPath *line=[UIBezierPath bezierPath];
        
        [line moveToPoint:CGPointMake(0, self.height - BOTTOM_HEIGHT)];
        [line addLineToPoint:CGPointMake(self.width, self.height - BOTTOM_HEIGHT)];
        [line setLineWidth:1];
        [line stroke];
        [self drawHLine];
    }
}

- (void)addBarsAnimated:(BOOL)animated{
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    if (animated) {
        self.layer.masksToBounds=YES;
    }
    
    CGFloat barWidth=(self.width)/(points.count*2-1);
    CGFloat radius=barWidth*(self.topCornerRadius >=0 ? self.topCornerRadius : 0.3);
    for (NSInteger i=0;i<points.count;i++) {
        
        CGFloat height=[[points objectAtIndex:i] floatValue]*(self.height-PADDING - BOTTOM_HEIGHT);
        //CGFloat height=[[points objectAtIndex:i] floatValue]*(self.height-PADDING*2 - BOTTOM_HEIGHT)+PADDING;
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(barWidth/2, self.height)];
        [button setBackgroundColor:self.graphColor];
        button.frame=CGRectMake((barWidth*i+barWidth*i), animated ? self.height - BOTTOM_HEIGHT : self.height-height -BOTTOM_HEIGHT, barWidth, animated ? height+20 : height);
        
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = button.bounds;

        
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)].CGPath;

        button.layer.mask=maskLayer;
        
       // [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [self addSubview:button];
        
        if(i%4 == 0 || i == (points.count - 1)){
            UILabel* xLabel = [[UILabel alloc] init];
            xLabel.text = self.xtags[i];
            xLabel.font = [UIFont systemFontOfSize:12];
            xLabel.textColor = [UIColor whiteColor];
            [xLabel sizeToFit];
            CGRect frame = xLabel.frame;
            if(i == 0){
                frame.origin.x = 0;
            }else if( i == (points.count - 1)){
                frame.origin.x = self.frame.size.width - frame.size.width;
            }else{
                frame.origin.x = (barWidth*i+barWidth*i) + barWidth/2 - frame.size.width/2;
            }
            frame.origin.y = self.height - frame.size.height;
            xLabel.frame = frame;
            [self addSubview:xLabel];
        }
        
        
        if (animated) {
            [UIView animateWithDuration:self.animationDuration delay:i*0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.y=self.height-height-20- BOTTOM_HEIGHT;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    button.frame=CGRectMake(barWidth+(barWidth*i+barWidth*i), self.height-height- BOTTOM_HEIGHT, barWidth, height);
                }];
            }];
        }
        
        [buttons addObject:button];
        
        

        
    }
    


    shouldAnimate=NO;
    
}

-(void) drawHLine{
    int incrValue = (self.valueRanges.max - self.valueRanges.min)/5;
    float beginY = PADDING;
    float height = self.frame.size.height - PADDING - BOTTOM_HEIGHT;
    float incHeight = height/5.0;
    for(int i = 0; i < 5; i ++) {
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, beginY - 10, 40, 10);
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textColor = RGBACOLOR(255, 255, 255, 0.5);
        titleLabel.text = [NSString stringWithFormat:@"%.0f" ,(self.valueRanges.max - i*incrValue)];
        {
            //获得处理的上下文
            
            /*
             CGContextRef
             context = UIGraphicsGetCurrentContext();
             //指定直线样式
             CGContextSetLineCap(context,
             kCGLineCapSquare);
             //直线宽度
             
             
             CGContextSetLineWidth(context,
             1.0);
             
             
             //设置颜色
             CGContextSetRGBStrokeColor(context,
             1.0, 1.0, 1.0, 1.0);
             
             
             //开始绘制
             CGContextBeginPath(context);
             //画笔移动到点(31,170)
             
             
             CGContextMoveToPoint(context,
             0, beginY);
             
             
             //下一点
             CGContextAddLineToPoint(context,
             self.frame.size.width,beginY);
             
             
             //绘制完成
             CGContextStrokePath(context);*/
            UIView* lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, beginY, self.frame.size.width, 1);
            lineView.backgroundColor = titleLabel.textColor = RGBACOLOR(255, 255, 255, 0.3);
            [self addSubview:lineView];
        }
        [self addSubview:titleLabel];
        beginY = beginY + incHeight;
    }
    
}

- (CGFloat)animationDuration{
    return _animationDuration>0.0 ? _animationDuration : .25;
}





- (void)animate{
    
    self.waitToUpdate=NO;
    
    shouldAnimate=YES;
    
    [self setNeedsDisplay];
}







@end
