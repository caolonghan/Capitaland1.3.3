//
//  MPGraphView.m
//
//
//  Created by Alex Manzella on 18/05/14.
//  Copyright (c) 2014 mpow. All rights reserved.
//

#import "MPGraphView.h"
#import "UIBezierPath+curved.h"
#import "Const.h"


@implementation MPGraphView


+ (Class)layerClass{
    return [CAShapeLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        
        currentTag=-1;
        
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    if (self.values.count && !self.waitToUpdate) {
        
        ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
        ((CAShapeLayer *)self.layer).strokeColor = self.graphColor.CGColor;

        
        //画线
        ((CAShapeLayer *)self.layer).path = [self graphPathFromPointsForLine].CGPath;
        
        //填充
        if(self.fillColors.count){
            [self graphPathFromPoints];
        }
        [self drawHLine];
        [self drawXLabel];
        //[self graphPoints];
    }
}

- (UIBezierPath *)graphPathFromPoints{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1.0);
    
    BOOL fill=self.fillColors.count;
    
    
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        if(i==0)
            [path moveToPoint:point];
        
        if(_needDisplyPoint){
            MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(25, 25)];
            [button setBackgroundColor:self.graphColor];
            button.layer.cornerRadius=3;
            button.frame=CGRectMake(0, 0, 6, 6);
            button.center=point;
            [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [self addSubview:button];
            
            [buttons addObject:button];
        }
        
        [path addLineToPoint:point];
        
        
    }
    
    
    
    
    if (self.curved) {
        
        path=[path smoothedPathWithGranularity:20];
        
    }
    
    CGContextSetLineWidth(c, 0.0);
    if(fill){
        CGPoint last=[self pointAtIndex:points.count-1];
        CGPoint first=[self pointAtIndex:0];
        [path addLineToPoint:CGPointMake(last.x,self.height)];
        [path addLineToPoint:CGPointMake(first.x,self.height)];
        [path addLineToPoint:first];
        
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = path.CGPath;
        
        gradient.mask = maskLayer;
    }
    
    path.lineWidth= 0 ;
    
    
    return path;
}


- (UIBezierPath *)graphPathFromPointsForLine{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 1.0);
    
    BOOL fill=self.fillColors.count;
    
    
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
   
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        if(i == 0 && self.curved){
            point.x = 6;
        }
        
        if(i==0)
            [path moveToPoint:point];
        
        if(_needDisplyPoint){
            MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom tappableAreaOffset:UIOffsetMake(25, 25)];
            [button setBackgroundColor:self.graphColor];
            button.layer.cornerRadius=3;
            button.frame=CGRectMake(0, 0, 6, 6);
            button.center=point;
            [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [self addSubview:button];
            
            [buttons addObject:button];
        }
        
        [path addLineToPoint:point];
        
        
    }
    
    
    
    
    if (self.curved) {
        
        path=[path smoothedPathWithGranularity:20];
        
    }
    
    
    path.lineWidth=self.lineWidth ? self.lineWidth : 1;
    
    
    return path;
}

//画填充图顶部线
- (void)graphPathFromPoints3{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 0.8);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        
        if(i==0){
            CGPathMoveToPoint(path, NULL,
                              point.x,
                              point.y);
        }
        
        
        CGPathAddLineToPoint(path, NULL,
                             point.x,
                             point.y);
        
        
    }
    
    CGContextAddPath(c, path);
    CGContextSetStrokeColorWithColor(c, _graphColor.CGColor);
    CGContextSetLineWidth(c, 0.8);
    CGContextStrokePath(c);
    CGPathRelease(path);
}



//画线（圆点前uyao非实心链接使用）
- (void)graphPathFromPoints2{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 0.8);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        CGFloat xVal = point.x;
        if(point.x == 0){
            point.x = 3;
        }
        CGFloat yVal = point.y;
        
        if(yVal  == 0){
            point.y = 3;
        }
        
        if(yVal  == self.frame.size.height){
            point.y = yVal - 3;
        }
        
        if(xVal  == self.frame.size.width){
            point.x = xVal - 3;
        }

        
        
        if(i==0){
            CGPathMoveToPoint(path, NULL,
                              point.x,
                              point.y);
        }
        

        CGPathAddLineToPoint(path, NULL,
                             point.x,
                             point.y);
        
        
    }
    
    CGContextAddPath(c, path);
    CGContextSetStrokeColorWithColor(c, _graphColor.CGColor);
    CGContextSetLineWidth(c, 0.8);
    CGContextStrokePath(c);
    CGPathRelease(path);
}

-(void) drawHLine{
    int incrValue = (self.valueRanges.max - self.valueRanges.min)/5;
    float beginY = 0;
    float height = self.frame.size.height;
    float incHeight = height/5.0;
    for(int i = 0; i < 5; i ++) {
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(4, beginY - 10, 40, 10);
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
            lineView.frame = CGRectMake(4, beginY, self.frame.size.width - 8, 1);
            lineView.backgroundColor = RGBACOLOR(255, 255, 255, 0.5);
            [self addSubview:lineView];
        }
        [self addSubview:titleLabel];
        beginY = beginY + incHeight;
    }
    
}

-(void) drawXLabel{
    float beginY = self.frame.size.height - 14;
    float incWidth = (self.frame.size.width - 8) / (_xLabels.count - 1);
    BOOL needJump = NO;
    if(_xLabels.count > 7){
        needJump = YES;
    }
    for(int i = 0; i < _xLabels.count; i ++) {
        if(needJump && i%4 != 0 && i != (_xLabels.count - 1)){
            continue;
        }
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(4 + i * incWidth,beginY, 40, 14);
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = RGBACOLOR(255, 255, 255, 0.5);
        titleLabel.text = _xLabels[i];
        if(i != 0 && i != (_xLabels.count - 1)){
            [titleLabel sizeToFit];
            CGRect frame = titleLabel.frame;
            frame.origin.x = frame.origin.x - frame.size.width/2;
            titleLabel.frame = frame;
        }
        if(i == (_xLabels.count - 1)){
            [titleLabel sizeToFit];
            CGRect frame = titleLabel.frame;
            frame.origin.x = frame.origin.x - frame.size.width;
            titleLabel.frame = frame;
        }
        [self addSubview:titleLabel];
    }
    
}

//画圆点
- (void)graphPoints{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 0.8);
    
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        
        if(_needDisplyPoint){
            
            CGFloat xVal = point.x;
            if(point.x == 0){
                xVal = 3;
            }
            CGFloat yVal = point.y;
            
            if(yVal  == 0){
                yVal = 3;
            }
            
            if(yVal  == self.frame.size.height){
                yVal = yVal - 3;
            }
            
            if(xVal  == self.frame.size.width){
                xVal = xVal - 3;
            }
            
            //[ [UIColor whiteColor] setFill];
           // CGContextFillEllipseInRect(c, CGRectMake(xVal - 2, yVal - 2, 4, 4));
            [_graphColor setFill];
            CGContextFillEllipseInRect(c, CGRectMake(xVal - 3, yVal - 3, 6, 6));
           // CGContextFillEllipseInRect(c, CGRectMake(xVal - 2, yVal - 2, 4, 4));
            [[UIColor whiteColor] setFill];
            CGContextFillEllipseInRect(c, CGRectMake(xVal - 2, yVal - 2, 4, 4));
           // CGContextFillEllipseInRect(c, CGRectMake(xVal - 1, yVal - 1, 2, 2));
            
        }
    }

}


- (CGPoint)pointAtIndex:(NSInteger)index{

    CGFloat space=(self.frame.size.width)/(points.count-1);
    if(points.count == 1){
        space = self.frame.size.width - PADDING;
    }

    
    return CGPointMake((space)*index,self.height-((self.height-PADDING*2)*[[points objectAtIndex:index] floatValue]+PADDING));
}



- (void)animate{
    
    if(self.detailView.superview)
        [self.detailView removeFromSuperview];

    
    
    gradient.hidden=1;
    
    ((CAShapeLayer *)self.layer).fillColor=[UIColor clearColor].CGColor;
    ((CAShapeLayer *)self.layer).strokeColor = self.graphColor.CGColor;
    
    ((CAShapeLayer *)self.layer).path = [self graphPathFromPoints].CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = self.animationDuration;
    animation.delegate=self;
    [self.layer addAnimation:animation forKey:@"MPStroke"];

    

    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    

    
    buttons=[[NSMutableArray alloc] init];
    
    CGFloat delay=((CGFloat)self.animationDuration)/(CGFloat)points.count;
    

    
    for (NSInteger i=0;i<points.count;i++) {
        
        
        CGPoint point=[self pointAtIndex:i];
        
        
        MPButton *button=[MPButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:self.graphColor];
        button.layer.cornerRadius=3;
        button.frame=CGRectMake(0, 0, 6, 6);
        button.center=point;
        //[button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        button.transform=CGAffineTransformMakeScale(0,0);
        [self addSubview:button];
        
        [self performSelector:@selector(displayPoint:) withObject:button afterDelay:delay*i];
        
        [buttons addObject:button];
        
        
    }
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{

    self.waitToUpdate=NO;
    gradient.hidden=0;

}


- (void)displayPoint:(UIButton *)button{
    
        [UIView animateWithDuration:.2 animations:^{
            button.transform=CGAffineTransformMakeScale(1, 1);
        }];
    
    
}


#pragma mark Setters

-(void)setFillColors:(NSArray *)fillColors{
    
    [gradient removeFromSuperlayer]; gradient=nil;
    
    if(fillColors.count){
        
        NSMutableArray *colors=[[NSMutableArray alloc] initWithCapacity:fillColors.count];
        
        for (UIColor* color in fillColors) {
            if ([color isKindOfClass:[UIColor class]]) {
                [colors addObject:(id)[color CGColor]];
            }else{
                [colors addObject:(id)color];
            }
        }
        _fillColors=colors;
        
        gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = _fillColors;
        [self.layer addSublayer:gradient];
        
        
    }else     _fillColors=fillColors;
    
    
    [self setNeedsDisplay];
    
}

-(void)setCurved:(BOOL)curved{
    _curved=curved;
    [self setNeedsDisplay];
}



@end
