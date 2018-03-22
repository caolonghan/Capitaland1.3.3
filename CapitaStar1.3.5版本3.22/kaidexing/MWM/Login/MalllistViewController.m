//
//  MalllistViewController.m
//  kaidexing
//
//  Created by company on 2017/8/30.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MalllistViewController.h"
#import "LocationUtil.h"
#import "LocationModel.h"
#import "MallInfoModel.h"

@interface MalllistViewController ()<LocationDelegate,UITableViewDelegate,UITableViewDataSource>
{
    LocationUtil *loc;
    NSArray *cellAry;
    UITableView *tab;
    
    UIImageView *bgView;
    UILabel *tittleLab;
    
    BOOL isautoLoc;
}
@end

@implementation MalllistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loc=  [[LocationUtil alloc] init];
    loc.locDelegate = self;
    [loc isLocate];
    isautoLoc = NO;
    
    cellAry = [NSArray array];
    
    [self setNavigationBarcolor:[UIColor clearColor]];
    self.navigationBarLine.hidden = YES;
    [self redefineBackBtn:[UIImage imageNamed:@"iconBack"] :CGRectMake(10, 10, 24, 24)];
    
    bgView = [[UIImageView alloc]initWithFrame:SCREEN_FRAME];
    bgView.image = [UIImage imageNamed:@"bg"];
    bgView.userInteractionEnabled=YES;
    [self.view addSubview: bgView];
    
    tittleLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(17), 80, WIN_WIDTH-M_WIDTH(17), 40)];
    tittleLab.font = [UIFont systemFontOfSize:20];
    tittleLab.textColor = [UIColor whiteColor];
    tittleLab.text = @"请选择您最爱去的商场";
    [bgView addSubview:tittleLab];
    
    /*UIButton* next = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(17)-40, WIN_HEIGHT-M_WIDTH(17)-40, 40, 40)];
    [next setImage:[UIImage imageNamed:@"iconArrowLeftCircle"] forState:UIControlStateNormal];
    [bgView addSubview:next];
    [next addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    */
    UIButton* skip = [[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(17), WIN_HEIGHT-M_WIDTH(17)-40+5, WIN_WIDTH-M_WIDTH(17)*2-40-20, 30)];
    [bgView addSubview:skip];
    skip.titleLabel.font =[UIFont systemFontOfSize:14];
    [skip setTitle:@"打开定位，自动选择距离您最近的商场" forState:UIControlStateNormal];
    [skip setTintColor:[UIColor whiteColor]];
    [skip setBackgroundColor:[UIColor clearColor]];
    skip.layer.cornerRadius = 15;
    skip.layer.borderColor =[UIColor whiteColor].CGColor;
    skip.layer.borderWidth = 1;
    [skip addTarget:self action:@selector(skipclick) forControlEvents:UIControlEventTouchUpInside];
    
    //CGRect rec = CGRectMake(M_WIDTH(17), +20, WIN_WIDTH-M_WIDTH(17)*2, WIN_HEIGHT-CGRectGetMaxY(tittleLab.frame)-20-CGRectGetMinY(next.frame)-20);
    
    tab = [[UITableView alloc]initWithFrame:CGRectMake(M_WIDTH(17), 140, WIN_WIDTH-M_WIDTH(17)*2, WIN_HEIGHT-M_WIDTH(17)-40-20-140) style:UITableViewStyleGrouped];
    tab.delegate = self;
    tab.dataSource= self;
    tab.backgroundColor = [UIColor clearColor];
    tab.separatorStyle=UITableViewCellSeparatorStyleNone;
    [bgView addSubview:tab];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(location)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)next
{

}

- (void)skipclick
{

    isautoLoc = YES;
    if ([CLLocationManager locationServicesEnabled] &&([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedAlways|| [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        
        
        
        [Global sharedClient].pushLoadData = @"1";
        [self.delegate.navigationController popToRootViewControllerAnimated:YES];
        if (self.autoLoc) {
            self.autoLoc();
        }
        
    }else{
//        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
//        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
-(void) afterLoc:(NSString *)city loc:(CLLocation *)loca{
    if(loca.coordinate.latitude == 0 && loca.coordinate.longitude == 0){
        return;
    }
    //    if(_cllocation2 != nil){
    //        return;
    //    }
    //    _cllocation2=loc;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* lng = [NSString stringWithFormat:@"%f",loca.coordinate.longitude];
    NSString* lat = [NSString stringWithFormat:@"%f",loca.coordinate.latitude];
    [userDefaults setValue:lng forKey:@"cllocation_lng"];
    [userDefaults setValue:lat forKey:@"cllocation_lat"];
    
    [self netWorkRequest:lng :lat];
    
}
-(void) location{
    if ([CLLocationManager locationServicesEnabled] &&([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedAlways|| [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [loc isLocate];
    }
    
}
-(void)userLocChoice:(int)type{
    
        if (type == 5 || type == 6) {
            
        }else{
            if (type == 1 ) {
                
                    [loc isLocate];
                
            }else{
                [self netWorkRequest:@"":@""];
            }
        }
}
-(void)netWorkRequest:(NSString*)lng :(NSString*)lat{
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([Util isNull:lng]) {
        lng = [userDefaults valueForKey:@"cllocation_lng"];
        lat = [userDefaults valueForKey:@"cllocation_lat"];
    }
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmalllist"] parameters:[[NSDictionary alloc] initWithObjectsAndKeys:lng,@"lng",lat,@"lat", nil]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (isautoLoc) {
                if ([Util isNull:dic[@"data"][@"near_mall"]]) {
                    [SVProgressHUD showErrorWithStatus:@"抱歉，您周围没有商场！"];
                }else{
                    [SVProgressHUD dismiss];
                    [self popData:dic[@"data"][@"near_mall"]];
                    
                    return ;
                }
            }else{
                
                cellAry = dic[@"data"][@"city_malllist"];
                
                [tab reloadData];
                [SVProgressHUD dismiss];
            }
            

        });
    }failue:^(NSDictionary *dic){
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return cellAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"cellid";
    UITableViewCell *cell = [tab dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    [UIUtil removeSubView:cell];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic =cellAry[indexPath.section][@"mall_list"][indexPath.row];
    UILabel *la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [cell addSubview:la];
    la.text =dic[@"mall_name"];
    la.textColor = [UIColor whiteColor];
    la.font = DESC_FONT;
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr =cellAry[section][@"mall_list"];
    return arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return cellAry[section][@"city_name"];
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *vi = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 40)];
    vi.text =cellAry[section][@"city_name"];
    vi.font = DESC_FONT;
    vi.textColor = [UIColor whiteColor];
    vi.backgroundColor = [UIColor clearColor];
    return vi;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:cellAry[indexPath.section][@"mall_list"][indexPath.row]];
//    NSLog(@"%@的 %@商场",cellAry[section][@"city_name"],cellAry[section][@"mall_list"][rowIndex][@"mall_name"]);
//    NSLog(@" %@",dic);
    [self popData:dic];
}
-(void)popData:(NSDictionary*)dic{
      NSArray *idArray = [NSArray arrayWithObjects:@"61",@"60",@"59",@"58",@"55",@"54",@"52",@"51",@"49",@"46",@"45",@"44",@"43",@"42",@"27",@"26",@"22",@"21",@"20",@"41",@"76",@"75",@"74",@"72",@"71",@"70",@"57",@"79",@"77",@"73",@"68",@"66",@"65",@"62",@"47",@"38",@"29",@"12",@"10", nil];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (_type !=1) {
        NSString *mall_id=[dic valueForKey:@"mall_id"];
        [Global sharedClient].markID        = mall_id;
        [Global sharedClient].markCookies   = dic[@"mall_id_des"];
        [Global sharedClient].markPrefix    = dic[@"mall_url_prefix"];
        [Global sharedClient].shopName      = dic[@"mall_name"];
        [userDefaults setObject:mall_id                 forKey:@"mall_id"];
        [userDefaults setObject:dic[@"mall_name"]       forKey:@"mall_name"];
        [userDefaults setObject:dic[@"mall_url_prefix"] forKey:@"mall_url_prefix"];
        [userDefaults setObject:dic[@"mall_id_des"]     forKey:@"mall_id_des"];
        
        if (self.shouldPost) {
            [self registmall:mall_id];
        }
        
        [Global sharedClient].pushLoadData = @"1";
        [Global sharedClient].isLoginPush = @"0";
        
        [self.delegate.navigationController popToRootViewControllerAnimated:YES];
        loc = nil;
    }
    if (self.getInAR) {
        for (int i=0; i<idArray.count; i++) {
            
            if ([dic[@"mall_id"] integerValue] ==[idArray[i] intValue]  ) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此商场不参与AR互动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            
        }
        NSString *mall_id=[dic valueForKey:@"mall_id"];
        [Global sharedClient].markID        = mall_id;
        [Global sharedClient].markCookies   = dic[@"mall_id_des"];
        [Global sharedClient].markPrefix    = dic[@"mall_url_prefix"];
        [Global sharedClient].shopName      = dic[@"mall_name"];
        [userDefaults setObject:mall_id                 forKey:@"mall_id"];
        [userDefaults setObject:dic[@"mall_name"]       forKey:@"mall_name"];
        [userDefaults setObject:dic[@"mall_url_prefix"] forKey:@"mall_url_prefix"];
        [userDefaults setObject:dic[@"mall_id_des"]     forKey:@"mall_id_des"];
        
        self.getInAR();
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)registmall:(NSString*)mallid
{
    static NSInteger i = 0;
    if (i!=0) {
        return;
    }
    i=1;
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",mallid,@"mall_id", nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"memberregistmall"] parameters:para target:self success:^(NSDictionary *dic) {
        
    } failue:^(NSDictionary *dic) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
