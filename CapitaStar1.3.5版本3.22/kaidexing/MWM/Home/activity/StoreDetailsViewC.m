//
//  StoreDetailsViewC.m
//  kaidexing
//
//  Created by 朱巩拓 on 2017/2/16.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "StoreDetailsViewC.h"
#import <UShareUI/UShareUI.h>
#import "MLabel.h"
#import "GoViewController.h"
#import "IndoorMapController.h"
#import "PickController.h"
#import "LineUpHomeController.h"
#import "GoViewController.h"
#import "RTMInterfaceController.h"

#define CELL_H M_WIDTH(39)

@interface StoreDetailsViewC ()<UIScrollViewDelegate>
@property (strong, nonatomic)UIScrollView  *rootScrollView;


@end

@implementation StoreDetailsViewC{
    NSDictionary  *dataDic;
    CGFloat        view_H;
    UIView        *shareView;//分享底层View
    UIButton      *shareBtn; //分享按钮
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = _headTitle;
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    view_H=0;
    [self loadData];
}

#pragma mark  ------  数据请求  ------
-(void)loadData{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"shopdetail"]parameters:[[NSDictionary alloc]initWithObjectsAndKeys:_shopId,@"shop_id",nil] target:self success:^(NSDictionary *dic){ dispatch_async(dispatch_get_main_queue(), ^{
        dataDic = dic[@"data"];
        [self createNavUMShare];
        [self createRootScrollView];
        
        });
    }failue:^(NSDictionary *dic){
    }];
}
#pragma mark  ------  顶部分享  ------
-(void)createNavUMShare{
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:self.rigthBarItemView.bounds];
    [shareBtn setImage:[UIImage imageNamed:@"StoreDetailsShare"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:shareBtn];
    self.rigthBarItemView.hidden = FALSE;
}

-(void)shareTouch:(UIButton*)sender{
    
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,WIN_HEIGHT)];
    shareView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    UIView *buttomView = [[UIView alloc]init];
    buttomView.backgroundColor = [UIColor whiteColor];
    NSArray *imgAry = @[@"shareweixingood",@"shareweixinquan",@"sharezhifubao"];
    NSArray *titleAry = @[@"微信好友",@"微信朋友圈",@"支付宝"];//
    CGFloat cell_headerTop = M_WIDTH(22); //view距上距离
    CGFloat cell_laft_W =M_WIDTH(5);//view距左
    CGFloat cell_W = (WIN_WIDTH-2*cell_laft_W)/4;//view的宽
    CGFloat cell_H = M_WIDTH(75);//view的高
    CGFloat cell_img_H = M_WIDTH(38);//view中img的高度
    CGFloat cell_spacing = (cell_W-cell_img_H)/2;//每两个图片的间距/2
    CGFloat cell_buttom_H = M_WIDTH(10);//
    CGFloat cencelBtn_H = M_WIDTH(42);
    
    for (int i=0; i<titleAry.count; i++) {
        int x = i%4;
        int y = i/4;
        UIView *cell= [[UIView alloc]initWithFrame:CGRectMake(cell_laft_W + x*cell_W, cell_headerTop + y* cell_H ,cell_W,cell_H)];
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(cell_spacing,0,cell_img_H,cell_img_H)];
        [iconImg setImage:[UIImage imageNamed:imgAry[i]]];
        
        [cell addSubview:iconImg];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(iconImg.frame),cell_W,M_WIDTH(32))];
        titleLab.text=titleAry[i];
        titleLab.font=INFO_FONT;
        titleLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:titleLab];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sharePushTouch:)];
        [cell addGestureRecognizer:tapGesture];
        UIView *tapView1 = [tapGesture view];
        tapView1.tag = i;
        
        [buttomView addSubview:cell];
    }
    int num = ceilf(titleAry.count/4.0);
    CGFloat buttomView_H = cell_headerTop + cell_H * num + cell_buttom_H + cencelBtn_H;
    buttomView.frame = CGRectMake(0,WIN_HEIGHT-buttomView_H,WIN_WIDTH,buttomView_H);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,buttomView_H-cencelBtn_H,WIN_WIDTH,1)];
    lineView.backgroundColor = COLOR_LINE;
    [buttomView addSubview:lineView];
    
    UIButton *cencelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,buttomView_H-cencelBtn_H+1,WIN_WIDTH,cencelBtn_H-1)];
    [cencelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cencelBtn.titleLabel.font=DESC_FONT;
    [cencelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cencelBtn addTarget:self action:@selector(cencelTouch:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:cencelBtn];
    [shareView addSubview:buttomView];
    [self.view addSubview:shareView];
    
}
-(void)cencelTouch:(UIButton*)sender{
    [shareView removeFromSuperview];
}

-(void)sharePushTouch:(UITapGestureRecognizer*)tap{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tap;
    NSInteger i = singleTap.view.tag;
    if (i==0) {
        [self sharePush:UMSocialPlatformType_WechatSession];
    }else if (i==1) {
        [self sharePush:UMSocialPlatformType_WechatTimeLine];
    }else if (i==2) {
        [self sharePush:UMSocialPlatformType_AlipaySession];
    }
    [shareView removeFromSuperview];
}


-(void)sharePush:(UMSocialPlatformType)shareType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_headTitle descr:[Util isNil:dataDic[@"shop"][@"remark"]] thumImage:[Util isNil:dataDic[@"shop"][@"logo_img_url"]]];
    //设置网页地址
    shareObject.webpageUrl = [Util isNil:dataDic[@"shopextend"][@"share_url"]];// @"weixin://wx281a422ccc3e8054";//
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [shareView removeFromSuperview];
//}


#pragma mark  ------  底部ScollView  ------
-(void)createRootScrollView{
    self.rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT)];
    self.rootScrollView.scrollEnabled=YES;
    self.rootScrollView.backgroundColor = [UIColor clearColor];
    self.rootScrollView.contentSize = CGSizeMake(WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT);
    [self.view addSubview:self.rootScrollView];
    [self createHeadLogoImg];
}

#pragma mark  ------  顶部店铺图  ------
-(void)createHeadLogoImg{
    UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(150))];
    headImg.contentMode=UIViewContentModeScaleAspectFill;
    
    NSArray *ary=dataDic[@"shop"][@"banner"];
    if (![Util isNull:ary] && ary.count>0) {
         [headImg setImageWithURL:[NSURL URLWithString:ary[0][@"img_url"]]];
    }
    [self.rootScrollView addSubview:headImg];
    view_H = view_H + M_WIDTH(150);
    [self createShopDetails];
}

#pragma mark  ------  店铺详情  ------
-(void)createShopDetails{
    
    NSArray *imgAry   =@[@"StoreDetailsPhone",@"StoreDetailsMap"];
    NSArray *titleAry =@[@"联系电话",@"店铺位置"];
    NSString *mallMap = [NSString stringWithFormat:@"%@/%@",[Util isNil:dataDic[@"shop"][@"floor_name"]],[Util isNil:dataDic[@"shop"][@"house_number"]]];
    NSArray *rightAry =@[[Util isNil:dataDic[@"shop"][@"phone"]],mallMap];
    NSInteger aryNum = titleAry.count-1;
    bool isLast=NO;
    for (int i=0; i<titleAry.count;i++ ) {
        isLast = i==aryNum?YES:NO;
        UIView *shopView_1 = [[UIView alloc]initWithFrame:CGRectMake(0,view_H,WIN_WIDTH,CELL_H)];
        [self handleView:shopView_1 iconImgName:imgAry[i] title:titleAry[i] rightLab:rightAry[i] rightLabColor:COLOR_FONT_SECOND isTouch:isLast target:self tag:(isLast?1:0) touchAcdaction:@selector(storeActivity:) isLine:(isLast?NO:YES)];
        [self.rootScrollView addSubview:shopView_1];
        view_H = view_H + CELL_H;
    }
    [self createActivityView];
}

-(void)storeActivity:(UITapGestureRecognizer*)tag{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tag;
    NSInteger index = singleTap.view.tag;
    if (index == 1) {
        //楼层导航
//        IndoorMapController  *vc=[[IndoorMapController alloc]init];
//        vc.myBuildString = [Global sharedClient].building_id;
//        vc.myFloorId= [Util isNil:dataDic[@"shop"][@"floor_name"]];
//        [self.delegate.navigationController pushViewController:vc animated:YES];
        
        [self presentViewController:[RTMInterfaceController loadControllerWithDestinationPOI:@{@"buildingID":[Global sharedClient].building_id,@"floorID":dataDic[@"shop"][@"floor_name"],@"name":_headTitle}] animated:YES completion:nil];
    }else if(index == 2){
        //我要排队
//        PickController *vc=[[PickController alloc]init];
//        vc.shopID=dataDic[@"shop"][@"shop_id"];
//        [self.delegate.navigationController pushViewController:vc animated:YES];

        GoViewController *vc=[[GoViewController alloc]init];
        vc.path=dataDic[@"shopextend"][@"quene_url"];
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }else if(index == 3){
        //我要订座
//        PickController *vc=[[PickController alloc]init];
//        vc.shopID=dataDic[@"shop"][@"shop_id"];
//        [self.delegate.navigationController pushViewController:vc animated:YES];
        GoViewController *vc=[[GoViewController alloc]init];
        vc.path=dataDic[@"shopextend"][@"reserve_url"];
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark  ------  活动优惠功能  ------
-(void)createActivityView{
    int booked_id = [dataDic[@"shopextend"][@"booked_status"] intValue];
    int booked_status = [dataDic[@"shopextend"][@"booked_status"] intValue];
    
    int lineup_status = [dataDic[@"shopextend"][@"lineup_status"] intValue];
    
    view_H = view_H + M_WIDTH(8);
    NSArray *imgAry   =@[@"StoreDetailspai",@"StoreDetailsyuding"];
    NSArray *titleAry =@[@"我要排队",@"我要订座"];
    NSInteger aryNum = titleAry.count-1;
    bool isLast=YES;
    if (booked_id>0 && booked_status >0) {
        int i = 1;
        UIView *shopView_1 = [[UIView alloc]initWithFrame:CGRectMake(0,view_H,WIN_WIDTH,CELL_H)];
        [self handleView:shopView_1 iconImgName:imgAry[i] title:titleAry[i] rightLab:@"" rightLabColor:COLOR_FONT_SECOND isTouch:isLast target:self tag:i+2 touchAcdaction:@selector(storeActivity:) isLine:(isLast?NO:YES)];
        [self.rootScrollView addSubview:shopView_1];
        view_H = view_H + CELL_H;
    }
    if (lineup_status>0) {
        int i = 0;
        UIView *shopView_1 = [[UIView alloc]initWithFrame:CGRectMake(0,view_H,WIN_WIDTH,CELL_H)];
        [self handleView:shopView_1 iconImgName:imgAry[i] title:titleAry[i] rightLab:@"" rightLabColor:COLOR_FONT_SECOND isTouch:isLast target:self tag:i+2 touchAcdaction:@selector(storeActivity:) isLine:(isLast?NO:YES)];
        [self.rootScrollView addSubview:shopView_1];
        view_H = view_H + CELL_H;
    }
    [self createNewestView];
}


#pragma mark  ------  最新活动  ------
-(void)createNewestView{
    //先判断是否有最新活动
    NSArray *dataary =dataDic[@"shopactivity"];
    if (![Util isNull:dataary] && dataary.count>0) {
        view_H = view_H +M_WIDTH(4);
        UILabel *titlaLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),view_H,M_WIDTH(150),M_WIDTH(33))];
        [self chuliLab:titlaLab title:@"最新活动"];
        [self.rootScrollView addSubview:titlaLab];
        
        view_H = view_H +M_WIDTH(33);
        
        UIView *rootView = [[UIView alloc]init];
        rootView.backgroundColor = [UIColor whiteColor];
        
        CGFloat cell_Height  = M_WIDTH(64);//
        CGFloat cell_Width   = WIN_WIDTH-M_WIDTH(22);
        CGFloat cell_spacing = M_WIDTH(9);//cell的间距
        CGFloat cell_Free    = M_WIDTH(10);//cell最上方和最下方的留白距离
        CGFloat cell_NumHeight = cell_Free; //整个占用的高度
        
        for (int i=0; i<dataary.count; i++) {
            NSDictionary *itmeDic = dataDic[@"shopactivity"][i];
            UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(11),cell_NumHeight,cell_Width, cell_Height)];
            UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,M_WIDTH(96),cell_Height)];
            [logoImg setImageWithURL:[NSURL URLWithString:itmeDic[@"img_url"]]];
            [cellView addSubview:logoImg];
            
            UILabel *activityNameLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(8),M_WIDTH(7),M_WIDTH(190),M_WIDTH(18))];
            activityNameLab.text=itmeDic[@"name"];
            activityNameLab.font=DESC_FONT;
            [cellView addSubview:activityNameLab];
            
            UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(8),CGRectGetMaxY(activityNameLab.frame)+M_WIDTH(7),M_WIDTH(195),M_WIDTH(14))];
            NSString * startTime = [NSString stringWithFormat:@"%@",[Util isNil:itmeDic[@"start_time"]]];
            NSString * endTime   = [NSString stringWithFormat:@"%@",[Util isNil:itmeDic[@"end_time"]]];
            timeLab.text=[NSString stringWithFormat:@"有效期  %@/%@",startTime,endTime];
            timeLab.textColor = COLOR_FONT_SECOND;
            timeLab.font=INFO_FONT;
            [cellView addSubview:timeLab];
            
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newActivityTouch:)];
            [cellView addGestureRecognizer:tapGesture];
            UIView *tapView1 = [tapGesture view];
            tapView1.tag = i;
            
            [rootView addSubview:cellView];
            cell_NumHeight = cell_NumHeight + cell_Height;
            if (i != dataary.count-1) {
                cell_NumHeight = cell_NumHeight + cell_spacing;
            }
        }
        cell_NumHeight = cell_NumHeight + cell_Free;
        rootView.frame = CGRectMake(0,view_H,WIN_WIDTH,cell_NumHeight);
        view_H = view_H +cell_NumHeight;
        self.rootScrollView.contentSize = CGSizeMake(WIN_WIDTH,view_H);
        [self.rootScrollView addSubview:rootView];
    }
    
    [self createDetailsTextView];
 }

-(void)newActivityTouch:(UITapGestureRecognizer*)tag{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tag;
    NSInteger index = singleTap.view.tag;
    if (![Util isNull:dataDic[@"shopactivity"]]) {
        NSDictionary *dic = dataDic[@"shopactivity"][index];
        GoViewController *vc = [[GoViewController alloc]init];
        vc.path = [Util isNil:dic[@"act_detail"]];
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark  ------  详情/使用通知  ------
-(void)createDetailsTextView{
    //先判断是否有详情
    if (![Util isNull:dataDic[@"shop"][@"remark"]]) {
        
        view_H = view_H +M_WIDTH(4);
        UILabel *titlaLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),view_H,M_WIDTH(150),M_WIDTH(33))];
        [self chuliLab:titlaLab title:@"详情/使用须知"];
        [self.rootScrollView addSubview:titlaLab];
        view_H = view_H +M_WIDTH(33);
        
        UIView *rootView = [[UIView alloc]init];
        rootView.backgroundColor = [UIColor whiteColor];
        
        NSString *text = dataDic[@"shop"][@"remark"];
        NSArray  *textAry = [text componentsSeparatedByString:@"；"];
        
        CGFloat textHeight=M_WIDTH(10);
        
        for (int i=0; i<textAry.count; i++) {
            MLabel *contentLab = [[MLabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),textHeight,WIN_WIDTH-M_WIDTH(22),10)];
            contentLab.text=textAry[i];
            contentLab.font=INFO_FONT;
            contentLab.textColor=COLOR_FONT_SECOND;
            contentLab.numberOfLines=0;
            contentLab.maxHeight=M_WIDTH(500);
            [contentLab autoSize];
            [rootView addSubview:contentLab];
            
            textHeight = textHeight +contentLab.frame.size.height + M_WIDTH(5);
        }
        rootView.frame =CGRectMake(0,view_H,WIN_WIDTH,textHeight + M_WIDTH(5));
        [self.rootScrollView addSubview:rootView];
        view_H = view_H +textHeight + M_WIDTH(5);
        self.rootScrollView.contentSize = CGSizeMake(WIN_WIDTH,view_H);
    }
    [self createHotCommodityView];
}


#pragma mark  ------  热门单品  ------
-(void)createHotCommodityView{
    //先判断是否有热门单品
    NSArray *dataary =dataDic[@"shopproduct"];
    if(![Util isNull:dataary] && dataary.count>0){
        view_H = view_H +M_WIDTH(4);
        UILabel *titlaLab = [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(11),view_H,M_WIDTH(150),M_WIDTH(33))];
        [self chuliLab:titlaLab title:@"热门单品"];
        [self.rootScrollView addSubview:titlaLab];
        view_H = view_H +M_WIDTH(33);
        
        UIView *rootView = [[UIView alloc]init];
        rootView.backgroundColor = [UIColor whiteColor];
        
        CGFloat cell_Height  = M_WIDTH(202);//
        CGFloat cell_Width   = (WIN_WIDTH-M_WIDTH(31))/2;
        CGFloat cell_spacing = M_WIDTH(9);//cell的间距
        CGFloat cell_Free    = M_WIDTH(10);//cell最上方和最下方的留白距离
        
        for (int i=0; i<dataary.count; i++) {
            int cell_x = i%2;
            int cell_y = i/2;
            NSDictionary *dic =dataary[i];
            
            UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(11)+(cell_Width+cell_spacing)*cell_x,cell_Free+cell_Height*cell_y,cell_Width, cell_Height)];
            UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,cell_Width,M_WIDTH(150))];
            [logoImg setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"img_url"]]]];
            logoImg.layer.borderColor=COLOR_LINE.CGColor;
            logoImg.layer.borderWidth=1;
            [cellView addSubview:logoImg];
            
            MLabel *activityNameLab = [[MLabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(logoImg.frame) + M_WIDTH(7),cell_Width,M_WIDTH(18))];
            activityNameLab.text=[Util isNil:dic[@"name"]];
            activityNameLab.numberOfLines=0;
            activityNameLab.font=DESC_FONT;
            activityNameLab.maxHeight=M_WIDTH(42);
            [activityNameLab autoSize];
            [cellView addSubview:activityNameLab];
            
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopproductTouch:)];
            [cellView addGestureRecognizer:tapGesture];
            UIView *tapView1 = [tapGesture view];
            tapView1.tag = i;
            
            [rootView addSubview:cellView];
        }
        int countH = ceilf(dataary.count/2.0);
        
        rootView.frame = CGRectMake(0,view_H,WIN_WIDTH,cell_Free*2 + countH *cell_Height);
        view_H = view_H + cell_Free*2 + countH *cell_Height;
        self.rootScrollView.contentSize = CGSizeMake(WIN_WIDTH,view_H);
        [self.rootScrollView addSubview:rootView];
    }
}

-(void)shopproductTouch:(UITapGestureRecognizer*)tap{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tap;
    NSInteger index = singleTap.view.tag;
    NSDictionary *dic = dataDic[@"shopproduct"][index];
    GoViewController *vc= [[GoViewController alloc]init];
    vc.path=dic[@"product_detail"];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

#pragma mark  ------  对界面的处理  ------
-(void)handleView:(UIView*)itmeView iconImgName:(NSString*)iconImg title:(NSString*)title rightLab:(NSString*)rightStr rightLabColor:(UIColor*)rightColor isTouch:(BOOL)isTouch target:(id)target tag:(int)viewTag touchAcdaction:(SEL)touchAcdaction isLine:(BOOL)isLine{
    
    CGFloat itme_height = itmeView.frame.size.height;
    
    itmeView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *laftImg = [[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11),(itme_height-M_WIDTH(16))/2,M_WIDTH(16),M_WIDTH(16))];
    [laftImg setImage:[UIImage imageNamed:iconImg]];
    [itmeView addSubview:laftImg];
    
    UILabel *laftLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(laftImg.frame)+M_WIDTH(9),0,M_WIDTH(100),itme_height)];
    laftLab.text=title;
    laftLab.font=DESC_FONT;
    [itmeView addSubview:laftLab];
    
    UILabel *rightLab = [[UILabel alloc]init];
    rightLab.font=INFO_FONT;
    rightLab.textAlignment=NSTextAlignmentRight;
    rightLab.text=rightStr;
    rightLab.textColor=rightColor;
    
    if (isTouch) {
        UIImageView *rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(16),(itme_height-M_WIDTH(7))/2,M_WIDTH(5),M_WIDTH(7))];
        [rightImg setImage:[UIImage imageNamed:@"StoreDetailsRight"]];
        [itmeView addSubview:rightImg];
        rightLab.frame=CGRectMake(WIN_WIDTH-M_WIDTH(190),0,M_WIDTH(169),itme_height);
        [itmeView addSubview:rightLab];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:target action:touchAcdaction];
        [itmeView addGestureRecognizer:tapGesture];
        UIView *tapView1 = [tapGesture view];
        tapView1.tag = viewTag;
        
    }else{
        rightLab.frame=CGRectMake(WIN_WIDTH-M_WIDTH(190),0,M_WIDTH(168),itme_height);
        [itmeView addSubview:rightLab];
    }
    
    if (isLine) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(11),itmeView.frame.size.height-1,WIN_WIDTH-M_WIDTH(11),1)];
        lineView.backgroundColor = COLOR_LINE;
        [itmeView addSubview:lineView];
    }
}

//单行Lab处理
-(void)chuliLab:(UILabel*)lab title:(NSString*)str{
    lab.text=str;
    lab.font=DESC_FONT;
    
}






@end
