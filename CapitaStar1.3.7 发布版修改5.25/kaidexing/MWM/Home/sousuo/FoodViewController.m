//
//  FoodViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/20.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "FoodViewController.h"
#import "SelectionBoxView.h"
#import "SearchDetailsCell.h"
#import "ShopeDetailViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodsDetailViewController.h"
#import "GoViewController.h"
#import "SearchListController.h"
#import "ScreenViewController.h"
#import "ReTableView.h"

@interface FoodViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property (strong,nonatomic)UIView              *hiddenView;//rootview
@property (strong,nonatomic)SelectionBoxView    *selectionView;//选择框
@end


//------------------------------美食列表--------------------------

@implementation FoodViewController{
    
    ReTableView   *tableView1;
    
    NSString  *floorID;//楼层
    NSString  *caixiID;//菜系
    NSString  *zhiID;//智能ID
    NSString  *juliID;//距离id
    NSString  *markID;//商场id
    
    NSInteger  pageNum;
    UIView    *nilView1; //主界面没有数据

    UIView    *curDealView;
    BOOL       isend;
    UIView    *btnView;
    UIView    *shaixuanView;
    NSMutableArray   *dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isend=NO;
    floorID=@"0";
    caixiID=@"0";
    zhiID=@"0";
    
    pageNum=1;

    dataArr = [[NSMutableArray alloc]init];
    [self createRootView];
    [self rightbar];
    [self initableview];
    [self NetWorkRequest:nil];
}

-(void)createRootView{
    self.hiddenView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    self.hiddenView.backgroundColor=UIColorFromRGB(0xf3f3f3);
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(67))];
    view.backgroundColor=APP_NAV_COLOR;
    [self.hiddenView addSubview:view];
    
}

-(void)rightbar{
    UIButton * scanBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-88,20,44, 44)];
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
        sView.typeStr=@"2";
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
    
    [nilView1 removeFromSuperview];
    int zz=[[Global sharedClient].markID intValue];
    
    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
        isend=NO;
        pageNum=1;
    }else if (isend==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [tableView1 tableViewDidFinishedLoading];
        [tableView1 noticeNoMoreData];
        return;
    }else {
        pageNum++;
    }
    
    if (type == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    
    NSString * floorint;
    int  caixiint;
    int  typrint;
    
    
    if ([floorID isEqualToString:@"0"]) {
        floorint=@"0";
    }else {
        floorint=floorID;
    }
    
    if ([caixiID isEqualToString:@"0"]) {
        caixiint=0;
    }else {
        caixiint=[caixiID intValue];
    }
    
    if ([zhiID isEqualToString:@"0"]) {
        typrint=0;
    }else {
        typrint=[zhiID intValue];
    }
    
//    NSUserDefaults *cityNSU=[NSUserDefaults standardUserDefaults];
//    NSString  *latitude =[cityNSU valueForKey:@"latitude"];
//    NSString  *longitude=[cityNSU valueForKey:@"longitude"];
    
    
    
    [nilView1 removeFromSuperview];
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",floorint,@"Floor",@(caixiint),@"Type",@(typrint),@"sort",@(pageNum),@"Page",@"10",@"pageSize",@"",@"Key", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadfoodlist"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
        if([dic[@"data"] isKindOfClass:[NSDictionary class]])
        {
            
            if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                [dataArr removeAllObjects];
            }
            
            NSLog(@"%@",dic);
            NSArray *array=dic[@"data"][@"foodlist"];
            isend  =[dic[@"data"][@"isEnd"]boolValue];
            [dataArr addObjectsFromArray:array];
            [tableView1 reloadData];
            
        }
            if (dataArr.count==0 ) {
                [self initnilView];
            }
            
            [tableView1 tableViewDidFinishedLoading];
            
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}


-(void)initableview{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,10, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-10) style:UITableViewStylePlain];
    
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.scrollEnabled=YES;
    tableView1.refreshTVDelegate=self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    [tableView1.backgroundView addGestureRecognizer:tap];
    [self.hiddenView addSubview:tableView1];
    [self.view addSubview:_hiddenView];
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return M_WIDTH(91);
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    [UIUtil removeSubView:cell];
    UIView *view = [self createCellView:indexPath];
    [cell addSubview:view];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    return cell;
}

-(UIView*)createCellView:(NSIndexPath*)indexPath{
    //美食cell
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(9),0,WIN_WIDTH-M_WIDTH(18),M_WIDTH(91))];
    rootView.backgroundColor=[UIColor whiteColor];
    UIImageView* bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11), M_WIDTH(11), M_WIDTH(85), M_WIDTH(61))];
    NSString* logStr = [Util isNil:dataArr[indexPath.section][@"logo_img_url"]];
    [bigImgView setImageWithURL:[NSURL URLWithString:logStr]];
    [rootView addSubview:bigImgView];
    
    //标题
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigImgView.frame)+M_WIDTH(5),M_WIDTH(9),10, M_WIDTH(16))];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.font=COOL_FONT;
    nameLab.text=[Util isNil:dataArr[indexPath.section][@"shop_name"]];
    CGRect tmpRect = [nameLab.text boundingRectWithSize:CGSizeMake(rootView.frame.size.width -M_WIDTH(110),M_WIDTH(16))
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:nameLab.font,NSFontAttributeName, nil] context:nil];
    nameLab.frame = CGRectMake(nameLab.frame.origin.x,nameLab.frame.origin.y,tmpRect.size.width,tmpRect.size.height);
    [rootView addSubview:nameLab];
    
    //促
    UILabel*cuLab=[[UILabel alloc]init];
    cuLab.backgroundColor=UIColorFromRGB(0xfe6732);
    cuLab.text=@"促";
    cuLab.font=INFO_FONT;
    cuLab.textAlignment=NSTextAlignmentCenter;
    cuLab.textColor=[UIColor whiteColor];
    
    //排
    UILabel* paiLab=[[UILabel alloc]init];
    paiLab.backgroundColor=UIColorFromRGB(0xaabeb);
    paiLab.text=@"排";
    paiLab.font=INFO_FONT;
    paiLab.textAlignment=NSTextAlignmentCenter;
    paiLab.textColor=[UIColor whiteColor];
    
    //券
    UILabel *juanLab=[[UILabel alloc]init];
    juanLab.text=@"券";
    juanLab.backgroundColor=UIColorFromRGB(0x5ab628);
    juanLab.font=INFO_FONT;
    juanLab.textAlignment=NSTextAlignmentCenter;
    juanLab.textColor=[UIColor whiteColor];
    
    float     lab_top=M_WIDTH(11);
    CGFloat   lab_H=M_WIDTH(13);
    
    CGFloat   lab_laft_w_1=CGRectGetMaxX(nameLab.frame)+M_WIDTH(5);
    CGFloat   lab_laft_w_2=CGRectGetMaxX(nameLab.frame)+M_WIDTH(21);
    CGFloat   lab_laft_w_3=CGRectGetMaxX(nameLab.frame)+M_WIDTH(37);
    
    NSString    *queue_status  =[Util isNil:dataArr[indexPath.section][@"queue_status"]];
    NSString    *sale_status  =[Util isNil:dataArr[indexPath.section][@"sale_status"]];
    NSString    *coupon_status =[Util isNil:dataArr[indexPath.section][@"coupon_status"]];
    if ([queue_status isEqualToString:@"1"]) {
        if ([sale_status isEqualToString:@"1"]) {
            if ([coupon_status isEqualToString:@"1"]) {
                paiLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
                cuLab   .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
                juanLab .frame=CGRectMake(lab_laft_w_3, lab_top, lab_H, lab_H);
                [rootView addSubview:paiLab];
                [rootView addSubview:cuLab];
                [rootView addSubview:juanLab];
                
            }else{
                paiLab.frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
                cuLab .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
                [rootView addSubview:paiLab];
                [rootView addSubview:cuLab];
            }
        }else if ([coupon_status isEqualToString:@"1"]) {
            
            paiLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            juanLab .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
            [rootView addSubview:paiLab];
            [rootView addSubview:juanLab];
            
        }else {
            paiLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            [rootView addSubview:paiLab];
        }
        
        
    }else if ([sale_status isEqualToString:@"1"]) {
        if ([coupon_status isEqualToString:@"1"]) {
            cuLab   .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            juanLab .frame=CGRectMake(lab_laft_w_2, lab_top, lab_H, lab_H);
            [rootView addSubview:cuLab];
            [rootView addSubview:juanLab];
        }else {
            cuLab.frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
            [rootView addSubview:cuLab];
        }
    }else if ([coupon_status isEqualToString:@"1"]) {
        juanLab  .frame=CGRectMake(lab_laft_w_1, lab_top, lab_H, lab_H);
        [rootView addSubview:juanLab];
    }

    
    //是否推荐img
//    UIImageView *istuijianIMG=[[UIImageView alloc]initWithFrame:CGRectMake(rootView.frame.size.width-M_WIDTH(35),0,M_WIDTH(26),M_WIDTH(32))];
//    istuijianIMG.contentMode=UIViewContentModeScaleAspectFit;
//    istuijianIMG.userInteractionEnabled=YES;
//    [istuijianIMG setImage:[UIImage imageNamed:@"recommend"]];
//    [rootView addSubview:istuijianIMG];

    //人均
    UILabel *explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigImgView.frame)+M_WIDTH(5), CGRectGetMaxY(nameLab.frame)+M_WIDTH(5),M_WIDTH(50), M_WIDTH(12))];
    explainLab.textColor=[UIColor blackColor];
    explainLab.textAlignment=NSTextAlignmentCenter;
    explainLab.font=INFO_FONT;
    explainLab.layer.masksToBounds=YES;
    explainLab.text=[Util isNil:dataArr[indexPath.section][@"type_name"]];;
    [explainLab sizeToFit];
    explainLab.layer.cornerRadius=explainLab.frame.size.height/2;
    [rootView addSubview:explainLab];

    //地址图标
    UIImageView *img_Down1=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigImgView.frame)+M_WIDTH(5),CGRectGetMaxY(bigImgView.frame)-M_WIDTH(14), M_WIDTH(11), M_WIDTH(12))];
    [img_Down1 setImage:[UIImage imageNamed:@"location"]];
    [rootView addSubview:img_Down1];

    //店铺地址
    UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_Down1.frame)+M_WIDTH(2),CGRectGetMaxY(bigImgView.frame)-M_WIDTH(13), M_WIDTH(100), M_WIDTH(12))];
    addressLab.font=INFO_FONT;
    addressLab.textColor=COLOR_FONT_SECOND;
    addressLab.textAlignment=NSTextAlignmentLeft;
    addressLab.text=[Util isNil:dataArr[indexPath.section][@"floor_name"]];;
    [rootView addSubview:addressLab];

    UIView *buttomLine = [[UIView alloc]initWithFrame:CGRectMake(0,rootView.frame.size.height-M_WIDTH(8),rootView.frame.size.width,M_WIDTH(8))];
    buttomLine.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [rootView addSubview:buttomLine];
    
    return rootView;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [dataArr objectAtIndex:indexPath.section];
    GoViewController* vc = [[GoViewController alloc] init];
    vc.path = [dic valueForKey:@"link_url"];
    [self.delegate.navigationController pushViewController: vc animated:YES];
    
}


-(void)initnilView
{
    //没有数据的时候显示
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+40, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-40)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.hiddenView addSubview:nilView1];
    
}

-(void)tap:(UISwipeGestureRecognizer *)recognizer{
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [shaixuanView removeFromSuperview];
    [self.view endEditing:YES];
    [tableView1 endEditing:YES];
}
- (IBAction)dismissKeyboard:(id)sender {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)img_BtnTouch:(UIButton*)sender
{
    SearchListController *vc=[[SearchListController alloc]init];
     vc.typeStr=@"0";
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


//-(void)initHiddenView
//{
 
//    UIView *line_x=[[UIView alloc]initWithFrame:CGRectMake(0,39,WIN_WIDTH,1)];
//    line_x.backgroundColor=COLOR_LINE;
//    [btnView addSubview:line_x];
//    [self.hiddenView addSubview:btnView];
//}
//#pragma mark  ------弹出视图代理事件-------
//-(void)setdelegate:(id)selecDelegate
//{
//    isend=NO;
//    pageNum=1;
//    NSString *strType=selecDelegate[0];
//    UIImageView* upImg;
//    UILabel* curLabel;
//    UIView* view_3;
//    if ([strType isEqualToString:@"1"]) {
//        
//        floorID=selecDelegate[1];
//        curLabel = froolLab;
//        
//    }else if ([strType isEqualToString:@"2"]){
//        
//        caixiID =selecDelegate[1];
//        curLabel = yetaiLab;
//        
//    }else {
//        zhiID=selecDelegate[1];
//        curLabel= zhinengLab;
//    }
//    view_3 = [curLabel superview];
//    upImg = [view_3 viewWithTag:500];
//    
//    curLabel.text=selecDelegate[2];
//    [curLabel sizeToFit];
//    [upImg setImage:[UIImage imageNamed:@"down"]];
//    
//    CGRect frame = curLabel.frame;
//    frame.size.height = btnView.frame.size.height;
//    frame.origin.x = [self computLabelXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
//    curLabel.frame = frame;
//    frame = upImg.frame;
//    frame.origin.x = [self computImgXForLabelImg:view_3.frame.size.width imgWidth:upImg.frame.size.width labelWidth:curLabel.frame.size.width padding:4];
//    upImg.frame = frame;
//    
//    [self NetWorkRequest:nil];
//    
//}
//#pragma mark ---创建搜索视图---
//
//
//-(float) computLabelXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
//    return (pWidth - (imgWidth+labelWidth+padding))/2;
//}
//
//-(float) computImgXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
//    return (pWidth - (imgWidth+labelWidth+padding))/2 + labelWidth + padding;
//}
//
//点击头部选择按钮弹出view事件
//-(void) onSelectTypeTap:(UITapGestureRecognizer*) tap{
//    [self.textField1 resignFirstResponder];
//    if (_selectionView !=nil) {
//        [_selectionView removeFromSuperview];
//    }
//    curDealView = [tap view];
//    NSInteger index=[tap view].tag;
//    UIImageView* upImgView = [[tap view] viewWithTag:500];
//    [upImgView setImage:[UIImage imageNamed:@"up"]];
//    
//    _selectionView=[[SelectionBoxView alloc]init];
//    _selectionView.backgroundColor=[UIColor clearColor];
//    _selectionView.frame= CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT);
//    _selectionView.xPoint = CGRectGetMaxY(btnView.frame) ;
//    _selectionView.selectioDelegate=self;
//    switch (index) {
//        case 100:
//            if (ShopFloorID.count>0) {
//                
//                _selectionView.dataArray=[self addquanbu:ShopFloorAry :@"1" :@"全部楼层"];//
//                _selectionView.idArray  =[self addquanbu:ShopFloorID  :@"id" :nil];
//                _selectionView.type     =@"1";//目的是为了返回的时候知道我传过去的是什么类型
//                _selectionView.curSelectId = floorID;
//                [self.view addSubview:_selectionView];
//            }else {
//                [SVProgressHUD showSuccessWithStatus:@"该商场没有此分类"];
//            }
//            
//            break;
//        case 101:
//            if (ShopTypeID.count>0) {
//                _selectionView.dataArray=[self addquanbu:ShopTypeAry :@"1" :@"全部菜系"];
//                _selectionView.idArray  =[self addquanbu:ShopTypeID  :@"id" :nil];
//                _selectionView.type     =@"2";
//                _selectionView.curSelectId = caixiID;
//                [self.view addSubview:_selectionView];
//            }else {
//                [SVProgressHUD showSuccessWithStatus:@"该商场没有此分类"];
//            }
//            break;
//        case 102:
//        {
//            NSArray* zhinengID = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
//            if (zhinengID.count>0) {
//                _selectionView.dataArray=[[NSArray alloc]initWithObjects:@"默认排序",@"人气最高",@"有团购",@"有促销优惠",@"A-Z字母排序",@"有卡券",@"有报名",@"有排队", nil];
//                _selectionView.idArray  =zhinengID;
//                _selectionView.type     =@"3";
//                _selectionView.curSelectId = zhiID;
//                
//                [self.view addSubview:_selectionView];
//            }else {
//                [SVProgressHUD showSuccessWithStatus:@"该商场没有此分类"];
//            }
//            break;
//        }
//            
//        default:
//            break;
//    }
//    
//}
////输入框点击return
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    isend=NO;
//    pageNum=1;
//    if ([Util isNull:self.textField1]) {
//    }else {
//        keyStr=self.textField1.text;
//        [self NetWorkRequest:nil];
//    }
//    
//    [self.textField1 resignFirstResponder];
//    return YES;
//}

//-(NSMutableArray*)addquanbu:(NSMutableArray *)mAry  :(NSString *)str :(NSString*)quanbuStr
//{
//    NSMutableArray *muAry=[[NSMutableArray alloc]init];
//    if ([str isEqualToString:@"1"]) {
//        [muAry addObject:quanbuStr];
//    }else {
//        [muAry addObject:@"0"];
//    }
//    
//    for (int i=0; i<mAry.count; i++) {
//        NSString *str=mAry[i];
//        [muAry addObject:str];
//    }
//    return muAry;
//}

//-(void)cancelSelect{
//    
//    UIImageView* upImgView = [curDealView viewWithTag:500];
//    [upImgView setImage:[UIImage imageNamed:@"down"]];
//}



//-(void)NetWorkRequest2{
//    int zz=[[Global sharedClient].markID intValue];
//    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@"food",@"t",@(zz),@"mall_id",nil];
//    
//    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"] parameters:diction  target:self success:^(NSDictionary *dic){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSLog(@"%@",dic);
//            NSArray * shopFloor    = dic[@"data"][@"ShopFloor"];
//            NSArray * ShopType     = dic[@"data"][@"ShopType"];
//            for (NSDictionary *dic1 in shopFloor) {
//                NSString *nameStr  = [Util isNil:dic1[@"name"]];
//                NSString *idStr    = [Util isNil:dic1[@"id"]];
//                [ShopFloorAry addObject:nameStr];
//                [ShopFloorID  addObject:idStr];
//            }
//            NSLog(@"%@",ShopFloorAry);
//            for (NSDictionary *dic2 in ShopType) {
//                NSString *idStr    = [Util isNil:dic2[@"id"]];
//                NSString *nameStr  = [Util isNil:dic2[@"name"]];
//                [ShopTypeAry addObject:nameStr];
//                [ShopTypeID  addObject:idStr];
//            }
//            
//            [SVProgressHUD dismiss];
//        });
//    }failue:^(NSDictionary *dic){
//        
//    }];
//}

//froolLab            =[[UILabel alloc]init];
//yetaiLab            =[[UILabel alloc]init];
//zhinengLab          =[[UILabel alloc]init];
//
////搜索
//ShopFloorAry    =[[NSMutableArray alloc]init];
//ShopFloorID     =[[NSMutableArray alloc]init];
//ShopTypeAry     =[[NSMutableArray alloc]init];
//ShopTypeID      =[[NSMutableArray alloc]init];
//NSMutableArray          *ShopFloorAry;//楼层名字
//NSMutableArray          *ShopFloorID;//楼层ID
//NSMutableArray          *ShopTypeAry;//菜系名字
//NSMutableArray          *ShopTypeID;//菜系ID
//NSMutableArray          *dataArr;//菜系ID
//UILabel                 *froolLab;
//UILabel                 *yetaiLab;
//UILabel                 *zhinengLab;

@end
