//
//  SignedController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/23.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SignedController.h"
#import "NSDate+RMCalendarLogic.h"
#define CELL_H (WIN_WIDTH-M_WIDTH(20))/7
#define IMG_H CELL_H-M_WIDTH(4)

@interface SignedController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic)UIScrollView        *scrollView1;
@property (strong,nonatomic)NSDictionary        *dataDic;
@property (strong,nonatomic)UICollectionView    *collectionView1;
@property (strong,nonatomic)UIView              *bottomView;

@end


//--------------------------签到--------------------------


@implementation SignedController{

    NSDate          *date1;
    CGFloat         view_H;
    NSUInteger      week;
    NSMutableArray  *muDate;
    UIView          *btnView;
    UIView          *hiddenView; //保存最下面的规则View
    NSMutableArray  *yiqianAry; //保存已签到的日期
    NSMutableArray  *dangyueAry;//保存所有日期 年月日
    NSMutableArray  *beijing;
    NSInteger   tianshu;
    NSMutableArray  *toDayAry;//这个月的第一天到今天的日期

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.delegate.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"membersign_pic01"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"会员签到";
    view_H=NAV_HEIGHT;
    muDate=[[NSMutableArray alloc]init];
    date1 =[[NSDate alloc]init];
    self.dataDic    =[[NSDictionary alloc]init];
    yiqianAry       =[[NSMutableArray alloc]init];
    dangyueAry      =[[NSMutableArray alloc]init];
    beijing         =[[NSMutableArray alloc]init];
    self.scrollView1=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView1.scrollEnabled=YES;
    self.scrollView1.delegate=self;
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.01);
    self.scrollView1.backgroundColor=UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.scrollView1];
    [self initHeadview];
    [self NetWorkRequest];

}
-(void)initHeadview
{
    
    CGFloat  view_laft;
    view_laft=55;
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH, 51)];
    headView.backgroundColor=[UIColor whiteColor];
    //当前年月
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月份"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];

    UILabel  *riqiLab=[[UILabel alloc]initWithFrame:CGRectMake(21, 15, 100, 21)];
    riqiLab.textAlignment=NSTextAlignmentLeft;
    riqiLab.text=dateString;
    riqiLab.font=COMMON_FONT;
    //未签到
    UILabel       *weiLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-view_laft, 18,45, 15)];
    weiLab.textAlignment=NSTextAlignmentLeft;
    weiLab.font=DESC_FONT;
    weiLab.text=@"未签到";
    view_laft=view_laft+20;
    UIImageView   *blackImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-view_laft,19, 13, 13)];
    [blackImg setImage:[UIImage imageNamed:@"membersign_icon02"]];
    view_laft=view_laft+62;
    //已签到
    UILabel       *yiLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-view_laft, 18, 45, 15)];
    yiLab.textAlignment=NSTextAlignmentRight;
    yiLab.font=DESC_FONT;
    yiLab.text=@"已签到";
    view_laft=view_laft+17;
    UIImageView   *redImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-view_laft, 19, 13, 13)];
    [redImg setImage:[UIImage imageNamed:@"membersign_icon01"]];
    
    
    [headView addSubview:riqiLab];
    [headView addSubview:redImg];
    [headView addSubview:yiLab];
    [headView addSubview:blackImg];
    [headView addSubview:weiLab];
    [self.scrollView1 addSubview:headView];
    view_H=view_H+headView.frame.size.height;
    
    NSArray  *titleAry=[[NSArray alloc]initWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    
    UIView *colorview=[[UIView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH, 30)];
    colorview.backgroundColor=UIColorFromRGB(0xf5f5f5);
    for (int i=0; i<7; i++) {
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10+i*(WIN_WIDTH-20)/7, 0, (WIN_WIDTH-20)/7, colorview.frame.size.height)];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.textColor=COLOR_FONT_SECOND;
        titleLab.font=DESC_FONT;
        titleLab.text=titleAry[i];
        [colorview addSubview:titleLab];
    }
    [self.scrollView1 addSubview:colorview];
    
    view_H=view_H+30;
    UIView *wview=[[UIView alloc]initWithFrame:CGRectMake(0, view_H, WIN_WIDTH, 10)];
    wview.backgroundColor=[UIColor whiteColor];
    [self.scrollView1 addSubview:wview];
    view_H=view_H+10;
    
    
    NSDate       *first=[date1 firstDayOfCurrentMonth];//计算这个月最开始的一天
    week=[date1 numberOfWeeksInCurrentMonth];//获取这个月有多少周
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:first];
    tianshu  = [comps weekday]-1;
    NSDate      *nextDat = [NSDate dateWithTimeInterval:-24*60*60*tianshu sinceDate:first];//后一天
    
    NSInteger   week_i=week*7;
    for (int i=0;i<week_i;i++) {
        NSDate *data=[NSDate dateWithTimeInterval:24*60*60*i sinceDate:nextDat];//
        NSString *strDate=[date1 stringFromDate_dd:data];//获取到所有的日期，只有天
        NSString *strdata_riqi=[date1 stringFromDate:data];//获取到所有的日期，年月日
        [muDate addObject:strDate];
        [dangyueAry addObject:strdata_riqi];
    }
    
    [self initCollectionView];
    [self initbtnView];

    
    
   
}


-(NSMutableArray*)str_date:(NSMutableArray*)data
{
    NSMutableArray *muAry=[data mutableCopy];
    [data removeAllObjects];
    for (int i=0; i<muAry.count; i++) {
        
    }
    return data;
}



-(void)initCollectionView
{
 

    float  collview_H=week*CELL_H +M_WIDTH(16);
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.headerReferenceSize = CGSizeMake(WIN_WIDTH,0);//头部
    self.collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0,view_H, WIN_WIDTH,collview_H) collectionViewLayout:flowLayout];
    //设置代理
    self.collectionView1.delegate = self;
    self.collectionView1.dataSource = self;
    [self.scrollView1 addSubview:self.collectionView1];
    self.collectionView1.backgroundColor = [UIColor whiteColor];
    self.collectionView1.scrollEnabled=NO;
    //注册cell和ReusableView（相当于头部）
    [self.collectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView1 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
    
    view_H=view_H+collview_H;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return week*7;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cell";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    UIView  *deleView=[cell viewWithTag:10000];
    [deleView removeFromSuperview];
    
    UIImageView     *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(2), M_WIDTH(2), IMG_H, IMG_H)];
    imgview.contentMode=UIViewContentModeScaleAspectFit;
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:cell.bounds];
    titleLab.text=muDate[indexPath.row];
    titleLab.textAlignment=NSTextAlignmentCenter;
    if (toDayAry.count==0) {
    }else {
        if ([beijing[indexPath.row]isEqualToString:@"1"]) {
            [imgview setImage:[UIImage imageNamed:@"membersign_icon02"]];
            titleLab.textColor=[UIColor whiteColor];
        }else {
            [imgview setImage:[UIImage imageNamed:@""]];
        }
    }
    if (beijing.count==0) {
    }else {
        if ([beijing[indexPath.row]isEqualToString:@"1"]) {
            [imgview setImage:[UIImage imageNamed:@"membersign_icon01"]];
            titleLab.textColor=[UIColor whiteColor];
          
        }else {
            [imgview setImage:[UIImage imageNamed:@""]];
        }
    }
    [cell addSubview:imgview];
    
    
    titleLab.tag=10000;
    
    [cell addSubview:titleLab];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}


//定义每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELL_H,CELL_H);
}
//定义每个cell的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0,M_WIDTH(8),0,M_WIDTH(8));
    
}
//定义每个cel的纵向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//定义每个cel的横向间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-----点击了第 %ld  %ld个 --------",(long)indexPath.row,(long)indexPath.section);
}


//日历下面的按钮
-(void)initbtnView
{
    btnView=[[UIView alloc]initWithFrame:CGRectMake(0,view_H, WIN_WIDTH, M_WIDTH(92))];
    btnView.backgroundColor=[UIColor whiteColor];
    
    //签到
    UIButton *qiandaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(33),M_WIDTH(10),WIN_WIDTH-M_WIDTH(66),M_WIDTH(40))];
    [qiandaoBtn setTitle:@"签到" forState:UIControlStateNormal];
    [qiandaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    qiandaoBtn.layer.masksToBounds=YES;
    qiandaoBtn.layer.cornerRadius=5;
    qiandaoBtn.backgroundColor=UIColorFromRGB(0x3ccc6f);
    [qiandaoBtn addTarget:self action:@selector(qiandaoTouch) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:qiandaoBtn];
    
    //活动规则
    
    UIButton  *guizeBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(93), CGRectGetMaxY(qiandaoBtn.frame)+M_WIDTH(7), M_WIDTH(73), 33)];
    [guizeBtn setTitle:@"活动规则 >" forState:UIControlStateNormal];
    guizeBtn.titleLabel.font=COMMON_FONT;
    
    [guizeBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [guizeBtn addTarget:self action:@selector(guizeTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:guizeBtn];
    [self.scrollView1 addSubview:btnView];
//    [self inithiddenView];
}

//规则详情
-(void)inithiddenView
{
    float  hidden_H;
    hidden_H=M_WIDTH(8);
    hiddenView=[[UIView alloc]init];
    hiddenView.backgroundColor=UIColorFromRGB(0xf5f5f5);
    
    NSArray *array=[[NSArray alloc]initWithObjects:@"asdlasdjlkasjdkasjdlasjdlajdlaksjdlasjdlasdjlasdjalkdjsasldjalksjdalsdjalsdjalsdjalsdjalsdjalsjdlasdjalksjdlasjdalksdjalksdjaldjkal",@"asdjalsdjalskdjlasjdlkajdlajsldjalsdjlajsdkajljsdlkajdlkajds",@"aasdasdasdasdasda",@"asdasd",nil];
    float  lab_H=11;
    for (int i=0; i<array.count; i++) {
        UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(23,lab_H , WIN_WIDTH-80, 12)];
        titlelab.numberOfLines=0;
        titlelab.font=DESC_FONT;
        titlelab.text=array[i];
        lab_H =[self initLab:titlelab]+lab_H+5;
        [hiddenView addSubview:titlelab];
    }
    hiddenView.frame=CGRectMake(0,CGRectGetMaxY(btnView.frame), WIN_WIDTH, lab_H);
    [self.scrollView1 addSubview:hiddenView];
}

//点击规则
-(void)guizeTouch:(UIButton*)sender
{
    
    
    
}
//会员每日签到按钮
-(void)qiandaoTouch
{

    int  shopID=[[Global sharedClient].markID intValue];
    
    NSString        *path=[Util makeRequestUrl:@"sign" tp:@"conventionalsign"];
    NSDictionary    *diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@(shopID),@"mall_id",nil];
    
    [HttpClient requestWithMethod:@"POST" path:path parameters:diction  target:self success:^(NSDictionary *dic){
         dispatch_async(dispatch_get_main_queue(), ^{
            
             [SVProgressHUD showSuccessWithStatus:@"签到成功"];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"asdasdada");
    }];

}

//获取签到记录
-(void)NetWorkRequest
{
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    NSString  *uesrID=[Global sharedClient].member_id;
    int        shopID=[[Global sharedClient].markID intValue];

    NSString        *path;
    NSDictionary    *diction;

    //商场签到记录
    path=[Util makeRequestUrl:@"sign" tp:@"conventionalsigndata"];
    diction=[[NSDictionary alloc]initWithObjectsAndKeys:uesrID,@"member_id",@(shopID),@"mall_id",nil ];
    
    [HttpClient requestWithMethod:@"POST" path:path parameters:diction target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
           self.dataDic=dic;
           NSLog(@"%@",dic);

           NSArray *array=dic[@"data"][@"recordlist"];
            for (NSDictionary *dict in array) {
                NSString  *add_time = dict[@"add_time"];
                NSString  *riqi     = [add_time substringToIndex:10];
                [yiqianAry addObject:riqi];
            }
          

            for (int j=0; j<dangyueAry.count; j++) {
                if ([yiqianAry containsObject:dangyueAry[j]]) {
                    NSString *z=@"1";
                    [beijing addObject:z];
                }else {
                    NSString *z=@"0";
                    [beijing addObject:z];
            
                }
            }
            
            [self inittouday];
            
            [self.collectionView1 reloadData];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
       
    }];
    
}
-(void)inittouday
{
    NSDate       *first=[date1 firstDayOfCurrentMonth];//计算这个月最开始的一天
    NSString     *firstDay=[date1 stringFromDate:first];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:firstDay]];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    NSMutableArray *dayAry=[[NSMutableArray alloc]init];
    
    for (int i=0;i<(dayComponents.day+1);i++) {
        NSDate *data=[NSDate dateWithTimeInterval:24*60*60*i sinceDate:first];//
        NSString *strdata_riqi=[date1 stringFromDate:data];//获取到所有的日期，年月日
        [dayAry addObject:strdata_riqi];
    }
    NSLog(@"%@",dayAry);
    for (int j=0; j<dangyueAry.count; j++) {
        if ([dayAry containsObject:dangyueAry[j]]) {
            NSString *z=@"1";
            [toDayAry addObject:z];
        }else {
            NSString *z=@"0";
            [toDayAry addObject:z];
        }
    }
}


-(float)initLab:(UILabel*)lab
{
    float lab_H;
    lab.textAlignment=NSTextAlignmentLeft;
    CGRect rect1=[lab.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-80,200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lab.font} context:nil];
    lab.frame=CGRectMake(lab.frame.origin.x,lab.frame.origin.y, rect1.size.width, rect1.size.height);
    lab_H=rect1.size.height;
    return lab_H;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
