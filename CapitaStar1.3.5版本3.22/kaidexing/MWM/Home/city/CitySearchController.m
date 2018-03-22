//
//  CitySearchController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "CitySearchController.h"
#import "SelectionBoxView.h"
#import "SearchDetailsCell.h"
#import "ShopeDetailViewController.h"
#import "PullingRefreshTableView.h"
#import "TextSearchController.h"
#import "GoodsDetailViewController.h"
#import "GoViewController.h"
#import "KDSearchBar.h"
#import "ReTableView.h"
#import "ScreenViewController.h"

@interface CitySearchController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZhuRefreshTableView,screeViewDelegate>
@property (strong,nonatomic)UIView          *hiddenView;//rootview
@property (strong,nonatomic)KDSearchBar     *textField1;//搜索框
@property (strong,nonatomic)UISegmentedControl   *segment;
@property (strong,nonatomic)SelectionBoxView  *selectionView;//选择框
@property (strong,nonatomic)NSMutableArray     *dataArray;

@end

@implementation CitySearchController{
    
    TextSearchController *tVC;
    UIView   *navView;
    ReTableView      *tableView1;
    NSArray  *array2;
    NSArray  *zhinengAry;
    NSArray  *zhinengID;
    NSString  *floorID;//楼层id
    NSString  *zhiID;//智能ID
    //搜索
    NSMutableArray  *dataArr;   //商户数据
    NSString        *keyStr;    //搜索关键字
    UIView          *nilView1; //主界面没有数据
    BOOL             isend;//判断是否有数据
    NSInteger        _page;//页数
    CGFloat          tableView_top;
    CGSize           kbSize;
    UIView    *curDealView;
    UIView    *btnView;
    UIView    *shaixuanView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self initNvc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorFromRGB(0xf3f3f3);
    isend=NO;
    zhiID=@"0";
    keyStr=@"";
    _page=1;
    dataArr= [[NSMutableArray alloc]init];
    [self createRootView];
    [self rightbar];
    [self inittable];
    [self NetWorkRequest:nil];
}
-(void)createRootView{
    self.hiddenView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    self.hiddenView.backgroundColor=[UIColor clearColor];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(67))];
    view.backgroundColor=APP_NAV_COLOR;
    [self.hiddenView addSubview:view];
    [self.view addSubview:self.hiddenView];
    
}
-(void)rightbar{
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"search_Icon"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_rightTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
}
//点击筛选事件
-(void)img_rightTouch:(UIButton*)sender{
    shaixuanView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    shaixuanView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    ScreenViewController  *sView=[[ScreenViewController alloc]init];
    
    sView.typeStr=@"5";
    sView.vul_1=_caixiID;//业态
    sView.vul_2=zhiID;//智能ID
    
    sView.screeDelegate=self;
    sView.view.backgroundColor=[UIColor whiteColor];
    sView.view.frame=CGRectMake(M_WIDTH(95),0,WIN_WIDTH-M_WIDTH(95),WIN_HEIGHT);
    [shaixuanView addSubview:sView.view];
    [self.view addSubview:shaixuanView];
}

-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}

#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type{
    
    [nilView1 removeFromSuperview];
    
    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
        isend=NO;
        _page = 1;
    }else{
        if (isend == YES) {
            [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
            [tableView1 tableViewDidFinishedLoading];
            [tableView1 noticeNoMoreData];
            return;
        }else {
            _page ++;
        }
    }
    if (type == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    
    if ([Util isNull:_pushkeyStr]) {
        NSLog(@"asdadsa");
    }else {
        keyStr=_pushkeyStr;
        self.textField1.text=_pushkeyStr;
        _pushkeyStr=nil;
    }
    
    NSString *type1;
    NSString *sort1;
    if ([Util isNull:_caixiID]) {
        type1=@"0";
    }else {
        type1=_caixiID;
    }
    if ([zhiID isEqualToString:@"0"]) {
        sort1=@"0";
    }else {
        sort1=zhiID;
    }
    int zz;
    NSUserDefaults *cityNSU=[NSUserDefaults standardUserDefaults];
    if ([cityNSU valueForKey:@"city"]==nil) {
        zz=1;
    }else{
        zz=[[cityNSU valueForKey:@"city"] intValue];
    }
    
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"city",type1,@"Type",sort1,@"sort",@(_page),@"Page",@"10",@"pageSize",keyStr,@"Key", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"nomallloadshop"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                    [dataArr removeAllObjects];
                }
                NSArray *array=dic[@"data"][@"shoplist"];
                isend =[dic[@"data"][@"isend"]boolValue];
                [dataArr addObjectsFromArray:array];
                [tableView1 reloadData];
                if (dataArr.count==0) {
                    [self initnilView];
                }
                
            }else {
                [self initnilView];
            }
            [tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
    
}

-(void)initNvc{
    self.textField1=[[KDSearchBar alloc]initWithFrame:CGRectMake(40, 7+STATUS_BAR_HEIGHT, WIN_WIDTH-95, 32)];
    self.textField1.newFrame=self.textField1.bounds;
    self.textField1.placeholder=@"输入门店名、品牌名";
    self.textField1.delegate=self;
    [self.navigationBar addSubview:self.textField1];
}

-(void)inittable{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,10,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-10) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.scrollEnabled=YES;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.refreshTVDelegate=self;
    [self.hiddenView addSubview:tableView1];
    
    tVC=[[TextSearchController alloc]init];
    tVC.tableview_top=0;
    tVC.tableview_H=WIN_HEIGHT - NAV_HEIGHT;
    tVC.typrStr=@"0";
    tVC.textdelegate=self;
    tVC.view.frame=self.view.frame;
    tVC.view.hidden = YES;
    [self.view addSubview:tVC.view];
    
    self.keyboardContainer = tVC.tableView1;
}


-(void)initnilView{
    //没有数据的时候显示
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, 127, WIN_WIDTH, WIN_HEIGHT-127)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-110, 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.hiddenView addSubview:nilView1];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return M_WIDTH(83);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return M_WIDTH(8);
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    
    view.tintColor=[UIColor clearColor];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier=@"cellID4";
    SearchDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[SearchDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *dic=dataArr[indexPath.section];
    [cell.bigImgView setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"logo_img_url"]]]];
    cell.nameLab.text     =[Util isNil:dic[@"shop_name"]];
    cell.explainLab.text  =[Util isNil:dic[@"type_name"]];
    cell.addressLab.text  =[Util isNil:dic[@"mall_name"]];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [dataArr objectAtIndex:indexPath.row];
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = [dic valueForKey:@"shopdetail_url"];
    [self.delegate.navigationController pushViewController: vc animated:YES];
}



//输入框点击return
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.textField1 resignFirstResponder];
    tableView1.hidden = YES;
    tVC.textFStr = self.textField1.text;
    [tVC NetWorkRequest:nil];
    tVC.view.hidden = NO;

}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了空白处");
    [self.textField1 resignFirstResponder];
}


-(void)settexthidden:(id)hidden{
    [self.textField1 resignFirstResponder];
    GoViewController *gvc=[[GoViewController alloc]init];
    gvc.path=hidden;
    [self.delegate.navigationController pushViewController:gvc animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [navView removeFromSuperview];
    
}


/*
 
 
 
 #pragma mark  ------弹出视图代理事件-------
 -(void)cancelSelect{
 
 UIImageView* upImgView = [curDealView viewWithTag:500];
 [upImgView setImage:[UIImage imageNamed:@"down"]];
 }
 

 
 -(void)NetWorkRequest2{
 NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"mall_id",@"",@"t",nil];
 
 [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"] parameters:diction  target:self success:^(NSDictionary *dic){
 dispatch_async(dispatch_get_main_queue(), ^{
 
 NSLog(@"%@",dic);
 NSArray * ShopType     = dic[@"data"][@"ShopType"];
 
 for (NSDictionary *dic2 in ShopType) {
 NSString *idStr    = [Util isNil:dic2[@"id"]];
 NSString *nameStr  = [Util isNil:dic2[@"name"]];
 [ShopTypeAry addObject:nameStr];
 [ShopTypeID  addObject:idStr];
 }
 [SVProgressHUD dismiss];
 });
 }failue:^(NSDictionary *dic){
 
 }];
 }
 
 
 //点击头部选择按钮弹出view事件
 -(void) onSelectTypeTap:(UITapGestureRecognizer*) tap{
 [self.textField1 resignFirstResponder];
 if (_selectionView !=nil) {
 [_selectionView removeFromSuperview];
 }
 
 curDealView = [tap view];
 NSInteger index=[tap view].tag;
 UIImageView* upImgView = [[tap view] viewWithTag:500];
 [upImgView setImage:[UIImage imageNamed:@"up"]];
 
 _selectionView=[[SelectionBoxView alloc]init];
 _selectionView.backgroundColor=[UIColor clearColor];
 _selectionView.frame=self.view.bounds;
 _selectionView.xPoint = CGRectGetMaxY(btnView.frame);
 _selectionView.selectioDelegate=self;
 [self.view addSubview:_selectionView];
 
 switch (index) {
 
 case 100:
 _selectionView.dataArray=[self addquanbu:ShopTypeAry :@"1"];
 _selectionView.idArray  =[self addquanbu:ShopTypeID :@"id"];
 _selectionView.type     =@"2";
 
 _selectionView.curSelectId = _caixiID;
 break;
 case 101:
 _selectionView.dataArray=zhinengAry;
 _selectionView.idArray  =zhinengID;
 _selectionView.type     =@"3";
 _selectionView.curSelectId = zhiID;
 break;
 
 default:
 break;
 }
 
 }
 
 
 -(NSMutableArray*)addquanbu:(NSMutableArray *)mAry  :(NSString *)str
 {
 NSMutableArray *muAry=[[NSMutableArray alloc]init];
 if ([str isEqualToString:@"1"]) {
 [muAry addObject:@"全部业态"];
 }else {
 [muAry addObject:@"0"];
 }
 
 for (int i=0; i<mAry.count; i++) {
 NSString *str=mAry[i];
 [muAry addObject:str];
 }
 return muAry;
 }
 
 -(void)setdelegate:(id)selecDelegate
 {
 isend=NO;
 [self.textField1 resignFirstResponder];
 NSString *strType=selecDelegate[0];
 UIImageView* upImg;
 UILabel* curLabel;
 UIView* view_3;
 if ([strType isEqualToString:@"2"]){
 
 _caixiID =selecDelegate[1];
 curLabel = yetaiLab;
 
 }else {
 
 zhiID=selecDelegate[1];
 curLabel = zhinengLab;
 }
 
 view_3 = [curLabel superview];
 upImg = [view_3 viewWithTag:500];
 
 curLabel.text=selecDelegate[2];
 [curLabel sizeToFit];
 [upImg setImage:[UIImage imageNamed:@"down"]];
 
 CGRect frame = curLabel.frame;
 frame.size.height = btnView.frame.size.height;
 frame.origin.x = [self computLabelXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
 curLabel.frame = frame;
 frame = upImg.frame;
 frame.origin.x = [self computImgXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:curLabel.frame.size.width padding:4];
 upImg.frame = frame;
 
 [self NetWorkRequest:nil];
 }
 
 
 #pragma mark - PullingRefreshTableViewDelegate
 - (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
 [self performSelector:@selector(NetWorkRequest:) withObject:REFRESH_METHOD afterDelay:0.f];
 }
 
 - (NSDate *)pullingTableViewRefreshingFinishedDate{
 return [[NSDate alloc] init];
 }
 
 - (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
 [self performSelector:@selector(NetWorkRequest:) withObject:MORE_METHOD afterDelay:0.f];
 
 }
 - (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
 [self.textField1 resignFirstResponder];
 [tableView1 tableViewDidScroll:vScrollView];
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
 [tableView1 tableViewDidEndDragging:vScrollView];
 }
 
 
 #pragma mark ---创建搜索视图---
 
 -(void)initHiddenView{
 self.hiddenView=[[UIView alloc]initWithFrame:self.view.bounds];
 self.hiddenView.backgroundColor=UIColorFromRGB(0xf0f0f0);
 btnView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, 40)];
 btnView.backgroundColor=[UIColor whiteColor];
 
 for (int i=0; i<2; i++) {
 UIView *view_3=[[UIView alloc]initWithFrame:CGRectMake((WIN_WIDTH/2)*i,0, WIN_WIDTH/2, 40)];
 view_3.backgroundColor=[UIColor whiteColor];
 float imgW = 15*2/3;
 float imgH = 8*2/3;
 UIImageView *upImg=[[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH/3), (view_3.frame.size.height - imgH)/2,imgW, imgH)];
 [upImg setImage:[UIImage imageNamed:@"down"]];
 upImg.tag = 500;
 
 if (i==0) {
 yetaiLab.frame=CGRectMake(0,0,WIN_WIDTH/2 -WIN_WIDTH/6-5, 16);;
 yetaiLab.textAlignment=NSTextAlignmentRight;
 yetaiLab.font=COMMON_FONT;
 if ([Util isNull:_yetaiStr]) {
 yetaiLab.text=array2[i];
 }else {
 yetaiLab.text=_yetaiStr;
 }
 [yetaiLab sizeToFit];
 
 [view_3 addSubview:yetaiLab];
 
 CGRect frame = yetaiLab.frame;
 frame.origin.x = [self computLabelXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
 frame.size.height = btnView.frame.size.height;
 yetaiLab.frame = frame;
 
 frame = upImg.frame;
 frame.origin.x = [self computImgXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:yetaiLab.frame.size.width padding:4];
 upImg.frame = frame;
 }else{
 zhinengLab.frame=CGRectMake(0,0,WIN_WIDTH/2 -WIN_WIDTH/6 -5, 16);
 zhinengLab.textAlignment=NSTextAlignmentRight;
 zhinengLab.font=COMMON_FONT;
 zhinengLab.text=array2[i];
 [view_3 addSubview:zhinengLab];
 [zhinengLab sizeToFit];
 
 CGRect frame = zhinengLab.frame;
 frame.origin.x = [self computLabelXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
 frame.size.height = btnView.frame.size.height;
 zhinengLab.frame = frame;
 
 frame = upImg.frame;
 frame.origin.x = [self computImgXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:zhinengLab.frame.size.width padding:4];
 upImg.frame = frame;
 }
 
 view_3.tag=100+i;
 UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectTypeTap:)];
 [view_3 addGestureRecognizer:tap];
 
 [view_3 addSubview:upImg];
 
 [btnView addSubview:view_3];
 }
 
 [self.hiddenView addSubview:btnView];
 }
 
 -(float) computLabelXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
 return (pWidth - (imgWidth+labelWidth+padding))/2;
 }
 
 -(float) computImgXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
 return (pWidth - (imgWidth+labelWidth+padding))/2 + labelWidth + padding;
 }
 
 
 */

@end
