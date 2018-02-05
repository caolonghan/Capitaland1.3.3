//
//  CalendarDayCell.m
//  tttttt
//
//  Created by 张凡 on 14-8-20.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarDayCell.h"
#import "Const.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //选中时显示的图片
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float minWidht = MIN(width, height);
    imgview = [[UIImageView alloc]initWithFrame:CGRectMake((width - minWidht)/2, (height - minWidht)/2, minWidht, minWidht)];
    imgview.image = [UIImage imageNamed:@"chack.png"];
    [self addSubview:imgview];
    
    //日期
    day_lab = [[UILabel alloc]initWithFrame:CGRectMake(0, height/2 - 20, self.bounds.size.width,25)];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = FONT_19;
    [self addSubview:day_lab];

    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, height/2, self.bounds.size.width, 20)];
    day_title.textColor = [UIColor lightGrayColor];
    day_title.font = FONT_13;
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
    
    tipView = [[UIView alloc] initWithFrame:CGRectMake((width-4)/2, height - 8, 4, 4)];
    tipView.backgroundColor = DEFAULT_COLOR_666;
    tipView.layer.cornerRadius = tipView.frame.size.width/2;
    tipView.hidden = YES;
    [self addSubview:tipView];

}


- (void)setModel:(CalendarDayModel *)model
{

    tipView.hidden = YES;
    if(model.hasPlan){
        tipView.hidden = NO;
    }
    day_title.hidden = NO;
    NSLog(@"%@",model.Chinese_calendar);
NSLog(@"%d",model.style);
    day_title.textColor = [UIColor lightGrayColor];
    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            break;
            
        case CellDayTypePast://过去的日期
            [self hidden_NO];
            
            if (model.holiday && NO) {
                day_lab.text = model.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",model.day];
            }
            if ([model getWeekInt] == 1 || [model getWeekInt] == 7) {
                day_lab.textColor = DEFAULT_COLOR_999;

            }else{
                day_lab.textColor = DEFAULT_COLOR_333;

            }
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeFutur://将来的日期
            [self hidden_NO];
            
            if (model.holiday && NO) {
                day_lab.text = model.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",model.day];
            }
            if ([model getWeekInt] == 1 || [model getWeekInt] == 7) {
                day_lab.textColor = DEFAULT_COLOR_999;
                
            }else{
                day_lab.textColor = DEFAULT_COLOR_333;
                
            }
            
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            if (model.holiday && NO) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",model.day];
                day_lab.textColor = COLOR_THEME1;
            }
            if ([model getWeekInt] == 1 || [model getWeekInt] == 7) {
                day_lab.textColor = DEFAULT_COLOR_999;
                
            }else{
                day_lab.textColor = DEFAULT_COLOR_333;
                
            }
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%d",model.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.Chinese_calendar;
            day_title.textColor = [UIColor whiteColor];
            imgview.hidden = NO;
            tipView.hidden = YES;
            break;
            
        default:
            
            break;
    }


}



- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}


- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    
}


@end
