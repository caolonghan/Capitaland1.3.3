//
//  CityViewController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "CityViewController.h"
#import "LocationUtil.h"
#import <sqlite3.h>
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

@interface CityViewController ()<UISearchBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,LocationDelegate>
@property (strong,nonatomic) UISearchBar        *cityTextF;//加载在选择地区的搜索框
@property (strong,nonatomic) UIButton            *gpsbtn;
@property (strong,nonatomic) UILabel             *gpsLable;

@property (strong,nonatomic) UIScrollView       *scrollView1;//选择地区底部视图

@property (strong,nonatomic) UITableView        *tableView_2;//点击搜索出来的视图上的tableView
@property (strong,nonatomic) NSArray            *cityAry;  //获取选择地区的数据

@property (strong,nonatomic) NSMutableArray     *sousuoCitrAry;//搜索所有城市
@property (strong,nonatomic) NSMutableArray     *sousuoIDAry;//

@end

@implementation CityViewController
{
    
    CGFloat  dView_H;
    UIView   *nvcontrView;
    UIButton *popBtn;
    NSInteger jishu;
    NSString *databasePath;
    sqlite3 *contactDB;
    NSMutableArray *cell_city_nameAry;
    NSMutableArray *cell_city_idAry;
    NSString      *gps_off;  //1为定位失败，2是定位成功，所在城市不再列表内 ，3是定位成功在列表内
    LocationUtil* loc;
    NSArray   *ciryAry111;//定位到的城市与以开放的城市比配，得出自己所在的城市，是以开放的城市，保存到这个数组中
    BOOL         root_1_2;  // yes 代表scrollView  no 代表rootView2
    BOOL isSearch;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [nvcontrView removeFromSuperview];
}


-(void) afterLoc:(NSString *)city loc:(CLLocation *)loc
{
    NSString *cityStr=[city substringToIndex:city.length-1];
    for (int i=0; i<self.sousuoCitrAry.count; i++) {
        if([self.sousuoCitrAry[i] rangeOfString:cityStr].location !=NSNotFound)//_roaldSearchText
        {
            NSString *name    = self.sousuoCitrAry[i];
            NSString *cittyid = self.sousuoIDAry[i];
            ciryAry111=[[NSArray alloc]initWithObjects:cittyid,name,nil];
        }
    }
    if ([Util isNull:ciryAry111]) {
        gps_off=@"2";
    }else {
        gps_off=@"3";
        self.gpsLable.text=ciryAry111[1];
    }
    self.gpsLable.text = [NSString stringWithFormat:@"定位城市:%@",cityStr ];
}

-(void)locError:(NSString*) msg{
    self.gpsLable.text = @"定位失败，点击重新定位";
    gps_off= @"1";
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"已开放城市";
    root_1_2=YES;
    gps_off=@"1";
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    self.cityAry=[[NSArray alloc]init];
    self.sousuoCitrAry =[[NSMutableArray alloc]init];
    self.sousuoIDAry   =[[NSMutableArray alloc]init];
    cell_city_nameAry=[[NSMutableArray alloc]init];
    cell_city_idAry  =[[NSMutableArray alloc]init];
    
    self.scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT)];
    self.scrollView1.delegate=self;
    self.scrollView1.scrollEnabled=YES;
    if (IS_IOS_7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    [self.view addSubview:self.scrollView1];
    [self NetWorkRequest];
    loc=  [[LocationUtil alloc] init];
    loc.locDelegate = self;
    [loc isLocate];
    
    self.keyboardContainer = self.tableView_2;
    
    
}

-(void)backBtnOnClicked:(id)sender{
    if(isSearch){
        [self backNormal];
    }else{
        [super backBtnOnClicked:nil];
    }
}

-(void) backNormal{
    isSearch = false;
    self.tableView_2.hidden = YES;
    [self.cityTextF resignFirstResponder];
    self.scrollView1.scrollEnabled = true;
}

#pragma mark ---请求网络---
-(void)NetWorkRequest
{
    
    self.cityAry=[[Global sharedClient].cityID copy];
    if (self.cityAry.count==0) {
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadcityregion"] parameters:nil  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray  *cityAry=dic[@"data"][@"citylist"];
                NSLog(@"%@",cityAry);
                self.cityAry=cityAry;
                for (NSDictionary *dict in self.cityAry) {
                    NSArray *array=dict[@"list"];
                    for (NSDictionary *dicti in array) {
                        NSString *cityId  =dicti[@"id"];
                        NSString *cityname=dicti[@"name"];
                        [self.sousuoIDAry   addObject:cityId];
                        [self.sousuoCitrAry addObject:cityname];
                    }
                }
                [self initHeadCity];
            });
        }failue:^(NSDictionary *dic){
            NSLog(@"%@",dic);
        }];
    }else{
        NSLog(@"%@",self.cityAry);
        for (NSDictionary *dict in self.cityAry) {
            NSArray *array=dict[@"list"];
            for (NSDictionary *dicti in array) {
                NSString *cityId  =dicti[@"id"];
                NSString *cityname=dicti[@"name"];
                [self.sousuoIDAry   addObject:cityId];
                [self.sousuoCitrAry addObject:cityname];
            }
        }
        [self initHeadCity];
    }
   
}



//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark ---创建第一个视图---
-(void)initHeadCity
{
    self.cityTextF = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(40))];
    self.cityTextF.placeholder = @"输入城市名或拼音查询";
    self.cityTextF.delegate = self;
    self.cityTextF.backgroundColor = self.view.backgroundColor;
    self.cityTextF.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.cityTextF.bounds.size];
    
    [self.scrollView1 addSubview:self.cityTextF];
    
    //定位GPS
    UIView *gpsView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cityTextF.frame), WIN_WIDTH, M_WIDTH(34))];
    gpsView.backgroundColor=[UIColor whiteColor];
    
    self.gpsLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, gpsView.frame.size.height)];
    self.gpsLable.text=@"定位中...";
    self.gpsLable.textAlignment=NSTextAlignmentLeft;
    self.gpsLable.font=DESC_FONT;
    [gpsView addSubview  :self.gpsLable];
    
    self.gpsbtn=[[UIButton alloc]initWithFrame:self.gpsLable.bounds];
    
    [self.gpsbtn addTarget:self action:@selector(gpsTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [gpsView addSubview  :self.gpsbtn];
    [self.scrollView1 addSubview:gpsView];
    
    dView_H=CGRectGetMaxY(gpsView.frame);
    //保存大区的名字
    NSMutableArray *daquAry=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in _cityAry) {
        NSString* name=[Util isNil:dic[@"name"]];
        [daquAry addObject:name];
    }
    jishu=0;
    for(NSDictionary* dic in _cityAry){
        float startX    = 15;
        float stepX     = 8;
        float endX      = 15;
        float itemY     = 30;
        float stepY     = 8;
        int   columnNum = 3;
        float width     = (SCREEN_FRAME.size.width - startX - endX - (columnNum - 1)*stepX)/3;
        
        UIView *dView=[[UIView alloc]init];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(startX, 14, 70,13)];
        titleLab.text=[Util isNil:dic[@"name"]];
        titleLab.font=COMMON_FONT;
        titleLab.textColor=COLOR_FONT_SECOND;
        [dView addSubview:titleLab];
        
        NSArray* cityArr = [dic objectForKey:@"list"] ;
        for (int j=0; j< cityArr.count; j++) {
            NSDictionary* cityDic = [cityArr objectAtIndex:j];
            float xPoint = j%3*(width + stepX) + startX;
            float yPoint = j/3*(itemY + stepY) + CGRectGetMaxY(titleLab.frame) + 10;
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(xPoint,yPoint, width, itemY)];
            NSString  *btnText=[Util isNil:cityDic[@"name"]];
            [btn setTitle:btnText forState:UIControlStateNormal];
            btn.titleLabel.font=COMMON_FONT;
            btn.layer.borderWidth=1;
            btn.layer.borderColor=(__bridge CGColorRef _Nullable)(COLOR_FONT_SECOND);
            btn.tag=jishu;
            [btn addTarget:self action:@selector(cTouch:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.backgroundColor=[UIColor whiteColor];
            [dView addSubview:btn];
            jishu++;
        }
        
        
        [self.scrollView1 addSubview:dView];
        dView.frame=CGRectMake(0, dView_H, WIN_WIDTH, ceilf(cityArr.count/3.0)*(stepY + itemY) + CGRectGetMaxY(titleLab.frame));
        dView_H=dView_H+dView.frame.size.height+10;
        
    }
    
    
    self.scrollView1.contentSize=CGSizeMake(WIN_WIDTH,dView_H);
    self.tableView_2=[[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.cityTextF.frame)+6, WIN_WIDTH, self.scrollView1.frame.size.height - CGRectGetMaxY(self.cityTextF.frame) - 6) style:UITableViewStylePlain];
    self.tableView_2.delegate=self;
    self.tableView_2.dataSource=self;
    self.tableView_2.scrollEnabled=YES;
    self.tableView_2.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.scrollView1 addSubview: self.tableView_2];
    self.tableView_2.hidden = YES;
}


#pragma mark ---创建第一个视图---


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cell_city_nameAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 40)];
        lab.tag = 100;
        lab.textColor = BLACK_COLOR;
        lab.font = COMMON_FONT;
        [cell addSubview:lab];
        
        UIView* lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(10, 39, SCREEN_FRAME.size.width - 20 , 1);
        lineView.backgroundColor = COLOR_LINE;
        [cell addSubview:lineView];
        
    }
    
    UILabel *lab =  [cell viewWithTag:100];
    lab.text=cell_city_nameAry[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString * idStr  =cell_city_nameAry[indexPath.row];
    NSString * nameStr=cell_city_idAry[indexPath.row];
    NSArray *array=[[NSArray alloc]initWithObjects:nameStr,idStr, nil];
    
    if (_citdelegate &&[_citdelegate respondsToSelector:@selector(setCity:)]) {
        [_citdelegate setCity:array];
    }
    [self.delegate.navigationController popViewControllerAnimated:YES];
}


-(void)cTouch:(UIButton *)btn
{
    NSString  *idStr   = self.sousuoIDAry[btn.tag];
    NSString  *nameStr = self.sousuoCitrAry[btn.tag];
    NSArray   *array=[[NSArray alloc]initWithObjects:idStr,nameStr,nil];

    if (_citdelegate &&[_citdelegate respondsToSelector:@selector(setCity:)]) {
        [_citdelegate setCity:array];
    }
    [self.delegate.navigationController popViewControllerAnimated:YES];
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.tableView_2.hidden = NO;
    isSearch = TRUE;
    self.scrollView1.scrollEnabled = false;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    [cell_city_nameAry removeAllObjects];
    [cell_city_idAry  removeAllObjects];
    
        NSString* text = searchBar.text;
 
        for (int i=0; i<self.sousuoCitrAry.count; i++) {
            NSString *name=self.sousuoCitrAry[i];
            NSString *cittyid=self.sousuoIDAry[i];
            if(![ChineseInclude isIncludeChineseInString:text]){
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:name];
                NSRange titleResult=[tempPinYinStr rangeOfString:text options:NSCaseInsensitiveSearch];
                if (titleResult.length > 0 && [cell_city_nameAry indexOfObject:name]== NSNotFound) {
                    [cell_city_nameAry addObject:name];
                    [cell_city_idAry   addObject:cittyid];
                    
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:name];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0 && [cell_city_nameAry indexOfObject:name]==NSNotFound) {
                    [cell_city_nameAry addObject:name];
                    [cell_city_idAry   addObject:cittyid];
                }
                [self.tableView_2 reloadData];
            }else{
                if([self.sousuoCitrAry[i] rangeOfString:text].location !=NSNotFound)//_roaldSearchText
                {
                    
                    [cell_city_nameAry addObject:name];
                    [cell_city_idAry   addObject:cittyid];
                    [self.tableView_2 reloadData];
                }
            }
            
    }
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


-(void)gpsTouch:(UIButton*)sender
{
    if ([gps_off isEqualToString:@"1"]) {
        
        [loc isLocate];
        
    }else if([gps_off isEqualToString:@"2"]){
        
        [self showMsg:@"当前城市未开放！"];
        
    }else if([gps_off isEqualToString:@"3"]){
        if (_citdelegate &&[_citdelegate respondsToSelector:@selector(setCity:)]) {
            [_citdelegate setCity:ciryAry111];
        }
        [self.delegate.navigationController popViewControllerAnimated:YES];
    }
    
    
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
