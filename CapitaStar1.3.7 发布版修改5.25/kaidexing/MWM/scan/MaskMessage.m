//
//  DialogView.m
//  ZhuJC
//
//  Created by Kunee Hwang on 15/7/22.
//  Copyright (c) 2015年 dwolf. All rights reserved.
//

#import "MaskMessage.h"
#import "Const.h"

@implementation MaskMessage{
}

+ (instancetype)defaultPopupView {
    MaskMessage* view = [[MaskMessage alloc]initWithFrame:CGRectMake(0, 0, 280, 500)];
    view.backgroundColor = [UIColor whiteColor];
    [view.layer setCornerRadius:4.0f];
    [view setClipsToBounds:YES];
    
    SYLabel* label = [[SYLabel alloc] initWithFrame:CGRectMake(20, 0, view.frame.size.width - 40, 40)];
    [label setTextColor:COLOR_FONT_BLACK];
    [label setFont:COMMON_FONT];
    [label setTag:1];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, view.frame.size.width, 1)];
    [lineView setBackgroundColor:COLOR_LINE];
    [view addSubview:lineView];
    
    
    UIScrollView* listView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 42, view.frame.size.width, 10)];
    listView.tag = 2;
    [view addSubview:listView];
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, listView.frame.size.height + listView.frame.origin.y, view.frame.size.width, 40)];
    bottomView.tag = 3;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 1)];
    [lineView setBackgroundColor:COLOR_LINE];
    [bottomView addSubview:lineView];
    [view addSubview:bottomView];
    return view;
}

-(void) setBtns:(NSArray*) names{
    float yPoint = 0;
    UIView* bottomView = (UIView*)[self viewWithTag:3];
    float width = (bottomView.frame.size.width  - names.count +1)/names.count;
    for(int i = 0; i < names.count ;  i++){
        NSString* name = names[i];
        UIButton* bt1 = [[UIButton alloc] init];
        
        
        bt1 = [[UIButton alloc] init];
        bt1.frame = CGRectMake((width*i + i) , 0, width, 40);
        [bt1 setTitle:name forState:UIControlStateNormal];
        if(i != names.count - 1){
            [bt1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            bt1.backgroundColor = [UIColor clearColor];
        }else{
            bt1.backgroundColor = [UIColor clearColor];
            [bt1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
        
        [bt1 titleLabel].font = COMMON_FONT;
        [bottomView addSubview:bt1];
        
        [bt1 addTarget:self action:@selector(onBtnItemTap:) forControlEvents:UIControlEventTouchUpInside];
        bt1.tag = 90 + i;
        if(i != 0){
            UIView* vLineView = [[UIView alloc] initWithFrame:CGRectMake((width*i+ i-1), yPoint, 1, 40)];
            vLineView.backgroundColor = COLOR_LINE;
            [bottomView addSubview:vLineView];
        }
        
    }
    yPoint = yPoint +40;
    CGRect frame = bottomView.frame;
    frame.size.height = yPoint;
    bottomView.frame = frame;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setTitle:(NSString*) title{
    [((UILabel*)[self viewWithTag:1]) setText:title];
}


-(void)setView:(UIView*) view height:(float) height{

    UIScrollView* scrollView = (UIScrollView*)[self viewWithTag:2];
    
    [scrollView addSubview:view];
    
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, height);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, view.frame.size.height);
    UIView* bottomView = (UIView*)[self viewWithTag:3];
    bottomView.frame = CGRectMake(0, scrollView.frame.size.height + scrollView.frame.origin.y, scrollView.frame.size.width, bottomView.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,bottomView.frame.origin.y + bottomView.frame.size.height);
}

-(void) setMsgColor:(UIColor*) color{
    UILabel* label = [self viewWithTag:978];
    [label setTextColor:color];
}
-(void)onBtnItemTap:(id) sender{
    int tag = ((UIView*)sender).tag - 90;
    if ([_parentVC respondsToSelector:@selector(btnSelected:)]) {
            [_parentVC performSelectorOnMainThread:@selector(btnSelected:) withObject:[NSString stringWithFormat:@"%d", tag] waitUntilDone:NO];
        
    }
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
}


@end
