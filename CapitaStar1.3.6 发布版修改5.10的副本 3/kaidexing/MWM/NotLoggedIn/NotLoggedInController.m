//
//  NotLoggedInController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/11/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "NotLoggedInController.h"
#import "KDSearchBar.h"
#import "MarketRootController.h"
#import "LocationUtil.h"

@interface NotLoggedInController ()<UIScrollViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,LocationDelegate>
@property (strong,nonatomic)NSDictionary *dataDic;
@property (strong,nonatomic)UIScrollView *scrollView1;

@end

@implementation NotLoggedInController{
    UIView   *nilView1;
    NSArray  *headAry;
    NSArray  *cellAry;
    KDSearchBar  *homeTextF;
    LocationUtil* loc;
    BOOL      isLocation;//返回时候开启定位
    BOOL      isFirst;//防止重复加载数据
    bool      isLocDelegate;//定位返回代理，防止重复返回代理
    //
    int           twoTime;
    NSTimer      *relodeTime;
    NSString     *searchStr;
    UITableView  *tableView1;
    NSMutableArray  *sousuoDataAry;
    NSMutableArray  *sousuoStrAry;
    NSMutableArray  *exhibitionDataAry;//搜索展示的对应数据
    BOOL             isHidden;//判断搜索出来的table是否隐藏界面
    //
}

-(void) afterLoc:(NSString *)city loc:(CLLocation *)loc{
    if(loc.coordinate.latitude == 0 && loc.coordinate.longitude == 0){
        return;
    }
//    if(_cllocation2 != nil){
//        return;
//    }
//    _cllocation2=loc;
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* lng = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    NSString* lat = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    [userDefaults setValue:lng forKey:@"cllocation_lng"];
    [userDefaults setValue:lat forKey:@"cllocation_lat"];
    if (isFirst == NO) {
        [self netWorkRequest:lng :lat];
    }
}

-(void)userLocChoice:(int)type{
    if (isFirst == NO) {
        if (type == 5 || type == 6) {
            isLocDelegate=YES;
        }else{
            if (type == 1 || type==nil) {
                if (isLocDelegate==NO) {
                    isLocation = [loc isLocate];
                }
            }else{
                [self netWorkRequest:@"":@""];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = NO;
    self.leftBarItemView.hidden=YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    relodeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    isHidden=YES;
    loc=  [[LocationUtil alloc] init];
    loc.locDelegate = self;
    isLocation = [loc isLocate];
    [self createNavView];
}

-(void)crateScrollView{
    self.scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    self.scrollView1.backgroundColor=UIColorFromRGB(0xf2f2f2);
    self.scrollView1.contentSize = CGSizeMake(WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT);
    self.scrollView1.delegate=self;
    [self.view addSubview:self.scrollView1];
}

-(void)netWorkRequest:(NSString*)lng :(NSString*)lat{
    [SVProgressHUD dismiss];
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    isFirst = YES;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

    if ([Util isNull:lng]) {
        lng = [userDefaults valueForKey:@"cllocation_lng"];
        lat = [userDefaults valueForKey:@"cllocation_lat"];
    }
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"getmalllist"] parameters:[[NSDictionary alloc] initWithObjectsAndKeys:lng,@"lng",lat,@"lat", nil]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            /*if ([Util isNull:[userDefaults valueForKey:@"firstSetIn"]]) {
                [userDefaults setObject:@"two" forKey:@"firstSetIn"];
                if ([Util isNull:dic[@"data"][@"near_mall"]]) {
                    [SVProgressHUD showErrorWithStatus:@"抱歉，您周围没有商场！"];
                }else{
                    [SVProgressHUD dismiss];
                    [self popData:dic[@"data"][@"near_mall"]];
                    
                    return ;
                }
            }*/
                        
            self.dataDic = dic[@"data"];
            headAry = dic[@"data"][@"rec_malllist"];
            cellAry = dic[@"data"][@"city_malllist"];
            [self crateScrollView];
            [self crateHeadView];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
    }];
}
-(void)createNavView{
    UIView *headRootView = [[UIView alloc]initWithFrame:CGRectMake(0,20, WIN_WIDTH,44)];
    headRootView.backgroundColor=[UIColor whiteColor];
    
    CGFloat  view_Laft=M_WIDTH(11);
    
    if(![Util isNull:_setInType] && [_setInType isEqualToString:@"1"]){
        
        view_Laft=view_Laft+44;
        UIButton* backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44,44)];
        [backButton setImage:[UIImage imageNamed:@"heiblack36"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popTouch:) forControlEvents:UIControlEventTouchUpInside];
        [headRootView addSubview:backButton];
    }
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(view_Laft,7,WIN_WIDTH-M_WIDTH(19)-view_Laft,28)];
    homeTextF=[[KDSearchBar alloc]initWithFrame:headView.bounds];
    homeTextF.newFrame = homeTextF.frame;
    homeTextF.placeholder=@"请输入商场名";
    homeTextF.delegate=self;
    homeTextF.searchBarStyle=UISearchBarStyleMinimal;
    homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    homeTextF.returnKeyType=UIReturnKeySearch;
    homeTextF.tintColor = [UIColor whiteColor];
    [headView addSubview:homeTextF];
    [headRootView addSubview:headView];
    
    UIView *topLineView =[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(43)-1,WIN_WIDTH,1)];
    topLineView.backgroundColor = COLOR_LINE;
    [headRootView addSubview:topLineView];
    
    [self.navigationBar addSubview:headRootView];
}

-(void)popTouch:(UIButton*)sender{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

-(void)crateHeadView{

    CGFloat view_H=0;
    if (![Util isNull:_dataDic[@"near_mall"]]) {
        UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0,view_H,WIN_WIDTH,M_WIDTH(36))];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel *dingweilab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),(M_WIDTH(36)-14)/2,10, 14)];
        dingweilab.text=@"当前定位到最近的商场：";
        dingweilab.font=DESC_FONT;
        [dingweilab sizeToFit];
        [headView addSubview:dingweilab];
        
        UIButton * dingweiBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dingweilab.frame),0,WIN_WIDTH-M_WIDTH(20)-dingweilab.frame.size.width,M_WIDTH(36))];
        [dingweiBtn setTitle:_dataDic[@"near_mall"][@"mall_name"] forState:UIControlStateNormal];
        [dingweiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dingweiBtn.titleLabel.font=DESC_FONT;
        dingweiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [dingweiBtn addTarget:self action:@selector(dingweiMarketTouch:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:dingweiBtn];
        
        [self.scrollView1 addSubview:headView];
        view_H =M_WIDTH(36);
    }
    
    UIView *reMenView = [[UIView alloc]initWithFrame:CGRectMake(0,view_H,WIN_WIDTH,M_WIDTH(148))];
    reMenView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    
    UILabel  *remenLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),M_WIDTH(3),M_WIDTH(100),M_WIDTH(36))];
    remenLab.text=@"热门商场";
    remenLab.font=DESC_FONT;
    remenLab.textColor = APP_BTN_COLOR;
    [reMenView addSubview:remenLab];
    
    UIButton *topBtn;
    CGFloat cellBtnW = (WIN_WIDTH-M_WIDTH(42))/3;
    CGFloat cellBtnH = M_WIDTH(38);
    for (int i=0; i<6 && i<headAry.count; i++) {
        int  y = i/3;
        int  x = i%3;
        topBtn = [[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(11)+x*(cellBtnW+M_WIDTH(10)),CGRectGetMaxY(remenLab.frame)+y*cellBtnH,cellBtnW,cellBtnH-M_WIDTH(9))];
        topBtn.tag=i;
        topBtn.layer.masksToBounds=YES;
        topBtn.layer.cornerRadius=3;
        topBtn.layer.borderColor=APP_BTN_COLOR.CGColor;
        topBtn.layer.borderWidth=1;
        topBtn.backgroundColor = [UIColor whiteColor];
        topBtn.titleLabel.font=INFO_FONT;
        [topBtn setTitle:headAry[i][@"mall_name"] forState:UIControlStateNormal];
        [topBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
        [topBtn addTarget:self action:@selector(headBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [reMenView addSubview:topBtn];
    }
    
    UILabel *cityLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),CGRectGetMaxY(topBtn.frame)+M_WIDTH(8),M_WIDTH(100),M_WIDTH(30))];
    cityLab.text=@"按城市";
    cityLab.font=DESC_FONT;
    cityLab.textColor = APP_BTN_COLOR;
    [reMenView addSubview:cityLab];
    
    CGFloat cellH = CGRectGetMaxY(reMenView.frame);
    
    for (int j=0; j<cellAry.count; j++) {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:cellAry[j]];
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0,cellH,WIN_WIDTH,M_WIDTH(30))];
        [self chuliView:topView text:dic[@"city_name"] viewType:YES isLost:NO];
        [self.scrollView1 addSubview:topView];
        cellH = cellH+M_WIDTH(30);
        
        NSArray *ary = [[NSArray alloc]initWithArray:dic[@"mall_list"]];
        for (int i=0; i<ary.count; i++) {
            NSDictionary *diction = [[NSDictionary alloc]initWithDictionary:ary[i]];
            UIView *cellView1 =[[UIView alloc]initWithFrame:CGRectMake(0,cellH,WIN_WIDTH,M_WIDTH(39))];
            [self chuliView:cellView1 text:diction[@"mall_name"] viewType:NO isLost:i==(ary.count-1)?YES:NO];
            
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellBtnViewEvent:)];
            [cellView1 addGestureRecognizer:tapGesture];
            UIView *tapView1 = [tapGesture view];
            tapView1.tag = j*100+i;
            
            [self.scrollView1 addSubview:cellView1];
            cellH = i==(ary.count-1)? cellH + M_WIDTH(46) : cellH + M_WIDTH(39);
            self.scrollView1.contentSize = CGSizeMake(WIN_WIDTH,cellH);
        }
    }
    [self.scrollView1 addSubview:reMenView];
}

//定位商城事件
-(void)dingweiMarketTouch:(UIButton*)sender{
    
    [self popData:_dataDic[@"near_mall"]];

}

//顶部热门事件
-(void)headBtnTouch:(UIButton*)sender{
    NSDictionary *dic = headAry[sender.tag];
    NSLog(@"%@",dic);
    [self popData:dic];
}

-(void)cellBtnViewEvent:(UITapGestureRecognizer*)tag{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tag;
    int index    = (int)singleTap.view.tag;
    int section  = index/100;
    int rowIndex = index%100;

    NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:cellAry[section][@"mall_list"][rowIndex]];
    NSLog(@"%@的 %@商场",cellAry[section][@"city_name"],cellAry[section][@"mall_list"][rowIndex][@"mall_name"]);
    NSLog(@" %@",dic);
    [self popData:dic];
}

//搜索内容改变的时候，在这个方法里面实现实时显示结果
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    twoTime=2;
    searchStr=searchText;
    [relodeTime setFireDate:[NSDate distantPast]];
}

-(void)timeFireMethod{
    twoTime--;
    if (twoTime==0) {
        [self datachuli];
        [relodeTime setFireDate:[NSDate distantFuture]];
    }
}


-(void)datachuli{
    //先把搜索的数据源整理
    if ([Util isNull:sousuoDataAry]) {
        sousuoDataAry = [[NSMutableArray alloc]init];
        sousuoStrAry  = [[NSMutableArray alloc]init];
        exhibitionDataAry =  [[NSMutableArray alloc]init];
        for (NSDictionary *dic in cellAry) {
            NSArray *array = [[NSArray alloc]initWithArray:dic[@"mall_list"]];
            for (NSDictionary *diction in array) {
                [sousuoDataAry addObject:diction];
                [sousuoStrAry  addObject:diction[@"mall_name"]];
            }
        }
    }
    //用户搜索展示出来的数据处理
    [exhibitionDataAry removeAllObjects];
    if ([Util isNull:searchStr] || [searchStr isEqualToString:@""] || [searchStr isEqualToString:@" "]) {
        tableView1.hidden=YES;
        return;
    }
    
    for (int i=0; i<sousuoStrAry.count; i++) {
        if([sousuoStrAry[i] rangeOfString:searchStr].location !=NSNotFound){
            [exhibitionDataAry addObject:sousuoDataAry[i]];
        }else{
            NSLog(@"no");
        }
    }
    if (exhibitionDataAry.count>0) {
        if ([Util isNull:tableView1]) {
            tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
            tableView1.delegate=self;
            tableView1.dataSource=self;
            tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
            [self.view addSubview:tableView1];
        }else{
            if (isHidden) {
                tableView1.hidden=NO;
                [tableView1 reloadData];
            }
        }
    }else{
        tableView1.hidden=YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [homeTextF resignFirstResponder];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic =[[NSDictionary alloc]initWithDictionary:exhibitionDataAry[indexPath.row]];
    [self popData:dic];
}

-(void)popData:(NSDictionary*)dic{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mall_id=[dic valueForKey:@"mall_id"];
    [Global sharedClient].markID        = mall_id;
    [Global sharedClient].markCookies   = dic[@"mall_id_des"];
    [Global sharedClient].markPrefix    = dic[@"mall_url_prefix"];
    [Global sharedClient].shopName      = dic[@"mall_name"];
    [userDefaults setObject:mall_id                 forKey:@"mall_id"];
    [userDefaults setObject:dic[@"mall_name"]       forKey:@"mall_name"];
    [userDefaults setObject:dic[@"mall_url_prefix"] forKey:@"mall_url_prefix"];
    [userDefaults setObject:dic[@"mall_id_des"]     forKey:@"mall_id_des"];
    
    [Global sharedClient].pushLoadData = @"1";
    [Global sharedClient].isLoginPush = @"0";
    [self.delegate.navigationController popToRootViewControllerAnimated:YES];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return exhibitionDataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"cellid";
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [UIUtil removeSubView:cell];
    
    UIView *view = [self createView:indexPath];
    [cell addSubview:view];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView*)createView:(NSIndexPath*)indexPath{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(40))];
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,WIN_WIDTH - M_WIDTH(50),M_WIDTH(40))];
    titleLab.text=exhibitionDataAry[indexPath.row][@"mall_name"];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = INFO_FONT;
    [view addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(40)-1,WIN_WIDTH - M_WIDTH(10),1)];
    lineView.backgroundColor = COLOR_LINE;
    if (exhibitionDataAry.count!=0 && exhibitionDataAry.count-1 != indexPath.row) {
        [view addSubview:lineView];
    }

    return view;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 开启
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)chuliView:(UIView*)view text:(NSString*)textStr viewType:(BOOL)vType isLost:(BOOL)isLost{
    view.backgroundColor=[UIColor whiteColor];
    CGFloat viewH = vType?M_WIDTH(30):M_WIDTH(39);
    CGFloat lab_juzuo = vType?M_WIDTH(15):M_WIDTH(10);
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(lab_juzuo,0,WIN_WIDTH-M_WIDTH(50),viewH)];
    titleLab.text=textStr;
    titleLab.textColor = vType?COLOR_FONT_SECOND:[UIColor blackColor];
    titleLab.font = vType?SMALL_FONT:INFO_FONT;
    [view addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = COLOR_LINE;
    
    if (vType == YES) {
        lineView.frame = CGRectMake(0,viewH-1,WIN_WIDTH,1);
        [view addSubview:lineView];
    }else{
        if (!isLost) {
            lineView.frame = CGRectMake(M_WIDTH(10),viewH-1,WIN_WIDTH-M_WIDTH(10),1);
            [view addSubview:lineView];
        }
    }
}

//没有数据的时候显示的View
-(void)initnilView{
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT+M_WIDTH(43),WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(43)-45)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
    
}


@end
