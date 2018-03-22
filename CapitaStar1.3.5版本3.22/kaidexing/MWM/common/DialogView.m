//
//  DialogView.m
//  ZhuJC
//
//  Created by Kunee Hwang on 15/7/22.
//  Copyright (c) 2015年 dwolf. All rights reserved.
//

#import "DialogView.h"
#import "Const.h"

@implementation DialogView{
}

+ (instancetype)defaultPopupView {
    DialogView* view = [[DialogView alloc]initWithFrame:CGRectMake(0, 0, 280, 130)];
    view.backgroundColor = [UIColor whiteColor];
    [view.layer setCornerRadius:4.0f];
    [view setClipsToBounds:YES];
    
    SYLabel* label = [[SYLabel alloc] initWithFrame:CGRectMake(20, 20, view.frame.size.width - 40, 25)];
    [label setTextColor:DEFAULT_MAIN_COLOR];
    [label setFont:[UIFont systemFontOfSize:15.0f]];
    [label setTag:1];
    [view addSubview:label];
    
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, view.frame.size.width, 1)];
    [lineView setBackgroundColor:DEFAULT_MAIN_COLOR];
    [view addSubview:lineView];
    
    
    UIScrollView* listView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, view.frame.size.width, 10)];
    listView.tag = 2;
    [view addSubview:listView];
    
    
    return view;
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

-(void)setList:(NSArray*) list defaultIndex:(int) defaultIndex{
    
    
    UIScrollView* scrollView = (UIScrollView*)[self viewWithTag:2];
    
    for(int i =0;i<[list count];i++){
        UIView* itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 46 * i, scrollView.frame.size.width, 46)];
        SYLabel* label = [[SYLabel alloc] initWithFrame:CGRectMake(20, 8, scrollView.frame.size.width - 60, 30)];
        [label setTextColor:BLACK_COLOR];
        [label setText:[list objectAtIndex:i]];
        [itemView addSubview:label];
        
        if(i == defaultIndex){
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 15, 15, 15)];
            [imgView setImage:[UIImage imageNamed:@"check"]];
            [imgView setTag:11];
            [itemView addSubview:imgView];
        }
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSelectedOnTap:)];
        [itemView addGestureRecognizer:gesture];
        
        [itemView setTag:i];
        [itemView setUserInteractionEnabled:YES];
        
        [scrollView addSubview:itemView];
    }
    int maxItem = [list count];
    if([list count] > 6){
        maxItem = 6;
    }
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, 46 * maxItem);
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, [list count] * 46);
    
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,scrollView.frame.origin.y + scrollView.frame.size.height);
}

-(void)itemSelectedOnTap:(UITapGestureRecognizer*) gesture{
    NSString* inxStr = [NSString stringWithFormat:@"%ld",(long)gesture.view.tag];
    if([_parentVC respondsToSelector:@selector(listItemSelected1:)]){
        [_parentVC performSelectorOnMainThread:@selector(listItemSelected1:) withObject:inxStr waitUntilDone:NO];
    }
    
    [_parentVC lew_dismissPopupViewWithanimation:[LewPopupViewAnimationDrop new]];
}


@end
