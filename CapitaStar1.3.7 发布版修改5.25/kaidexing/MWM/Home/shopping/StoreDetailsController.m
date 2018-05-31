//
//  StoreDetailsController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "StoreDetailsController.h"
#import "ImageScrollView.h"
#import "SearchStoreController.h"
#import "SearchDetailsController.h"
#import "ScanViewController.h"
#import "GoViewController.h"
#import "MJRefresh.h"

//背景三个颜色
#define color_1 UIColorFromRGB(0xffd655)
#define color_2 UIColorFromRGB(0x52d0cc)
#define color_3 UIColorFromRGB(0xf65669)


//文字三个颜色
#define color_4 UIColorFromRGB(0xffc533)
#define color_5 UIColorFromRGB(0x32b6b3)
#define color_6 UIColorFromRGB(0xe44a57)



@interface StoreDetailsController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (strong,nonatomic)UIView          *headRootView;//头部底层View
@property (strong,nonatomic)UIView          *nvcView;//模仿导航栏的view
@property (strong,nonatomic)UIScrollView    *scrollView;//底层的View
@property (strong,nonatomic)UIScrollView    *scrollView_2;//陈列功能
@property (strong,nonatomic)NSDictionary    *dataDic;//拿到的所有数据

@end

@implementation StoreDetailsController
{
     UIPageControl   *pagecontrol1;
     UIView          *view1;        //轮播图
     UIView          *rootview0;    //功能陈列物品
     UIView          *rootView2;    //陈列物品下面的3个图片
     UIView          *rootView3;    //积分兑换view
     UIView          *rootView4;    //热门品牌
     UIView          *rootView5;    //
     UIView          *rootView6;    //
    
     NSMutableArray  *jifenId_Ary;//判断积分需要ID
     NSMutableArray  *remenId_Ary; //判断热门品牌的点击事件需要ID
     NSMutableArray  *remen_Web_Ary;//热门品牌的链接
     NSMutableArray  *huiyuanId_Ary; //判断会员活动的ID
     NSMutableArray  *huiyuan_Web_Ary;//会员活动的链接
     NSMutableArray  *img_ID_Ary;//照片墙id
     NSMutableArray  *img_Web_Ary;//照片墙链接
     NSMutableArray  *lunbo_Web_Ary;//轮播图链接
     NSArray         *youLikeAry;//猜你喜欢数据
     NSMutableArray         *youlike_webAry;//猜你喜欢的链接
    
    NSDictionary *ceshiDic;//测试保存id
    NSInteger   pageNum;//猜你喜欢的页数
    BOOL         isend1;//判断是否还有猜你喜欢的数据(no代表还有数据，yes代表没有数据)
    
}


-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    [self.delegate.navigationController setNavigationBarHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initdic1];
    
    youLikeAry=[[NSArray alloc]init];
    self.dataDic=[[NSDictionary alloc]init];
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-45)];
    self.scrollView.delegate=self;
    self.scrollView.scrollEnabled=YES;
    self.scrollView.contentSize=CGSizeMake(WIN_WIDTH,1042);
    pageNum=0;
    isend1=NO;
    [self.view addSubview:self.scrollView];
    [self NetWorkRequest];
}


#pragma mark ---请求网络---
//进入界面获取的数据

-(void)NetWorkRequest
{

    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    int zz=4;
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadindex"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dataDic=dic[@"data"];
        
            NSLog(@"%@",self.dataDic);
            
            [self initHeadRootView];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
    }];
   
}

//加关注的请求数据
-(void)requestnetwork
{
   
    NSString *mallid=[RSA encryptString:@"123456" publicKey:PublicKey];

    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"attention"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:mallid,@"mall_id",@"1",@"coll_id",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dataDic=dic[@"data"];
            
            [self initHeadRootView];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
    }];
    
    
    
}



#pragma mark ----initView----

-(void)initHeadRootView
{
    //头部最底层的View
    self.headRootView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 122)];
    //底层的一个背景图片
    UIImageView *backImg=[[UIImageView alloc]initWithFrame:self.headRootView.bounds];
    [backImg setImage:[UIImage imageNamed:@"img_01"]];
    [backImg setUserInteractionEnabled:YES];
    [self.headRootView addSubview:backImg];
    //在背景图片上加一个半透明的View
    UIView *alphaView=[[UIView alloc]initWithFrame:self.headRootView.bounds];
    alphaView.backgroundColor=[UIColor blackColor];
    alphaView.alpha=0.5;
    [self.headRootView addSubview:alphaView];
    
    self.nvcView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, WIN_WIDTH, 44)];
    self.nvcView.backgroundColor=[UIColor clearColor];
    
    //模仿系统返回按钮图片
    UIImageView *fanhuiImg=[[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 12, 18)];
    [fanhuiImg setImage:[UIImage imageNamed:@"black36"]];
    [fanhuiImg setUserInteractionEnabled:YES];
    [self.nvcView addSubview:fanhuiImg];
    
    //在模仿系统返回按钮图片加上Btn
    UIButton *fanhuiBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 50, 44)];
    [fanhuiBtn addTarget:self action:@selector(fanhuiTouch) forControlEvents:UIControlEventTouchUpInside];
    
    //搜索框底色view
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(52, 7, WIN_WIDTH-104, 32)];
    colorView.backgroundColor=[UIColor blackColor];
    colorView.alpha=0.5;
    colorView.layer.masksToBounds=YES;
    colorView.layer.cornerRadius=5;
    [self.nvcView addSubview:colorView];
 
    //搜索框上面的放大镜
    UIImageView *sousuoImg=[[UIImageView alloc]initWithFrame:CGRectMake(58, 15, 14, 14)];
    [sousuoImg setImage:[UIImage imageNamed:@"search_Icon"]];
    [self.nvcView addSubview:sousuoImg];
    
    //搜索框上面的输入框
    UITextField *textF=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sousuoImg.frame)+6, 13, colorView.frame.size.width-26, 20)];
    textF.textColor=[UIColor whiteColor];
    textF.font=DESC_FONT;
    
    UIButton *sousuobtn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sousuoImg.frame)+6, 13, colorView.frame.size.width-26, 20)];
    [sousuobtn addTarget:self action:@selector(sousuoTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nvcView addSubview:textF];
    [self.nvcView addSubview:sousuobtn];
    [self.headRootView addSubview:self.nvcView];
    [self.headRootView addSubview:fanhuiBtn];
    
    //扫描图片
    UIImageView *img_img=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-39,11,24,24)];
    [img_img setImage:[UIImage imageNamed:@"QR_code"]];
    [self.nvcView addSubview:img_img];
    
    UIButton *img_Btn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-47,5,38,35)];
    [img_Btn addTarget:self action:@selector(img_BtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.nvcView addSubview:img_Btn];
    
    
    
    //广场名字
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(19, 75, 200, 16)];
    nameLab.text=@"虹口龙之梦购物广场";
    nameLab.font=COMMON_FONT;
    nameLab.textColor=[UIColor whiteColor];
    [self.headRootView addSubview:nameLab];
    
    //广场粉丝数
    UILabel *numLab=[[UILabel alloc]initWithFrame:CGRectMake(19,CGRectGetMaxY(nameLab.frame)+2, 100, 10)];
    numLab.textColor=[UIColor whiteColor];
    numLab.text=@"482450粉丝";
    numLab.font=INFO_FONT;
    [self.headRootView addSubview:numLab];
    
    //签到按钮下面的view
    UIView *qiandaoView=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH-93, 75, 29, 29)];
    qiandaoView.backgroundColor=[UIColor whiteColor];
    qiandaoView.alpha=0.7;
    qiandaoView.layer.masksToBounds=YES;
    qiandaoView.layer.cornerRadius=14.5;
    
    
    
    //签到图片
    UIImageView *qiandaoImg=[[UIImageView alloc]initWithFrame:CGRectMake(5.5,4.5, 18, 20)];
    [qiandaoImg setContentMode:UIViewContentModeScaleAspectFit];
    [qiandaoImg setImage:[UIImage imageNamed:@"qiandao"]];
    
    //关注按钮
    UIButton *qiandaoBtn=[[UIButton alloc]initWithFrame:qiandaoView.bounds];
    [qiandaoBtn addTarget:self action:@selector(qiandaoTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [qiandaoView addSubview:qiandaoImg];
    [qiandaoView addSubview:qiandaoBtn];
    [self.headRootView addSubview:qiandaoView];
    
    //关注按钮下面的view
    UIView *guanzhuView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(qiandaoView.frame)+14, 75, 29, 29)];
    guanzhuView.backgroundColor=[UIColor whiteColor];
    guanzhuView.alpha=0.7;
    guanzhuView.layer.masksToBounds=YES;
    guanzhuView.layer.cornerRadius=14.5;
    
    //关注图片
    UIImageView *guanzhuImg=[[UIImageView alloc]initWithFrame:CGRectMake(5.5,4.5, 18, 20)];
    [guanzhuImg setContentMode:UIViewContentModeScaleAspectFit];
    [guanzhuImg setImage:[UIImage imageNamed:@"guanzhu"]];
    
    //关注按钮
    UIButton *guanzhuBtn=[[UIButton alloc]initWithFrame:guanzhuView.bounds];
    [guanzhuBtn addTarget:self action:@selector(guanzhuTouch:) forControlEvents:UIControlEventTouchUpInside];
   
    [guanzhuView addSubview:guanzhuImg];
    [guanzhuView addSubview:guanzhuBtn];
    
    [self.headRootView addSubview:guanzhuView];
    
    [self.scrollView addSubview:self.headRootView];
    [self initlunboView];
}

//轮播图
-(void)initlunboView
{
    
    NSArray *array=self.dataDic[@"top_adv"][@"count"];
    NSMutableArray *img_urlArray    =[[NSMutableArray alloc]init];
    lunbo_Web_Ary                   =[[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        NSString  *img_urlStr   = dic[@"img_url"];
        NSString  *web_urlStr   = dic[@"web_url"];
        
        [img_urlArray   addObject  : img_urlStr];
        [lunbo_Web_Ary  addObject  : web_urlStr];
    }

    view1=[[UIView alloc]initWithFrame:CGRectMake(0, 127, WIN_WIDTH, 122)];
    ImageScrollView *lunboView=[[ImageScrollView alloc]initWithFrame:view1.bounds];
    lunboView.pics=img_urlArray;
    lunboView.backgroundColor=[UIColor redColor];
    lunboView.pageColor=[UIColor whiteColor];
    lunboView.pageSelColor=[UIColor whiteColor];
    [lunboView returnIndex:^(NSInteger index){
        
        NSLog(@"点击了第%zi张", index);
        
    }];
    [lunboView reloadView];
    [view1 addSubview:lunboView];
    [self.scrollView addSubview:view1];
    [self initchenlieView];
    
    
}


//功能陈列
-(void)initchenlieView
{
    
    rootview0=[[UIView alloc]initWithFrame:CGRectMake(6, 254, WIN_WIDTH-12, 160)];
    rootview0.backgroundColor=[UIColor whiteColor];
    
    self.scrollView_2=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, WIN_WIDTH-12,160)];
    self.scrollView_2.scrollEnabled=YES;
    [self.scrollView_2 setPagingEnabled:YES];
    [self.scrollView_2 setShowsHorizontalScrollIndicator:NO];
    self.scrollView_2.delegate=self;
    self.scrollView_2.backgroundColor=UIColorFromRGB(0xffffff);
    NSArray *array=self.dataDic[@"menu_class"][@"count"];
    NSInteger        cout=array.count;
    NSMutableArray   *idAry     = [[NSMutableArray alloc]init];
    NSMutableArray   *titleAry  = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        
//        int         idint       = [dic[@"id"]intValue]+1;
        NSString    *idStr      = [NSString stringWithFormat:@"%@",dic[@"id"]];
        NSString    *titleStr   = [NSString stringWithFormat:@"%@",dic[@"title"]];
        [idAry    addObject:idStr];
        [titleAry addObject:titleStr];
    }
    int x;
    if (array.count>16) {
        x=3;
    }else if (array.count>8){
        x=2;
    }else if (array.count>0){
        x=1;
    }
    
    self.scrollView_2.contentSize=CGSizeMake((WIN_WIDTH-12)*x,160);
    
    for (int z=0; z<x; z++) {
        UIView *buttomView=[[UIView alloc]initWithFrame:CGRectMake((WIN_WIDTH-12)*z, 0, WIN_WIDTH, 160)];
        
        for (int y=0; y<2; y++) {
            for (int x=0; x<4; x++) {
                if (cout>0) {
                    cout=cout-1;
                    UIView *kuaiview=[[UIView alloc]initWithFrame:CGRectMake(x*(WIN_WIDTH-12)/4, 19+(y*65),(WIN_WIDTH-12)/4,46)];
                    
                    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH-12)/8 -11, 0,22,22)];
                    [img setImage:[UIImage imageNamed:idAry[array.count-cout-1]]];
                    
                    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+9,(WIN_WIDTH-12)/4, 16)];
                    lab.text=titleAry[array.count-cout-1];
                    lab.font=DESC_FONT;
                    lab.textAlignment=NSTextAlignmentCenter;
                    UIButton *btn=[[UIButton alloc]initWithFrame:kuaiview.bounds];
                    btn.tag=[idAry[array.count-cout-1] intValue];
                    [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [kuaiview   addSubview:img];
                    [kuaiview   addSubview:lab];
                    [kuaiview   addSubview:btn];
                    [buttomView addSubview:kuaiview];

                }else{
                    break;
                }
            }
            
        }
        [self.scrollView_2 addSubview:buttomView];
    }
    pagecontrol1=[[UIPageControl alloc]initWithFrame:CGRectMake((WIN_WIDTH-12)/2-10, 135, 20, 20)];
    pagecontrol1.currentPage=0;//当前显示的页数
    pagecontrol1.numberOfPages=x;//总得页数
    [pagecontrol1 setBackgroundColor:[UIColor clearColor]];
    pagecontrol1.pageIndicatorTintColor=UIColorFromRGB(0xe5e5e5);
    pagecontrol1.currentPageIndicatorTintColor=UIColorFromRGB(0x979797);
    
    [rootview0 addSubview:self.scrollView_2];
    [rootview0 addSubview:pagecontrol1];
    [self.scrollView addSubview:rootview0];

    [self init_3_img];
}

//照片墙

-(void)init_3_img
{
    rootView2=[[UIView alloc]initWithFrame:CGRectMake(6, 420, WIN_WIDTH-12, 114)];
    rootView2.backgroundColor=[UIColor whiteColor];
    
    NSArray *array=self.dataDic[@"photo_wall"][@"count"];
    img_ID_Ary=[[NSMutableArray alloc]init];
    NSMutableArray *img_urlArray    =[[NSMutableArray alloc]init];
    NSMutableArray *titleArray      =[[NSMutableArray alloc]init];
    NSMutableArray *sub_titleArray  =[[NSMutableArray alloc]init];
    img_Web_Ary                     =[[NSMutableArray alloc]init];

    for (NSDictionary *dic in array) {
        NSString  *idStr        = dic[@"id"];
        NSString  *img_urlStr   = dic[@"img_url"];
        NSString  *titleStr     = dic[@"title"];
        NSString  *sub_titleStr = dic[@"sub_title"];
        NSString  *web_urlStr   = dic[@"web_url"];
        
        [img_ID_Ary     addObject  : idStr];
        [img_urlArray   addObject  : img_urlStr];
        [titleArray     addObject  : titleStr];
        [sub_titleArray addObject  : sub_titleStr];
        [img_Web_Ary    addObject  : web_urlStr];
    }
    NSArray *colorArray=@[color_1,color_2,color_3];
    NSArray *colorArray_text=@[color_4,color_5,color_6];
    
    
    for (int i=0; i<3; i++) {
    
        UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(3+((WIN_WIDTH-15)/3)*i, 4, (WIN_WIDTH-28)/3, 106)];
        colorView.backgroundColor=colorArray[i];
        
        UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, (WIN_WIDTH-28)/3,15)];
        nameLab.textAlignment=NSTextAlignmentCenter;
        nameLab.textColor=[UIColor whiteColor];
        nameLab.font=DESC_FONT;
        nameLab.text=titleArray[i];
        
        UILabel*subLab=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(nameLab.frame)+6, (WIN_WIDTH-28)/3-10, 16)];
        subLab.layer.masksToBounds=YES;
        subLab.layer.cornerRadius=6;
        subLab.font=INFO_FONT;
        subLab.textAlignment=NSTextAlignmentCenter;
        subLab.textColor=[UIColor whiteColor];
        subLab.backgroundColor=colorArray_text[i];
        subLab.text=sub_titleArray[i];
        
        UIImageView *img_View=[[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH-28)/6-25, CGRectGetMaxY(subLab.frame)+8, 50, 50)];
        [img_View setUserInteractionEnabled:YES];
        img_View.contentMode=UIViewContentModeScaleAspectFit;
        img_View.backgroundColor=colorArray[i];
        [img_View setImageWithURL:[NSURL URLWithString:img_urlArray[i]]];
    
        
        [colorView addSubview:nameLab];
        [colorView addSubview:subLab];
        [colorView addSubview:img_View];
        [rootView2 addSubview:colorView];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(3+((WIN_WIDTH-15)/3)*i, 4, (WIN_WIDTH-28)/3, 106)];
        [btn addTarget:self action:@selector(img_3_Touch:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=[img_ID_Ary[i]intValue]+10000;
        [rootView2 addSubview:btn];
    }
    [self.scrollView addSubview:rootView2];
    [self initJifenView];
}


//积分
-(void)initJifenView
{
    rootView3=[[UIView alloc]initWithFrame:CGRectMake(6,CGRectGetMaxY(rootView2.frame)+10, WIN_WIDTH, 126)];
    rootView3.backgroundColor=[UIColor whiteColor];
    UILabel *jifenLab=[[UILabel alloc]initWithFrame:CGRectMake(7, 12, 65, 16)];
    jifenLab.text=@"积分兑换";
    jifenLab.font=COMMON_FONT;
    jifenLab.textAlignment=NSTextAlignmentLeft;
    [rootView3 addSubview:jifenLab];
    
    
    UIButton *quanbuLab=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-56, 14, 23, 13)];
    [quanbuLab setTitle:@"全部" forState:UIControlStateNormal];
    [quanbuLab setTitleColor:COLOR_FONT_SECOND forState:UIControlStateNormal];
    quanbuLab.titleLabel.font=INFO_FONT;
    [rootView3 addSubview:quanbuLab];
    
    UIImageView *quanbuImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(quanbuLab.frame)+2, 14, 12, 12)];
   [quanbuImg setImage:[UIImage imageNamed:@"quanbu1"]];
    [rootView3 addSubview:quanbuImg];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 34, WIN_WIDTH-12, 0.5)];
    lineView.backgroundColor=COLOR_LINE;
    [rootView3 addSubview:lineView];
    
     NSArray *array=self.dataDic[@"top_integral"][@"count"];
     jifenId_Ary=[[NSMutableArray alloc]init];
    NSMutableArray *img_urlArray=[[NSMutableArray alloc]init];
    NSMutableArray *integralArray=[[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        NSString  *idStr       = dic[@"id"];
        NSString  *img_urlStr  = dic[@"img_url"];
        NSString  *integralStr = dic[@"integral"];
        
        [jifenId_Ary   addObject  : idStr];
        [img_urlArray  addObject  : img_urlStr];
        [integralArray addObject  : integralStr];
        
    }
    
    NSArray *arrrrrrr=[[NSArray alloc]init];
    arrrrrrr=integralArray;
    for (int i=0; i<array.count; i++) {
        UIView *itmeView=[[UIView alloc]initWithFrame:CGRectMake(i*(WIN_WIDTH-12)/4, 34.5,( WIN_WIDTH-12)/4, 91.5)];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(11,8, 55, 55)];
        imgView.contentMode=UIViewContentModeScaleAspectFit;
        [imgView setUserInteractionEnabled:YES];
        [imgView setImageWithURL:[NSURL URLWithString:img_urlArray[i]]];
       
        UILabel *jifenlab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+2,(WIN_WIDTH-12)/4, 12)];
        NSString*labText=[NSString stringWithFormat:@"%@",arrrrrrr[i]];
        jifenlab.text=labText;
        jifenlab.font=DESC_FONT;
        jifenlab.textAlignment=NSTextAlignmentCenter;
        jifenlab.textColor=UIColorFromRGB(0xf15553);
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, ((WIN_WIDTH-12)/4), 72)];
        btn.backgroundColor=[UIColor clearColor];
        btn.tag=[jifenId_Ary[i] intValue]+10000;
        [btn addTarget:self action:@selector(jifenBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [itmeView addSubview:imgView];
        [itmeView addSubview:jifenlab];
        [itmeView addSubview:btn];
        [rootView3 addSubview:itmeView];
        
    }
    for (int j=0; j<3; j++) {
        UIView*lineView_2=[[UIView alloc]initWithFrame:CGRectMake(((WIN_WIDTH-12)/4)*(j+1), CGRectGetMaxY(lineView.frame)+20, 0.5, 54)];
        lineView_2.backgroundColor=COLOR_LINE;
        [rootView3 addSubview:lineView_2];
    }
    [self.scrollView addSubview:rootView3];
    
    [self initRemenView];
}

//热门品牌
-(void)initRemenView
{
    
    rootView4=[[UIView alloc]initWithFrame:CGRectMake(6,CGRectGetMaxY(rootView3.frame)+10, WIN_WIDTH, 149)];
    rootView4.backgroundColor=[UIColor whiteColor];
    UILabel *renmenLab=[[UILabel alloc]initWithFrame:CGRectMake(7, 12, 65, 16)];
    renmenLab.text=@"热门搜索";
    renmenLab.font=COMMON_FONT;
    renmenLab.textAlignment=NSTextAlignmentLeft;
    [rootView4 addSubview:renmenLab];

    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 34, WIN_WIDTH-12, 0.5)];
    lineView.backgroundColor=COLOR_LINE;
    [rootView4 addSubview:lineView];
    
    NSArray *array=self.dataDic[@"brand"][@"count"];
    remenId_Ary=[[NSMutableArray alloc]init];
    NSMutableArray *img_urlArray=[[NSMutableArray alloc]init];
    NSMutableArray *web_urlArray=[[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        NSString  *idStr      = dic[@"id"];
        NSString  *img_urlStr = dic[@"img_url"];
        NSString  *web_urlStr = dic[@"web_url"];
        
        [remenId_Ary  addObject : idStr];
        [img_urlArray addObject : img_urlStr];
        [web_urlArray addObject : web_urlStr];
        
    }
    
    for (int j=0; j<2; j++) {
        for (int i=0; i<4; i++) {
            UIImageView *remenViewImg=[[UIImageView alloc]initWithFrame:CGRectMake(5+i*(WIN_WIDTH-12)/4, 5+CGRectGetMaxY(lineView.frame)+(57*j), (WIN_WIDTH-12)/4 -10, 47)];
            remenViewImg.backgroundColor=[UIColor whiteColor];
            [remenViewImg setUserInteractionEnabled:YES];
            NSInteger index_count=i+j*4;
            remenViewImg.contentMode=UIViewContentModeScaleAspectFit;
            [remenViewImg setImageWithURL:[NSURL URLWithString:img_urlArray[index_count]]];
            [rootView4 addSubview:remenViewImg];
            
            UIButton *remenBtn=[[UIButton alloc]initWithFrame:CGRectMake(i*(WIN_WIDTH-12)/4, CGRectGetMaxY(lineView.frame)+(57*j), (WIN_WIDTH-12)/4, 57)];
            remenBtn.tag=[remenId_Ary[index_count]intValue]+10000;
            [remenBtn addTarget:self action:@selector(remenBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [rootView4 addSubview:remenBtn];
            
        }
        
    }
        for (int  i=0; i<3; i++) {
            if (i==0) {
                UIView *xline=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+57, WIN_WIDTH-12, 0.5)];
                xline.backgroundColor=COLOR_LINE;
                [rootView4 addSubview:xline];
            }
            UIView *yline=[[UIView alloc]initWithFrame:CGRectMake((i+1)*(WIN_WIDTH-12)/4, CGRectGetMaxY(lineView.frame), 0.5, 114)];
            yline.backgroundColor=COLOR_LINE;
            [rootView4 addSubview:yline];
           [self.scrollView addSubview:rootView4];
        }
    [self initHuiyuanView];
}


//会员特享
-(void)initHuiyuanView
{
    rootView5=[[UIView alloc]initWithFrame:CGRectMake(6,CGRectGetMaxY(rootView4.frame)+10, WIN_WIDTH, 203)];
    rootView5.backgroundColor=[UIColor whiteColor];
    UILabel *renmenLab=[[UILabel alloc]initWithFrame:CGRectMake(7, 12, 65, 16)];
    renmenLab.text=@"会员特享";
    renmenLab.font=COMMON_FONT;
    renmenLab.textAlignment=NSTextAlignmentLeft;
    [rootView5 addSubview:renmenLab];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 34, WIN_WIDTH-12, 0.5)];
    lineView.backgroundColor=COLOR_LINE;
    [rootView5 addSubview:lineView];
    
    NSArray *array=self.dataDic[@"members"][@"count"];
    huiyuanId_Ary=[[NSMutableArray alloc]init];
    NSMutableArray *img_urlArray=[[NSMutableArray alloc]init];
    huiyuan_Web_Ary=[[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        NSString  *idStr      = dic[@"id"];
        NSString  *img_urlStr = dic[@"img_url"];
        NSString  *web_urlStr = dic[@"web_url"];
        
        [huiyuanId_Ary   addObject : idStr];
        [img_urlArray    addObject : img_urlStr];
        [huiyuan_Web_Ary addObject : web_urlStr];
        
    }
    
        for (int i=0; i<array.count; i++) {
            float xPoint = i%2*(WIN_WIDTH-19)/2 + 7;
            float yPoint = (i/2)*79 + CGRectGetMaxY(lineView.frame) + 10;
            
            UIImageView *huiyuanImg=[[UIImageView alloc]initWithFrame:CGRectMake(xPoint, yPoint ,(WIN_WIDTH-33)/2 , 73)];
            [huiyuanImg setUserInteractionEnabled:YES];
            huiyuanImg.contentMode=UIViewContentModeScaleAspectFit;
            [huiyuanImg setImageWithURL:[NSURL URLWithString:img_urlArray[i]]];
            [rootView5 addSubview:huiyuanImg];
            
            UIButton *huiyuanBtn=[[UIButton alloc]initWithFrame:CGRectMake(xPoint,yPoint,(WIN_WIDTH-33)/2 , 73)];
            [huiyuanBtn addTarget:self action:@selector(huiyuanBtn_Touch:) forControlEvents:UIControlEventTouchUpInside];
            huiyuanBtn.tag=[huiyuanId_Ary[i]intValue]+10000;
            [rootView5 addSubview:huiyuanBtn];
    }
    
    [self.scrollView addSubview:rootView5];
    
    
    [self youlikeNet];
    
}

-(void)youlikeNet
{
    
    
        MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNum++;
        NSString *page=[NSString stringWithFormat:@"%ld",pageNum];
        int zz=4;
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadguesslike"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",page,@"page",@"8",@"pageSize",nil ]  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                
            if (isend1==NO) {
                NSString *isendStr=dic[@"data"][@"isend"];
                if ([isendStr isEqualToString:@"false"]) {
                    isend1=NO;
                }else
                {
                    isend1=YES;
                    [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
                }
                youLikeAry=dic[@"data"][@"list"];
                if (youLikeAry.count) {
                    [self initYouLikeView];
                }else {
                    [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
                    self.scrollView.footer.hidden=YES;
                }
            }
                [self.scrollView.footer endRefreshing];
                
                });
            }failue:^(NSDictionary *dic){
            
            }];
        }];

        self.scrollView.footer = footer;
        self.scrollView.footer.automaticallyHidden = YES;
}


//猜您喜欢

-(void)initYouLikeView
{
    if (pageNum==1) {
        UILabel *renmenLab=[[UILabel alloc]initWithFrame:CGRectMake(7,1042+12, 65, 16)];
        renmenLab.text=@"猜您喜欢";
        renmenLab.font=COMMON_FONT;
        renmenLab.textAlignment=NSTextAlignmentLeft;
        [self.scrollView addSubview:renmenLab];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 1042+34, WIN_WIDTH-12, 0.5)];
        lineView.backgroundColor=[UIColor clearColor];
        [self.scrollView addSubview:lineView];

    }
    NSInteger z=youLikeAry.count;
    NSInteger x=youLikeAry.count;
    if (youLikeAry.count<3) {
        x=1;
    }else if (youLikeAry.count<5) {
        x=2;
    }else if (youLikeAry.count<7) {
        x=3;
    }else if (youLikeAry.count<9) {
        x=4;
    }
    
    NSMutableArray     *nameAry=[[NSMutableArray alloc]init];
    NSMutableArray     *imgAry=[[NSMutableArray alloc]init];
    
    
    
    for (NSDictionary *dic in youLikeAry) {
        NSString *act_detail    = dic[@"act_detail"];
        NSString *imgStr        = dic[@"img_url"];
        NSString *nameStr       = dic[@"name"];
        
        [youlike_webAry addObject:act_detail];
        [imgAry addObject:imgStr];
        [nameAry addObject:nameStr];
    }
    
    
    

    for (int j=0; j<x; j++) {
        for (int i=0; i<2; i++) {
            if (z>0) {
                
                UIView *remenView=[[UIView alloc]initWithFrame:CGRectMake(6+i*((WIN_WIDTH-6)/2),1076.5+(161*j)+(pageNum-1)*644, (WIN_WIDTH-18)/2,155)];
//                remenView.backgroundColor=[UIColor redColor];
                
                UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, remenView.frame.size.width, 90)];
                [logoImg setImageWithURL:[NSURL URLWithString:imgAry[imgAry.count-z]]];
                
                UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(6,CGRectGetMaxY(logoImg.frame)+8,remenView.frame.size.width-12 , 14)];
                nameLab.numberOfLines=0;
                nameLab.text=nameAry[nameAry.count-z];
                nameLab.font=DESC_FONT;
                nameLab.textAlignment=NSTextAlignmentLeft;
                CGRect rect1=[nameLab.text boundingRectWithSize:CGSizeMake(remenView.frame.size.width-12,30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:nameLab.font} context:nil];
                nameLab.frame=CGRectMake(nameLab.frame.origin.x,nameLab.frame.origin.y, rect1.size.width, rect1.size.height);
                
                
                
                [remenView addSubview:logoImg];
                [remenView addSubview:nameLab];
                [self.scrollView addSubview:remenView];
                z--;
            }
        }
    }
    CGFloat  scr_h=1077+x*161+(pageNum-1)*644;
    self.scrollView.contentSize=CGSizeMake(WIN_WIDTH, scr_h);
    [self.scrollView addSubview:rootView6];
    
}



#pragma mark ------点击事件------

//点击签到按钮
-(void)qiandaoTouch:(UIButton*)sender
{
    
    NSLog(@"点击了签到按钮");
    
}

//点击了关注按钮
-(void)guanzhuTouch:(UIButton*)sender
{
    
    NSLog(@"点击了关注按钮");
    [self requestnetwork];
}




//点击搜索框跳转事件
-(void)sousuoTouch:(UIButton*)sender
{
    SearchStoreController *seVC=[[SearchStoreController alloc]init];
    
    [self.delegate.navigationController pushViewController:seVC animated:YES];
    
}

//返回按钮
-(void)fanhuiTouch
{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

//陈列物品的scroll触摸事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if (scrollView==_scrollView_2)
    {
        int index= _scrollView_2.contentOffset.x/(WIN_WIDTH-12);
        [pagecontrol1 setCurrentPage:index];
    }
}
    
    
//商品功能
-(void)btnTouch:(UIButton*)sender
{
    NSInteger index=sender.tag;
    NSString  *indexStr=[NSString stringWithFormat:@"%ld",index];
    
    NSArray *array=ceshiDic[indexStr];
    if ([array[1] isEqualToString:@"0"]) {
        
    }else if ([array[1] isEqualToString:@"1"]) {
        
    }else if ([array[1] isEqualToString:@"2"]) {
        
    }else if ([array[1] isEqualToString:@"3"]) {
        //美食
        SearchDetailsController *sVC=[[SearchDetailsController alloc]init];
        sVC.typeStr=@"4";
        sVC.headTypeStr=@"3";
        [self.delegate.navigationController pushViewController:sVC animated:YES];
    }else if ([array[1] isEqualToString:@"4"]) {
       
        
    }else if ([array[1] isEqualToString:@"5"]) {
        
    }else if ([array[1] isEqualToString:@"6"]) {
        
    }else if ([array[1] isEqualToString:@"7"]) {
        
    }else if ([array[1] isEqualToString:@"8"]) {
        
        
    }else if ([array[1] isEqualToString:@"9"]) {
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = @"http://mall.companycn.net/sh_rafflescity/park/parking";
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([array[1] isEqualToString:@"10"]) {
        
    }else if ([array[1] isEqualToString:@"11"]) {
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = @"http://m.ascottchina.com";
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([array[1] isEqualToString:@"12"]) {
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = @"http://mall.companycn.net/sh_rafflescity/service/index";
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }else if ([array[1] isEqualToString:@"13"]) {
        
    }else if ([array[1] isEqualToString:@"14"]) {
        
    }else if ([array[1] isEqualToString:@"15"]) {
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = @"http://mall.companycn.net/hpmall/office/office_building";
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }else if ([array[1] isEqualToString:@"16"]) {
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = @"http://mall.companycn.net/sh_rafflescity/map/traffic";
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }else if ([array[1] isEqualToString:@"17"]) {
        
    }else if ([array[1] isEqualToString:@"18"]) {
        
    }else if ([array[1] isEqualToString:@"19"]) {
        
    }else if ([array[1] isEqualToString:@"20"]) {
        
    }else if ([array[1] isEqualToString:@"21"]) {
        
    }else if ([array[1] isEqualToString:@"22"]) {
        
    }else if ([array[1] isEqualToString:@"23"]) {
        
    }else if ([array[1] isEqualToString:@"24"]) {
        
    }

}


//陈列物品下面的三张图片的点击事件

-(void)img_3_Touch:(UIButton*)sender
{
    
    NSInteger index=sender.tag-10000;
    NSString  *indexStr=[NSString stringWithFormat:@"%ld",index];
    if ([indexStr isEqualToString:img_ID_Ary[0]]) {
        NSLog(@"点击了第一个图片");
        
    }else if ([indexStr isEqualToString:img_ID_Ary[1]]){
         NSLog(@"点击了第2个图片");
    }else if ([indexStr isEqualToString:img_ID_Ary[2]]){
         NSLog(@"点击了第3个图片");
    }
    
}

//积分兑换点击事件

-(void)jifenBtnTouch:(UIButton*)sender
{
    
    NSInteger index=sender.tag-10000;
    NSString  *indexStr=[NSString stringWithFormat:@"%ld",index];
    if ([indexStr isEqualToString:jifenId_Ary[0]]) {
        NSLog(@"点击了第一个兑换积分");
        
    }else if ([indexStr isEqualToString:jifenId_Ary[1]]){
        
    }else if ([indexStr isEqualToString:jifenId_Ary[2]]){
        
    }else if ([indexStr isEqualToString:jifenId_Ary[3]]){
        
    }
 
}

//热门品牌
-(void)remenBtnTouch:(UIButton*)sender
{
    
    
}
//会员特享
-(void)huiyuanBtn_Touch:(UIButton*)sender
{
    
    NSInteger index=sender.tag-10000;
    NSString  *indexStr=[NSString stringWithFormat:@"%ld",index];
    if ([indexStr isEqualToString:huiyuanId_Ary[0]]) {
        NSLog(@"点击了第一个");
        
    }else if ([indexStr isEqualToString:huiyuanId_Ary[1]]){
        NSLog(@"点击了第2个");
    }else if ([indexStr isEqualToString:huiyuanId_Ary[2]]){
        NSLog(@"点击了第3个");
    }else if ([indexStr isEqualToString:huiyuanId_Ary[3]]){
        NSLog(@"点击了第4个");
    }
    
    
}

-(void)img_BtnTouch:(UIButton*)sender
{
    ScanViewController* vc = [[ScanViewController alloc] init];
    [self.delegate.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//测试字典
-(void)initdic1
{
    
    NSArray *ary1  = [[NSArray alloc]initWithObjects:@"1" ,@"1", nil];
    NSArray *ary2  = [[NSArray alloc]initWithObjects:@"2" ,@"2", nil];
    NSArray *ary3  = [[NSArray alloc]initWithObjects:@"3" ,@"3", nil];
    NSArray *ary4  = [[NSArray alloc]initWithObjects:@"4" ,@"4", nil];
    NSArray *ary5  = [[NSArray alloc]initWithObjects:@"5" ,@"5", nil];
    NSArray *ary6  = [[NSArray alloc]initWithObjects:@"6" ,@"6", nil];
    NSArray *ary7  = [[NSArray alloc]initWithObjects:@"7" ,@"7", nil];
    NSArray *ary8  = [[NSArray alloc]initWithObjects:@"8" ,@"8", nil];
    NSArray *ary9  = [[NSArray alloc]initWithObjects:@"9" ,@"9", nil];
    NSArray *ary10 = [[NSArray alloc]initWithObjects:@"10",@"10", nil];
    NSArray *ary11 = [[NSArray alloc]initWithObjects:@"11",@"11", nil];
    NSArray *ary12 = [[NSArray alloc]initWithObjects:@"12",@"12", nil];
    NSArray *ary13 = [[NSArray alloc]initWithObjects:@"13",@"13", nil];
    NSArray *ary14 = [[NSArray alloc]initWithObjects:@"14",@"14", nil];
    NSArray *ary15 = [[NSArray alloc]initWithObjects:@"15",@"15", nil];
    NSArray *ary16 = [[NSArray alloc]initWithObjects:@"16",@"16", nil];
    NSArray *ary17 = [[NSArray alloc]initWithObjects:@"17",@"17", nil];
    NSArray *ary18 = [[NSArray alloc]initWithObjects:@"18",@"18", nil];
    NSArray *ary19 = [[NSArray alloc]initWithObjects:@"19",@"19", nil];
    NSArray *ary20 = [[NSArray alloc]initWithObjects:@"20",@"20", nil];
    NSArray *ary21 = [[NSArray alloc]initWithObjects:@"21",@"21", nil];
    NSArray *ary22 = [[NSArray alloc]initWithObjects:@"22",@"22", nil];
    NSArray *ary23 = [[NSArray alloc]initWithObjects:@"23",@"23", nil];
    NSArray *ary24 = [[NSArray alloc]initWithObjects:@"201",@"24", nil];
    
    ceshiDic=[[NSDictionary alloc]initWithObjectsAndKeys:ary1,@"1",ary2,@"2",ary3,@"3",ary4,@"4",ary5,@"5",ary6,@"6",ary7,@"7",ary8,@"8",ary9,@"9",ary10,@"10",ary11,@"11",ary12,@"12",ary13,@"13",ary14,@"14",ary15,@"15",ary16,@"16",ary17,@"17",ary18,@"18",ary19,@"19",ary20,@"20",ary21,@"21",ary22,@"22",ary23,@"23",ary24,@"24",nil];
    
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
