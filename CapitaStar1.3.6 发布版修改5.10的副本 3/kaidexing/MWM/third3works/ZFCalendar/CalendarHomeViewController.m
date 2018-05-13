//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarHomeViewController.h"
#import "Color.h"

@interface CalendarHomeViewController ()
{
    
    
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
    BOOL firstTimeShow;
    //    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}

@end

@implementation CalendarHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)loadData{
    
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@""];
    [HttpClient requestWithMethod:@"POST" path:@"findRunningDayListByUid" parameters:@{@"uid":self.uid} target:self success:^(NSDictionary* dic){
        
        [self setAirPlaneToDay:90 afterDay:90 ToDateforString:nil hasPlanDatas:[dic objectForKey:@"data"]]; //日历初始化方法
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [super.collectionView reloadData];//刷新
            
            if(_flag){
                self.collectionView.hidden  = YES;
                int row = [self.collectionView numberOfItemsInSection:0] + [self.collectionView numberOfItemsInSection:1] + [self.collectionView numberOfItemsInSection:2];
                row = row/7;
                
                [self.collectionView setContentOffset:CGPointMake(0, row*70+3*65)];
                _flag = false;
                self.collectionView.hidden  = false;
            }
        });
        
        
        [SVProgressHUD dismiss];
    } failue:^(NSDictionary* dic){
        [SVProgressHUD dismiss];
        [self removeLoading];
    }];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!firstTimeShow){
        [self loadData];
    }
    firstTimeShow = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}

//初始化方法
- (void)setAirPlaneToDay:(int)beforeDay afterDay:(int)afterDay ToDateforString:(NSString *)todate hasPlanDatas:(NSArray*) hasPlanDatas
{
    
    NSDateFormatter* dataFormater = [[NSDateFormatter alloc] init];
    [dataFormater setDateFormat:@"yyyy-MM-dd"];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    optiondaynumber = 1;//选择一个后返回数据对象
    NSMutableArray* months = [self getMonthArrayOfDayNumber:beforeDay afterDay:afterDay ToDateforString:todate];
    for(NSString* dataStr in hasPlanDatas){
        for(NSMutableArray* items in months){
            for(CalendarDayModel* day in items){
                NSDate* planData = [dataFormater dateFromString:dataStr];
                NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:planData]; // Get necessary date
                if(day.year == [components year] &&  [components day] == day.day && [components month] == day.month){
                    day.hasPlan = true;
                }
            }
        }
    }
    super.calendarMonth = months;
}

//酒店初始化方法
- (void)setHotelToDay:(int)day ToDateforString:(NSString *)todate
{
    
    daynumber = day;
    optiondaynumber = 2;//选择两个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
}


//火车初始化方法
- (void)setTrainToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
    
}



#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}


//获取时间段内的天数数组，
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)beforeDay afterDay:(int)afterDay ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:selectdate beforeDays:beforeDay afterDays:afterDay];
}


#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{
    
    [self.navigationItem setTitle:calendartitle];
    
}


@end
