//
//  SelectionBoxView.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SelectionBoxView.h"
#import "Const.h"

@interface SelectionBoxView()<UIScrollViewDelegate>

@end

@implementation SelectionBoxView


- (void)drawRect:(CGRect)rect{
   
    self.backgroundColor=[UIColor clearColor];
    
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(0, _xPoint,WIN_WIDTH , self.frame.size.height-_xPoint)];
    colorView.backgroundColor=[UIColor blackColor];
    colorView.alpha=0.4;
    [self addSubview:colorView];
    
    UIScrollView *rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_xPoint,WIN_WIDTH,colorView.frame.size.height)];
    rootScrollView.delegate=self;
    rootScrollView.scrollEnabled=YES;
    
    NSInteger count=self.dataArray.count;
    count = ceil(count/2.0);
    float itemHeight = 40;
    CGFloat view_H=itemHeight*count + count/2.0;
    
    rootScrollView.contentSize=CGSizeMake(WIN_WIDTH,view_H);

    UIView *xuanzeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, view_H)];
    xuanzeView.backgroundColor=[UIColor whiteColor];

    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.5)];
    lineView.backgroundColor=COLOR_LINE;
    [xuanzeView addSubview:lineView];
    
    float leftPadding = 15;
    float rightPadding = 10;

    NSInteger z=self.dataArray.count;
    for (int j=0; j<count; j++) {
        
        lineView=[[UIView alloc]initWithFrame:CGRectMake(0, itemHeight*(j+1)+j*0.5, WIN_WIDTH, 0.5)];
        lineView.backgroundColor=COLOR_LINE;
        [xuanzeView addSubview:lineView];
        
        for (int i=0; i<2; i++,z--) {
            if (z==0) {
                break;
            }else{
                
                UILabel *dataLab=[[UILabel alloc]initWithFrame:CGRectMake(leftPadding+(WIN_WIDTH/2)*i,j*(itemHeight+0.5), (WIN_WIDTH - leftPadding*2 - rightPadding*2)/2, itemHeight)];
                dataLab.text=self.dataArray[j*2+i];
                dataLab.font=COMMON_FONT;
                if([_curSelectId isEqualToString:self.idArray[j*2+i]]){
                    dataLab.textColor = APP_BTN_COLOR;
                }else{
                    dataLab.textColor = COLOR_FONT_BLACK;
                }
                [xuanzeView addSubview:dataLab];
                
                UIButton *dataBtn=[[UIButton alloc]initWithFrame:dataLab.frame];
                dataBtn.tag=j*2+i+10000;
                [dataBtn addTarget:self action:@selector(btn_Touch:) forControlEvents:UIControlEventTouchUpInside];
                [xuanzeView addSubview:dataBtn];
            }
        }
    }
    [rootScrollView addSubview:xuanzeView];
    [self addSubview:rootScrollView];
}

-(void)initview{
}

-(void)btn_Touch:(UIButton*)sender
{
    NSInteger  cout=sender.tag-10000;
    NSString *idStr=self.idArray[cout];
    NSString *nameStr=self.dataArray[cout];
    NSArray  *array=[[NSArray alloc]initWithObjects:self.type,idStr, nameStr,nil];

    
    if (_selectioDelegate &&[_selectioDelegate respondsToSelector:@selector(setdelegate:)]) {
        [_selectioDelegate setdelegate:array];
    }
    
    self.hidden=YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.hidden=YES;
    if (_selectioDelegate &&[_selectioDelegate respondsToSelector:@selector(cancelSelect)]) {
        [_selectioDelegate cancelSelect];
    }
}



@end
