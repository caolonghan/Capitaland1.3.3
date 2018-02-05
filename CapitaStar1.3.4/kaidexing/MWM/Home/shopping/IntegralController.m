//
//  积分 IntegralController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "IntegralController.h"
#import "ImageScrollView.h"
#import "GoViewController.h"
#import "MJRefresh.h"
#import "SelectionBoxView.h"
#import "ShopeListController.h"

@interface IntegralController ()<UIScrollViewDelegate>

@property (strong,nonatomic)UIScrollView        *scrollView_root;
@property (strong,nonatomic)SelectionBoxView    *selectionView;//选择框
@property (strong,nonatomic)NSDictionary        *dataDic;//获取除分类以外的所有数据
@property (strong,nonatomic)NSMutableArray      *shopAry;//商品列表数据
@property (strong,nonatomic)NSDictionary        *cityDic;//按城市
@property (strong,nonatomic)NSDictionary        *shioDic;//按分类
@property (strong,nonatomic)UIView              *jifenView;
@end

@implementation IntegralController
{
    CGFloat         scroll_H;
    CGFloat         jifen_HH;
    CGFloat         selection_H;//保存弹出框的距上距离
    UIScrollView    *scrollView_2;
    UIScrollView    *scrollView_3;
    UIPageControl   *pagecontrol3;
    UILabel         *hhhLab;//小时
    UILabel         *mmmLab;//分钟
    UILabel         *sssLab;//秒
    int secondsCountDown; //倒计时总时长
    NSTimer *countDownTimer;
    NSInteger   pageNum;
    BOOL        isend1;
    
    UILabel     *jifenLab;//积分
    UILabel     *fenleiLab;//分类
    UILabel     *cityLab;//城市
    int          jifen_id;
    int          fenle_id;
    int          city_id;
    UIView       *nilView1;
    BOOL         view_cunzai;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.delegate.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scroll_H=NAV_HEIGHT;
    view_cunzai=NO;
    jifen_id=0;
    fenle_id=0;
    city_id=0;
    self.navigationBarTitleLabel.text=@"积分商城";
    self.dataDic=[[NSDictionary alloc]init];
    self.shopAry=[[NSMutableArray alloc]init];
    self.cityDic=[[NSDictionary alloc]init];
    self.view.backgroundColor=[UIColor redColor];
    self.scrollView_root=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-45)];
    self.scrollView_root.backgroundColor=UIColorFromRGB(0xf4f4f4);
    self.scrollView_root.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*1.01);
    self.scrollView_root.scrollEnabled=YES;
    self.scrollView_root.delegate=self;
    [self.view addSubview:self.scrollView_root];
   
    [self NetWorkRequest];
    [self fenleiNet];
    [self fenlei_2Net];
}

#pragma mark ----NetWorkRequest----
-(void)NetWorkRequest
{
    [HttpClient requestWithMethod:@"GET" path:[Util makeRequestUrl:@"integralmall" tp:@"getindex"] parameters:nil  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            self.dataDic=dic;
             [self initscrollImgView];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}



#pragma mark -------initView------
-(void)initscrollImgView
{
    NSArray *dataArynvc=self.dataDic[@"data"][@"navlist"];
    NSMutableArray      *imgAry_1=[[NSMutableArray alloc]init];
    NSMutableArray      *urlAry_1=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in dataArynvc) {
//        NSString  *img_1=[NSString stringWithFormat:@"%@%@",HTTP_Img,[Util isNil:dic[@"icon_img"]]];
        NSString  *url_1=[Util isNil:dic[@"navigation_url"]];
//        [imgAry_1 addObject:img_1];
        [urlAry_1 addObject:url_1];
    }
  
    
    
    ImageScrollView *lunboView=[[ImageScrollView alloc]initWithFrame:CGRectMake(0, scroll_H, WIN_WIDTH,M_WIDTH(152))];
    lunboView.pics=imgAry_1;
    lunboView.pageColor=[UIColor whiteColor];
    lunboView.pageSelColor=[UIColor grayColor];
    [lunboView returnIndex:^(NSInteger index){
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = urlAry_1[index];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        NSLog(@"点击了第%zi张", index);
        
    }];
    [lunboView reloadView];
    [self.scrollView_root addSubview:lunboView];
    
    scroll_H=scroll_H+lunboView.frame.size.height;
    [self initBtnView];
    
}

//轮播图下面的按钮
-(void)initBtnView
{
    scroll_H=scroll_H+M_WIDTH(10);
    NSArray *dataArynvc=self.dataDic[@"data"][@"resultbannerList"];
    NSMutableArray      *imgAry_2     = [[NSMutableArray alloc]init];
    NSMutableArray      *titleAry_2   = [[NSMutableArray alloc]init];
    for (NSDictionary *dic_2 in dataArynvc) {
        NSString  *img_2      = [Util isNil:dic_2[@"img_url"]];
        NSString  *titleStr_2 = [Util isNil:dic_2[@"title"]];
        [imgAry_2     addObject: img_2];
        [titleAry_2   addObject: titleStr_2];
    }
    NSInteger  itme =titleAry_2.count;
    UIView *rootView2=[[UIView alloc]initWithFrame:CGRectMake(0, scroll_H, WIN_WIDTH,M_WIDTH(101))];
    rootView2.backgroundColor=[UIColor whiteColor];
    
    scrollView_2=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(101))];
    scrollView_2.contentSize=CGSizeMake(itme*M_WIDTH(93),M_WIDTH(101));
    scrollView_2.scrollEnabled=YES;
    [scrollView_2 setShowsHorizontalScrollIndicator:NO];
    scrollView_2.delegate=self;
    
    for (int i=0; i<itme; i++) {
        UIView *rView=[[UIView alloc]initWithFrame:CGRectMake(i*M_WIDTH(91.5), M_WIDTH(13),M_WIDTH(87), rootView2.frame.size.height-M_WIDTH(13))];
        UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(15), 0, M_WIDTH(58), M_WIDTH(58))];
        iconImg.contentMode=UIViewContentModeScaleAspectFill;
        iconImg.clipsToBounds=YES;
        iconImg.layer.masksToBounds=YES;
        iconImg.layer.cornerRadius=iconImg.frame.size.height/2;
        [iconImg setImageWithURL:[NSURL URLWithString:imgAry_2[i]]];
        
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImg.frame)+M_WIDTH(7),rView.frame.size.width, M_WIDTH(17))];
        titleLab.textAlignment=NSTextAlignmentCenter;
        titleLab.text=titleAry_2[i];
        titleLab.font=INFO_FONT;
    
        UIButton *iconbtn=[[UIButton alloc]initWithFrame:rView.bounds];
        iconbtn.tag=i;
        [iconbtn addTarget:self action:@selector(btn_5_Touch:) forControlEvents:UIControlEventTouchUpInside];
        [rView addSubview:iconImg];
        [rView addSubview:titleLab];
        [rView addSubview:iconbtn];
        [scrollView_2 addSubview:rView];
    }
    
    [rootView2 addSubview:scrollView_2];
    [self.scrollView_root addSubview:rootView2];
    scroll_H=scroll_H+M_WIDTH(101+9);
    [self initrecommendView];
}

//新品推荐
-(void)initrecommendView
{
    NSArray *dataArynvc=self.dataDic[@"data"][@"resultnewgoodsList"];
    NSMutableArray      *imgAry         = [[NSMutableArray alloc]init];
    NSMutableArray      *titleAry       = [[NSMutableArray alloc]init];
    NSMutableArray      *integralAry    = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in dataArynvc) {
        NSString  *img      = [NSString stringWithFormat:@"%@",[Util isNil:dic[@"img_url"]]];
        NSString  *titleStr = [Util isNil:dic[@"title"]];
        NSString  *integral = [Util isNil:dic[@"integral"]];
        [imgAry      addObject: img];
        [titleAry    addObject: titleStr];
        [integralAry addObject: integral];
    }
    
    UIView *rootView_4=[[UIView alloc]initWithFrame:CGRectMake(0, scroll_H, WIN_WIDTH, M_WIDTH(155))];
    rootView_4.backgroundColor=[UIColor whiteColor];
    //新品推荐文字
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0, M_WIDTH(70),M_WIDTH(38))];
    titleLab.text=@"新品推荐";
    titleLab.font=COOL_FONT;
    titleLab.textColor=UIColorFromRGB(0x2dcc6b);
    titleLab.textAlignment=NSTextAlignmentLeft;
    
    //查看全部
    UILabel *quanbuLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(80),0,M_WIDTH(60),M_WIDTH(38))];
    quanbuLab.text=@"查看全部";
    quanbuLab.textAlignment=NSTextAlignmentRight;
    quanbuLab.font=DESC_FONT;
    
    UIButton *quanbuBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(80),0,M_WIDTH(60),M_WIDTH(38))];
    [quanbuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [quanbuBtn addTarget:self action:@selector(quanbuTouch:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(quanbuLab.frame)+M_WIDTH(4), M_WIDTH(12),M_WIDTH(8),M_WIDTH(13))];
    [rightImg setImage:[UIImage imageNamed:@"right_2"]];
    
    [rootView_4 addSubview:titleLab];
    [rootView_4 addSubview:rightImg];
    [rootView_4 addSubview:quanbuLab];
    [rootView_4 addSubview:quanbuBtn];
    
    CGFloat view_W=2*(WIN_WIDTH/7);
    
    
    scrollView_3=[[UIScrollView alloc]initWithFrame:CGRectMake(0,M_WIDTH(35), WIN_WIDTH, M_WIDTH(105))];
    scrollView_3.contentSize=CGSizeMake((titleAry.count)*view_W, M_WIDTH(105));
    scrollView_3.scrollEnabled=YES;
    [scrollView_3 setShowsHorizontalScrollIndicator:NO];
    scrollView_3.delegate=self;
    
    for (int i=0; i<titleAry.count; i++) {

            UIView *itmeView=[[UIView alloc]initWithFrame:CGRectMake(i*view_W, 0,view_W, M_WIDTH(105))];
            itmeView.layer.borderColor=[COLOR_LINE CGColor];
            itmeView.layer.borderWidth=0.5;
            //商品名字
            UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(3), M_WIDTH(5),view_W-M_WIDTH(6),M_WIDTH(15))];
            nameLab.text=[NSString stringWithFormat:@"%@",[Util isNil:titleAry[i]]];
            nameLab.textAlignment=NSTextAlignmentCenter;
            nameLab.font=INFO_FONT;
            
            //商品积分
            UILabel *jifenLab1=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(nameLab.frame)+M_WIDTH(2.5), (WIN_WIDTH-40)/3,M_WIDTH(12))];
            int jifenint=[integralAry[i]intValue];
            jifenLab1.text=[NSString stringWithFormat:@"%d%@",jifenint,@"积分"];
            jifenLab1.textColor=[UIColor redColor];
            jifenLab1.textAlignment=NSTextAlignmentCenter;
            jifenLab1.font=[UIFont systemFontOfSize:10];
            
            //商品图片
            UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(view_W/2-M_WIDTH(30), CGRectGetMaxY(jifenLab1.frame)+7, M_WIDTH(60), M_WIDTH(60))];
            iconImg.contentMode=UIViewContentModeScaleAspectFit;
            [iconImg setImageWithURL:[NSURL URLWithString:imgAry[i]]];
        
            UIButton *itmeBtn=[[UIButton alloc]initWithFrame:itmeView.bounds];
        itmeBtn.tag=i;
            [itmeBtn addTarget:self action:@selector(itmeTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [itmeView addSubview:nameLab];
            [itmeView addSubview:jifenLab1];
            [itmeView addSubview:iconImg];
            [itmeView addSubview:itmeBtn];
            [scrollView_3 addSubview:itmeView];
    }
    [rootView_4 addSubview:scrollView_3];
    
    [self.scrollView_root addSubview:rootView_4];
    scroll_H=scroll_H+M_WIDTH(169);
    [self initshoppingHeadView];
}

//有优惠的商品头部选择视图
-(void)initshoppingHeadView
{
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, scroll_H, WIN_WIDTH, M_WIDTH(39))];
    headView.backgroundColor=[UIColor whiteColor];
    
    NSArray *titleAry=[[NSArray alloc]initWithObjects:@"按积分",@"按分类",@"按城市", nil];
    for (int i=0; i<3; i++) {
        UIView *itemView=[[UIView alloc]initWithFrame:CGRectMake(i*(WIN_WIDTH)/3, 0, WIN_WIDTH/3, M_WIDTH(39))];
        
        if (i==0) {
            jifenLab=[[UILabel alloc]init];
            [self initlab:jifenLab];
            jifenLab.text  =titleAry[i];
            [itemView addSubview:jifenLab];
        }else if (i==1){
            fenleiLab=[[UILabel alloc]init];
            [self initlab:fenleiLab];
            fenleiLab.text =titleAry[i];
            [itemView addSubview:fenleiLab];
        }else {
            cityLab=[[UILabel alloc]init];
            [self initlab:cityLab];
            cityLab.text   =titleAry[i];
            [itemView addSubview:cityLab];
        }
        UIImageView *downImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/3 -M_WIDTH(30), M_WIDTH(17), M_WIDTH(12), M_WIDTH(7))];
        [downImg setImage:[UIImage imageNamed:@"down"]];

        UIButton *itemBtn=[[UIButton alloc]initWithFrame:itemView.bounds];
        itemBtn.tag=i+100;
        [itemBtn addTarget:self action:@selector(leibieTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemView addSubview:downImg];
        [itemView addSubview:itemBtn];
        [headView addSubview:itemView];
    }
    
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(38), WIN_WIDTH, 1)];
    lineview.backgroundColor=COLOR_LINE;
    [headView addSubview:lineview];
    
    [self.scrollView_root addSubview:headView];
    selection_H=scroll_H+M_WIDTH(39);
    
    [self shopNet];
}

//有优惠的商品
-(void)initDiscountView
{
    self.jifenView=[[UIView alloc]init];
    NSInteger  count1=ceilf(_shopAry.count/2.0);
    self.jifenView.frame=CGRectMake(0,selection_H,WIN_WIDTH,M_WIDTH(251)*count1);
    
    for (int i=0; i<_shopAry.count; i++) {
        int itme_y=i/2;
        int itme_x=i%2;
        NSDictionary  *dic = _shopAry[i];
        UIView *itemView=[[UIView alloc]initWithFrame:CGRectMake(itme_x*(WIN_WIDTH/2+M_WIDTH(1)), itme_y*M_WIDTH(251), WIN_WIDTH/2 -M_WIDTH(1), M_WIDTH(249))];
        itemView.backgroundColor=[UIColor whiteColor];
        
        //商品大图
        UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(9.5), M_WIDTH(10), M_WIDTH(140), M_WIDTH(140))];
        [iconImg setUserInteractionEnabled:YES];
        iconImg.contentMode=UIViewContentModeScaleAspectFit;
        [iconImg setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"img_url"]]]];
        
        //图片上面的快递，自提
        int freight_type=[[Util isNil:dic[@"freight_type"]]intValue];
        if (freight_type==1) {
            UILabel *kuaidiLab=[[UILabel alloc]initWithFrame:CGRectMake(iconImg.frame.size.width-M_WIDTH(25), CGRectGetMaxY(iconImg.frame)-M_WIDTH(21), M_WIDTH(25), M_WIDTH(13))];
            kuaidiLab.text=@"快递";
            [self initred_layerLab:kuaidiLab];
            [iconImg addSubview:kuaidiLab];
        }else {
            
        }
        
        //底部带有颜色的view
        UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(160), WIN_WIDTH/2-M_WIDTH(1), M_WIDTH(89))];
        buttomView.backgroundColor=UIColorFromRGB(0xf7f7f7);
        
        //商品名字
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(12), WIN_WIDTH/2 -M_WIDTH(21), M_WIDTH(38))];
        nameLab.textAlignment=NSTextAlignmentLeft;
        nameLab.numberOfLines=2;
        nameLab.text=[Util isNil:dic[@"title"]];
        nameLab.font=COMMON_FONT;
        CGRect rect20=[nameLab.text boundingRectWithSize:CGSizeMake(WIN_WIDTH/2 -M_WIDTH(21),M_WIDTH(36)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:nameLab.font} context:nil];
        nameLab.frame=CGRectMake(nameLab.frame.origin.x, nameLab.frame.origin.y, rect20.size.width, rect20.size.height);
        //原价
        UILabel *yuanjiaLab1=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(50),M_WIDTH(75), 12)];
        yuanjiaLab1.text=@"原价 ：";
        yuanjiaLab1.textAlignment=NSTextAlignmentLeft;
        yuanjiaLab1.font=INFO_FONT;
        [yuanjiaLab1 sizeToFit];
        
        UILabel *yuanjiaLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yuanjiaLab1.frame),M_WIDTH(50), M_WIDTH(50), 12)];
        int yuanjiaint = [[Util isNil:dic[@"old_integral"]]intValue];
        yuanjiaLab.text=[NSString stringWithFormat:@"%d%@",yuanjiaint,@"积分"]; //@"原价 ：850积分";
        yuanjiaLab.textAlignment=NSTextAlignmentLeft;
        yuanjiaLab.font=INFO_FONT;
        [yuanjiaLab sizeToFit];
        //在原价的价格上画一条线
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,yuanjiaLab.frame.size.height/2,yuanjiaLab.frame.size.width,1)];
        lineView.backgroundColor=[UIColor blackColor];

        //积分数量
        UILabel *jifenLab1=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(yuanjiaLab.frame),M_WIDTH(120), M_WIDTH(20))];
        jifenLab1.textAlignment=NSTextAlignmentLeft;
        int jifenint = [[Util isNil:dic[@"integral"]]intValue];
        jifenLab1.text=[NSString stringWithFormat:@"%d%@",jifenint,@"积分"];
        jifenLab1.font=COMMON_FONT;
        jifenLab1.textColor=[UIColor redColor];

        UIButton *btn=[[UIButton alloc]initWithFrame:itemView.bounds];
        btn.tag=itme_y*2+itme_x;
        [btn addTarget:self action:@selector(shangpinTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemView addSubview:iconImg];
        [buttomView addSubview:nameLab];
        [buttomView addSubview:yuanjiaLab1];
        [buttomView addSubview:yuanjiaLab];
        [yuanjiaLab addSubview:lineView];
        [buttomView addSubview:jifenLab1];
        [itemView addSubview:buttomView];
        [itemView addSubview:btn];
        [self.jifenView addSubview:itemView];
        [self.scrollView_root addSubview:self.jifenView];
        self.scrollView_root.contentSize=CGSizeMake(WIN_WIDTH,selection_H +M_WIDTH(251)*(itme_y+1));
    }
}
-(void)shangpinTouch:(UIButton*)sender
{
    GoViewController *vc=[[GoViewController alloc]init];
    NSLog(@"%@",_shopAry);
    NSDictionary *dic=_shopAry[sender.tag];
    vc.path=[Util isNil:dic[@"integral_detail"]];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


#pragma mark  -----商品列表接口----
//获取城市列表
-(void)fenleiNet{
 
    [HttpClient requestWithMethod:@"GET" path:[Util makeRequestUrl:@"integralmall" tp:@"getcitymalls"] parameters:nil  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            self.cityDic=dic;
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}

-(void)fenlei_2Net
{
    
    [HttpClient requestWithMethod:@"GET" path:[Util makeRequestUrl:@"integralmall" tp:@"getsmalltype"] parameters:nil  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            self.shioDic=dic;
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}

//积分商品列表
-(void)shopNet
{
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNum++;
        
        [self shoploadnet];
    }];
    self.scrollView_root.footer = footer;
    self.scrollView_root.footer.automaticallyHidden = YES;
    [self.scrollView_root.footer endRefreshing];
}

-(void)shoploadnet
{
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"integral_goods_list"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@(0),@"sort",@(0),@"type",@(fenle_id),@"small_type",@(jifen_id),@"s_type",@(city_id),@"mall_id",@(pageNum),@"page",@"8",@"pageSize",@"",@"Key",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断是否有数据
            if (isend1==NO) {
                NSString *isendStr=dic[@"data"][@"isend"];
                //赋值，为了判断下次是否有数据
                if ([isendStr isEqualToString:@"false"]) {
                    isend1=NO;
                }else{
                    isend1=YES;
                    [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
                }
                //成功获取所有数据
                _shopAry=dic[@"data"][@"integralgoodslist"];
                if (_shopAry.count>0) {
                   
                    [self initDiscountView];
                    
                }else {
                    [self nilview];
                    [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
                    self.scrollView_root.footer.hidden=YES;
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
                self.scrollView_root.footer.hidden=YES;
                [self.scrollView_root.footer endRefreshing];
            }
            [self.scrollView_root.footer endRefreshing];
        
        });
    }failue:^(NSDictionary *dic){
        self.scrollView_root.footer.hidden=YES;
        [self.scrollView_root.footer endRefreshing];
    }];
}


-(void)nilview
{
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, selection_H, WIN_WIDTH,M_WIDTH(200))];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.scrollView_root addSubview:nilView1];
    self.scrollView_root.contentSize=CGSizeMake(WIN_WIDTH, selection_H + M_WIDTH(200));
}


//轮播图下面按钮的点击事件
-(void)btn_5_Touch:(UIButton*)sender
{
    NSArray *dataArynvc=self.dataDic[@"data"][@"resultbannerList"];
    NSDictionary *link_url=dataArynvc[sender.tag];
    NSString *link=[link_url objectForKey:@"link_url"];
    GoViewController *govc=[[GoViewController alloc]init];
    govc.path=[Util makeUIImageViewUrlWithString:link];;
    [self.delegate.navigationController pushViewController:govc animated:YES];
}

//新品推荐里面的查看全部
-(void)quanbuTouch:(UIButton*)sender
{
    NSLog(@"新品推荐里面的查看全部");
    ShopeListController *svc=[[ShopeListController alloc]init];
    [self.delegate.navigationController pushViewController:svc animated:YES];
}
//新品推荐里面某一个商品的点击事件
-(void)itmeTouch:(UIButton*)sender
{
    NSArray *dataArynvc=self.dataDic[@"data"][@"resultnewgoodsList"];
    NSDictionary *dic=dataArynvc[sender.tag];
    NSString  *urlstr = [NSString stringWithFormat:@"%@",[Util isNil:dic[@"link_url"]]];
    GoViewController *gvc=[[GoViewController alloc]init];
    gvc.path=urlstr;
    [self.delegate.navigationController pushViewController:gvc animated:YES];
}

//按积分 类别 城市 选择事件
-(void)leibieTouch:(UIButton*)sender
{
    if (view_cunzai==YES) {
        [_selectionView removeFromSuperview];
        NSInteger  scroll_count=ceilf(_shopAry.count/2.0);
        if (scroll_count==0) {
            self.scrollView_root.contentSize=CGSizeMake(WIN_WIDTH, selection_H+M_WIDTH(300));
        }else{
            self.scrollView_root.contentSize=CGSizeMake(WIN_WIDTH, selection_H+scroll_count*M_WIDTH(251));
        }
        view_cunzai=NO;
        
    }else{
        view_cunzai=YES;
        NSInteger index=sender.tag-100;
        NSLog(@"%ld",(long)index);
        //弹出view的高度需要计算
        _selectionView=[[SelectionBoxView alloc]initWithFrame:CGRectMake(0, selection_H, WIN_WIDTH, M_WIDTH(300))];
        _selectionView.backgroundColor=[UIColor whiteColor];
        _selectionView.selectioDelegate=self;
        _selectionView.type=[NSString stringWithFormat:@"%ld",index];
        if (index==0) {
            NSArray *array =[[NSArray alloc]initWithObjects:@"默认",@"<500",@"500-1000",@"1000-5000",@">5000",nil];
            NSArray *iddary=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",nil];
            _selectionView.dataArray=array;
            _selectionView.idArray=iddary;
            _selectionView.curSelectId=[NSString stringWithFormat:@"%d",jifen_id];
        }else if(index==1){
            NSArray *array=self.shioDic[@"data"];
            NSMutableArray *arr1 =[[NSMutableArray alloc]init];
            NSMutableArray *idary=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                NSString *str1=[Util isNil:dic[@"type_name"]];
                NSString *str2=[Util isNil:dic[@"id"]];
                [arr1  addObject:str1];
                [idary addObject:str2];
            }
            _selectionView.dataArray=arr1;
            _selectionView.idArray  =idary;;
            _selectionView.curSelectId =[NSString stringWithFormat:@"%d",fenle_id];

        }else{
            NSArray *array=self.cityDic[@"data"];
            NSMutableArray *arr1 =[[NSMutableArray alloc]init];
            NSMutableArray *idary=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in array) {
                NSString *str1=[Util isNil:dic[@"title"]];
                NSString *str2=[Util isNil:dic[@"id"]];
                [arr1  addObject:str1];
                [idary addObject:str2];
            }
            _selectionView.dataArray=arr1;
            _selectionView.idArray  =idary;
            _selectionView.curSelectId =[NSString stringWithFormat:@"%d",city_id];
        }
    
        if (_shopAry.count<2) {
            NSInteger  view_count=ceilf(_selectionView.dataArray.count/2.0);
            self.scrollView_root.contentSize=CGSizeMake(WIN_WIDTH, selection_H + (view_count*40)+M_WIDTH(50));
        }
        [self.scrollView_root addSubview:_selectionView];
    }
}


//弹出框的返回代理事件
-(void)setdelegate:(id)selecDelegate
{
    [nilView1 removeFromSuperview];
    [self.jifenView removeFromSuperview];
    self.scrollView_root.footer.hidden=NO;
  
    pageNum=1;
    isend1=NO;
    NSArray *array=selecDelegate;
    int typeint=[array[0]intValue];
    if (typeint==0) {
        
        jifenLab.text=array[2];
        jifen_id=[array[1]intValue];
        
    }else if(typeint==1){
        
        fenleiLab.text=array[2];
        fenle_id=[array[1]intValue];
        
    }else if(typeint==2){
        
        cityLab.text=array[2];
        city_id=[array[1]intValue];
        
    }
    
    [self shoploadnet];
    
}

//分类选择lab 通用属性加工
-(void)initlab:(UILabel*)lab
{
    lab.frame=CGRectMake(0, 0, WIN_WIDTH/3 -M_WIDTH(37), M_WIDTH(39));
    lab.textAlignment=NSTextAlignmentRight;
    lab.textColor=[UIColor blackColor];
    lab.font=COMMON_FONT;
}
// 快递 字体 lab 通用属性
-(void)initred_layerLab:(UILabel*)lab
{
    lab.textAlignment=NSTextAlignmentCenter;
    lab.layer.masksToBounds=YES;
    lab.layer.cornerRadius=3;
    lab.textColor=[UIColor redColor];
    lab.font=INFO_FONT;
    lab.backgroundColor=[UIColor whiteColor];
    lab.layer.borderColor =[[UIColor redColor]CGColor];
    lab.layer.borderWidth =1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    int indexz  =scrollView_3.contentOffset.x/WIN_WIDTH;
    [pagecontrol3 setCurrentPage:indexz];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
