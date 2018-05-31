//
//  DailyCalendarView.m
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li
//
#import "DailyCalendarView.h"
#import "NSDate+CL.h"
#import "UIColor+CL.h"
#import "Const.h"
#import "Util.h"

@interface DailyCalendarView()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *chinaDateLabel;
@property (nonatomic, strong) UIView *dateLabelContainer;
@end


#define DATE_LABEL_SIZE   45
#define DATE_LABEL_FONT_SIZE 20

@implementation DailyCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.dateLabelContainer];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyViewDidClick:)];
        [self addGestureRecognizer:singleFingerTap];
        
    }
    return self;
}
-(UIView *)dateLabelContainer
{
    if(!_dateLabelContainer){
        float x = (self.bounds.size.width - DATE_LABEL_SIZE)/2;
        _dateLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(x, 10, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _dateLabelContainer.backgroundColor = [UIColor clearColor];
        _dateLabelContainer.layer.cornerRadius = DATE_LABEL_SIZE/2;
        _dateLabelContainer.clipsToBounds = YES;
        [_dateLabelContainer addSubview:self.dateLabel];
        [_dateLabelContainer addSubview:self.chinaDateLabel];
    }
    return _dateLabelContainer;
}
-(UILabel *)dateLabel
{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, DATE_LABEL_SIZE, DATE_LABEL_SIZE/2)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = FONT_20;
    }
    
    return _dateLabel;
}

-(UILabel *)chinaDateLabel
{
    if(!_chinaDateLabel){
        _chinaDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, DATE_LABEL_SIZE/2 - 2, DATE_LABEL_SIZE, DATE_LABEL_SIZE/2)];
        _chinaDateLabel.backgroundColor = [UIColor clearColor];
        _chinaDateLabel.textColor = [UIColor whiteColor];
        _chinaDateLabel.textAlignment = NSTextAlignmentCenter;
        _chinaDateLabel.font = FONT_14;
    }
    
    return _chinaDateLabel;
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    [self setNeedsDisplay];
}
-(void)setBlnSelected: (BOOL)blnSelected
{
    _blnSelected = blnSelected;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.dateLabel.text = [self.date getDateOfMonth];
    self.chinaDateLabel.text =  [Util getChineseCalendarWithDate:self.date];
    
}

-(void)markSelected:(BOOL)blnSelected
{
    //    DLog(@"mark date selected %@ -- %d",self.date, blnSelected);
    if([self.date isDateToday]){
        self.dateLabelContainer.backgroundColor =  DEFAULT_GREEN_COLOR;
        
        self.dateLabel.textColor = [UIColor whiteColor];
        self.chinaDateLabel.textColor = [UIColor whiteColor];
    }else{
        self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor whiteColor]: [UIColor clearColor];
        NSString* weekStr = [[self.date getDayOfWeekShortString] substringFromIndex:1];
        if([weekStr isEqualToString:@"日"] || [weekStr isEqualToString:@"六"]){
            self.dateLabel.textColor = DEFAULT_COLOR_999;
        }else{
            self.dateLabel.textColor = DEFAULT_COLOR_333;
        }
        self.chinaDateLabel.textColor = DEFAULT_COLOR_999;
    }
    if(blnSelected && ![self.date isDateToday]){
        self.dateLabelContainer.backgroundColor =  DEFAULT_TABLE_HEAD_COLOR;
        
        self.dateLabel.textColor = [UIColor whiteColor];
        self.chinaDateLabel.textColor = [UIColor whiteColor];
    }
    
    
    
    
}
-(UIColor *)colorByDate
{
    return [self.date isPastDate]?[UIColor colorWithHex:0x7BD1FF]:[UIColor whiteColor];
}

-(void)dailyViewDidClick: (UIGestureRecognizer *)tap
{
    [self.delegate dailyCalendarViewDidSelect: self.date];
}
@end


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
