//
//  FindStoreController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/23.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "FindStoreController.h"
#import "SelectionBoxView.h"
#import "SearchDetailsCell.h"
#import "ShopeDetailViewController.h"
#import "PullingRefreshTableView.h"
#import "TextSearchController.h"
#import "GoodsDetailViewController.h"
#import "GoViewController.h"
#import "SearchListController.h"
#import "ScreenViewController.h"
#import "ReTableView.h"


@interface FindStoreController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property (strong,nonatomic)UIView          *hiddenView;//rootview
@property (strong,nonatomic)UISegmentedControl   *segment;
@property (strong,nonatomic)SelectionBoxView  *selectionView;//选择框
@property (strong,nonatomic)NSMutableArray     *dataArray;

@end

//---------------------------------商城内搜索商店--------------------------------

@implementation FindStoreController{
    
    UIView              *navView;
    ReTableView      *tableView1;

    NSString  *floorID;//楼层
    NSString  *caixiID;//业态
    NSString  *zhiID;//智能ID
    NSString  *juliID;//距离id
    NSString  *markID;//商场id
    
    UIView      *nilView1; //主界面没有数据
    NSInteger    _page;//页数
    BOOL        isend;
    NSString    *keyStr;    //搜索关键字
    NSMutableArray   *dataArr;
    UIView      *shaixuanView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    floorID=@"0";
    zhiID=@"0";
    caixiID=@"0";
    isend=NO;
    _page=1;
    
     dataArr=[[NSMutableArray alloc]init];
    [self rightbar];
    [self createRootView];
    [self inittable];
    [self NetWorkRequest:nil];
}
-(void)rightbar{
    UIButton *scanBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-88,20,44, 44)];
    [scanBtn1 setImage:[UIImage imageNamed:@"search_Icon"] forState:UIControlStateNormal];
    [scanBtn1 addTarget:self action:@selector(img_BtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:scanBtn1];
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_rightTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
}
//点击筛选事件
-(void)img_rightTouch:(UIButton*)sender{
    shaixuanView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    shaixuanView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    ScreenViewController  *sView=[[ScreenViewController alloc]init];
    
    if ([_setInType isEqualToString:@"0"] || [Util isNull:_setInType]) {
        sView.typeStr=@"0";
        sView.vul_1=juliID;
        sView.vul_2=markID;
    }else{
        sView.typeStr=@"3";
        sView.vul_1=floorID;//楼层
        sView.vul_2=caixiID;//菜系
        sView.vul_3=zhiID;//智能ID
    }
    sView.screeDelegate=self;
    sView.view.backgroundColor=[UIColor whiteColor];
    sView.view.frame=CGRectMake(M_WIDTH(95),0,WIN_WIDTH-M_WIDTH(95),WIN_HEIGHT);
    [shaixuanView addSubview:sView.view];
    [self.view addSubview:shaixuanView];
}

-(void)setScreeViewValue:(id)val{
    if ([_setInType isEqualToString:@"0"] || [Util isNull:_setInType]) {
        juliID =val[0];
        markID =val[1];
    }else{
        floorID=val[0];//楼层
        caixiID=val[1];//菜系
        zhiID  =val[2];;//智能ID
    }
    [shaixuanView removeFromSuperview];
    [self NetWorkRequest:nil];
}

-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}

#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type{

        if (nilView1==Nil) {
        }else{
            [nilView1 removeFromSuperview];
        }
        
        if (type == nil || [type isEqualToString:REFRESH_METHOD]) {
            _page = 1;
            isend=NO;
        }else {
            if (isend==YES) {
                [tableView1 tableViewDidFinishedLoading];
                [tableView1 noticeNoMoreData];
                return;
            }else {
                _page++;
           }
         }
    
        if ([Util isNull:_pushkeyStr]) {
            NSLog(@"asdadsa");
        }else {
            keyStr=_pushkeyStr;
            _pushkeyStr=nil;
        }
    
        NSString *type1;
        NSString *sort1;
        int       floor1;
    
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
        if ([floorID isEqualToString:@"0"]) {
            floor1=0;
        }else {
            floor1=[floorID intValue];
        }
        
        
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
        int zz=[[Global sharedClient].markID intValue];
        NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(floor1),@"Floor",type1,@"Type",sort1,@"sort",@(_page),@"Page",@"10",@"pageSize",keyStr,@"Key", nil];
        
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadshoplist"] parameters:diction  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                if([dic[@"data"] isKindOfClass:[NSDictionary class]])
                {
                    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                        [dataArr removeAllObjects];
                        dataArr=[[NSMutableArray alloc]init];
                    }
                    isend =[dic[@"data"][@"isend"]boolValue];
                    [dataArr addObjectsFromArray:dic[@"data"][@"shoplist"]];
                    [tableView1 reloadData];
                    
                    if (dataArr.count==0 &&_page==1) {
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

-(void)createRootView{
    self.hiddenView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    self.hiddenView.backgroundColor=UIColorFromRGB(0xf3f3f3);
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(67))];
    view.backgroundColor=APP_NAV_COLOR;
    [self.hiddenView addSubview:view];
    [self.view addSubview:self.hiddenView];
}


-(void)inittable{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,10,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-10) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.scrollEnabled=YES;
    tableView1.refreshTVDelegate=self;
    [self.hiddenView addSubview:tableView1];
}
-(void)initnilView{
    //没有数据的时候显示
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT+40,WIN_WIDTH,WIN_HEIGHT- NAV_HEIGHT-40)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.hiddenView addSubview:nilView1];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArr.count;
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellID4";
    SearchDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[SearchDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *dic=dataArr[indexPath.section];
    [cell.bigImgView setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"logo_img_url"]]]];
    cell.nameLab.text     =[Util isNil:dic[@"shop_name"]];
    cell.explainLab.text  =[Util isNil:dic[@"type_name"]];
    cell.addressLab.text  =[Util isNil:dic[@"floor_name"]];

    [cell.nameLab sizeToFit];
    [cell.explainLab sizeToFit];
    [cell.addressLab sizeToFit];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [dataArr objectAtIndex:indexPath.section];
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = [dic valueForKey:@"shopdetail_url"];
    [self.delegate.navigationController pushViewController: vc animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [shaixuanView removeFromSuperview];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)img_BtnTouch:(UIButton*)sender
{
    SearchListController *vc=[[SearchListController alloc]init];
    vc.typeStr=@"3";
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 -(void)NetWorkRequest2
 {
 
 int zz=[[Global sharedClient].markID intValue];
 NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@"",@"t",nil];
 
 [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"] parameters:diction  target:self success:^(NSDictionary *dic){
 dispatch_async(dispatch_get_main_queue(), ^{
 
 NSLog(@"%@",dic);
 NSArray * shopFloor    = dic[@"data"][@"ShopFloor"];
 NSArray * ShopType     = dic[@"data"][@"ShopType"];
 for (NSDictionary *dic1 in shopFloor) {
 NSString *nameStr  = [Util isNil:dic1[@"name"]];
 NSString *idStr    = [Util isNil:dic1[@"id"]];
 [ShopFloorAry addObject:nameStr];
 [ShopFloorID  addObject:idStr];
 }
 NSLog(@"%@",ShopFloorAry);
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
 
 
 
 //点击头部选择按钮弹出view事件
 -(void) onSelectTypeTap:(UITapGestureRecognizer*) tap{
 
 isend=NO;
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
 
 _selectionView.dataArray=[self addquanbu:ShopFloorAry :@"全部楼层"];//
 _selectionView.idArray  =[self addquanbu:ShopFloorID :@"0"];
 _selectionView.type     =@"1";//目的是为了返回的时候知道我传过去的是什么类型
 
 _selectionView.curSelectId = floorID;
 break;
 
 case 101:
 
 _selectionView.dataArray=[self addquanbu:ShopTypeAry :@"全部业态"];
 _selectionView.idArray  =[self addquanbu:ShopTypeID :@"0"];
 _selectionView.type     =@"2";
 _selectionView.curSelectId = _caixiID;
 break;
 case 102:
 
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
 
 [muAry addObject:str];
 
 
 for (int i=0; i<mAry.count; i++) {
 NSString *str=mAry[i];
 [muAry addObject:str];
 }
 return muAry;
 }
 
 
 }
 #pragma mark  ------弹出视图代理事件-------
 -(void)cancelSelect{
 
 UIImageView* upImgView = [curDealView viewWithTag:500];
 [upImgView setImage:[UIImage imageNamed:@"down"]];
 }
 
 -(void)setdelegate:(id)selecDelegate
 {
 
 NSString *strType=selecDelegate[0];
 UIImageView* upImg;
 UILabel* curLabel;
 UIView* view_3;
 if ([strType isEqualToString:@"1"]) {
 
 floorID=selecDelegate[1];
 curLabel = froolLab;
 
 }else if ([strType isEqualToString:@"2"]){
 
 _caixiID =selecDelegate[1];
 curLabel = yetaiLab;
 
 }else {
 zhiID=selecDelegate[1];
 curLabel= zhinengLab;
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
 [logoAry            removeAllObjects];
 [shop_nameAry       removeAllObjects];
 [type_nameAry       removeAllObjects];
 [shop_idAry         removeAllObjects];
 [floor_nameAry      removeAllObjects];
 [self NetWorkRequest:nil];
 
 }

 
 #pragma mark ---创建搜索视图---
 
 -(void)initHiddenView
 {
 self.hiddenView=[[UIView alloc]initWithFrame:self.view.bounds];
 self.hiddenView.backgroundColor=UIColorFromRGB(0xf0f0f0);
 btnView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH,40)];
 btnView.backgroundColor=[UIColor whiteColor];
 
 for (int i=0; i<3; i++) {
 UIView *view_3=[[UIView alloc]initWithFrame:CGRectMake((WIN_WIDTH/3)*i,0, WIN_WIDTH/3, 40)];
 view_3.backgroundColor=[UIColor whiteColor];
 float imgW = 15*2/3;
 float imgH = 8*2/3;
 UIImageView *upImg=[[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH/3), (view_3.frame.size.height - imgH)/2,imgW, imgH)];
 [upImg setImage:[UIImage imageNamed:@"down"]];
 upImg.tag = 500;
 if (i==0) {
 froolLab.frame=CGRectMake(0, 0, btnView.frame.size.width, btnView.frame.size.height);
 froolLab.text=array2[i];
 froolLab.font=COMMON_FONT;
 froolLab.textAlignment=NSTextAlignmentRight;
 [froolLab sizeToFit];
 CGRect frame = froolLab.frame;
 frame.origin.x = [self computLabelXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
 frame.size.height = btnView.frame.size.height;
 froolLab.frame = frame;
 [view_3 addSubview:froolLab];
 frame = upImg.frame;
 frame.origin.x = [self computImgXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:froolLab.frame.size.width padding:4];
 upImg.frame = frame;
 
 }else if(i==1){
 yetaiLab.frame=CGRectMake(0, 0, btnView.frame.size.width, btnView.frame.size.height);
 if ([Util isNull:_yetaiStr]) {
 yetaiLab.text=array2[i];
 }else{
 yetaiLab.text=_yetaiStr;
 }
 yetaiLab.font=COMMON_FONT;
 yetaiLab.textAlignment=NSTextAlignmentRight;
 [yetaiLab sizeToFit];
 CGRect frame = yetaiLab.frame;
 frame.origin.x = [self computLabelXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
 frame.size.height = btnView.frame.size.height;
 yetaiLab.frame = frame;
 [view_3 addSubview:yetaiLab];
 frame = upImg.frame;
 frame.origin.x = [self computImgXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:yetaiLab.frame.size.width padding:4];
 upImg.frame = frame;
 
 }else if(i==2){
 zhinengLab.frame=CGRectMake(0, 0, btnView.frame.size.width, btnView.frame.size.height);
 zhinengLab.text=array2[i];
 zhinengLab.font=COMMON_FONT;
 zhinengLab.textAlignment=NSTextAlignmentRight;
 [zhinengLab sizeToFit];
 CGRect frame = zhinengLab.frame;
 frame.size.height = btnView.frame.size.height;
 frame.origin.x = [self computLabelXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
 zhinengLab.frame = frame;
 [view_3 addSubview:zhinengLab];
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
 UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0,39,WIN_WIDTH, 1)];
 lineview.backgroundColor=COLOR_LINE;
 [btnView addSubview:lineview];
 [self.hiddenView addSubview:btnView];
 
 }
 
 -(float) computLabelXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
 return (pWidth - (imgWidth+labelWidth+padding))/2;
 }
 
 -(float) computImgXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
 return (pWidth - (imgWidth+labelWidth+padding))/2 + labelWidth + padding;
 }
 
 
 //    froolLab            =[[UILabel alloc]init];
 //    yetaiLab            =[[UILabel alloc]init];
 //    zhinengLab          =[[UILabel alloc]init];
 //搜索
 //    ShopFloorAry    =[[NSMutableArray alloc]init];
 //    ShopFloorID     =[[NSMutableArray alloc]init];
 //    ShopTypeAry     =[[NSMutableArray alloc]init];
 //    ShopTypeID      =[[NSMutableArray alloc]init];
 
 //    array2              =[[NSArray alloc]initWithObjects:@"全部楼层",@"全部业态",@"智能排序", nil];
 //    zhinengAry          =[[NSArray alloc]initWithObjects:@"默认排序",@"人气最高",@"有团购",@"有促销优惠",@"A-Z字母排序",@"有卡券",@"有报名",@"有排队", nil];
 //    zhinengID           =[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
 
 
 
 NSMutableArray          *logoAry;//图
 NSMutableArray          *shop_nameAry;//名字
 NSMutableArray          *type_nameAry;//类型名
 NSMutableArray          *shop_idAry;//id
 NSMutableArray          *floor_nameAry;//地址
 //搜索
 NSMutableArray          *logoAry1;//图
 NSMutableArray          *shop_nameAry1;//名字
 NSMutableArray          *type_nameAry1;//类型名
 NSMutableArray          *shop_idAry1;//id
 NSMutableArray          *floor_nameAry1;//地址
 NSMutableArray          *ShopFloorAry;//楼层名字
 NSMutableArray          *ShopFloorID;//楼层ID
 NSMutableArray          *ShopTypeAry;//菜系名字
 NSMutableArray          *ShopTypeID;//菜系ID
 
 UILabel                 *froolLab;
 UILabel                 *yetaiLab;
 UILabel                 *zhinengLab;
 
 
 UIView           *curDealView;
 UIView           *btnView;
 NSArray          *array2;
 NSArray          *zhinengAry;
 NSArray          *zhinengID;
 
*/

@end
