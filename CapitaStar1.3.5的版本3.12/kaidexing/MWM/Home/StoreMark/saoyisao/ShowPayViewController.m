//
//  ShowPayViewController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "ShowPayViewController.h"
#import "MMScanViewController.h"
#import "BankPopView.h"
#import "AddBankCardController.h"
#import "BillViewController.h"
#import "CodePopView.h"
#import "PayDetailPopView.h"
#import "BankListController.h"
#import "ResetPasswordViewController.h"

#define CODESTRING @"21423353"
@interface ShowPayViewController ()<BankPopViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,PayDetailPopViewDelegate>
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)BankPopView *bankPopView;
@property (nonatomic,strong)CodePopView *codePopView;
@property (nonatomic,strong)PayDetailPopView *payDetailPopView;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSArray *bankListArray;
@property (nonatomic,strong)NSDictionary *qrDic;
@property (nonatomic,strong)NSDictionary *codeDic;

@end

@implementation ShowPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"向商家付款";
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.navigationBarLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self loadData];
    [self crateRightBtn];
    [self createView];
    
    
   // [self popView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isBack == NO) {
         [self loadData];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_bgView removeFromSuperview];
    _isBack = NO;
    [_timer invalidate];
}
- (NSArray *)bankListArray
{
    if (!_bankListArray) {
        _bankListArray = [NSArray array];
    }
    return _bankListArray;
}
- (NSDictionary *)qrDic{
    if (!_qrDic) {
        _qrDic = [NSDictionary dictionary];
    }
    return _qrDic;
}
- (NSDictionary *)codeDic{
    if (!_codeDic) {
        _codeDic = [NSDictionary dictionary];
    }
    return _codeDic;
}
//获取银行列表
-(void)loadData
{
    
     NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _bankListArray = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getQrCode:_bankListArray[0][@"ides"]];
            NSString *num = _bankListArray[0][@"card_no"] ;
            NSString *last4Num = [num substringFromIndex:num.length-4];
           

            _BankCardLabel.text = [NSString stringWithFormat:@"%@(%@)",_bankListArray[0][@"card_name"],last4Num];
        });
    
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
       [self showAlertView];

    }];
}

//获取二维码
- (void)getQrCode:(NSString *)cardID{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"memberID",cardID,@"cardID",[[NSBundle mainBundle] bundleIdentifier],@"deviceID",nil];
    
    [HttpClient requestWithMethod:@"GET" path:[Util makeRequestUrl:@"unionpay/BackTrans" tp:@"CreatQrCode"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _qrDic = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginTimer];
            UIImage *image1 = [MMScanViewController createBarCodeImageWithString:_qrDic[@"qrNo"] barSize:CGSizeMake(WIN_WIDTH-40, 100)];
            [_codeImageView1 setImage: image1];
            UIImage *image2 = [MMScanViewController createQRImageWithString:_qrDic[@"qrImgUrl"] QRSize:CGSizeMake(130, 130)];
            [_codeIamgeView2 setImage: image2];
            _codeLabel.text = _qrDic[@"qrNo"];
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        
        
    }];
    
}
//获取轮巡订单状态
- (void)beginTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getQrCodeStatus) userInfo:nil repeats:YES];
     [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
   // [_timer invalidate];
}
- (void)getQrCodeStatus{
    
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"memberID",_qrDic[@"qrNo"],@"qrCode",nil];
    
    [HttpClient requestWithMethod:@"GET" path:[Util makeRequestUrl:@"unionpay/BackTrans" tp:@"GetQrcodeStatus"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _codeDic = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_timer invalidate];
            NSString *cardNo =_bankListArray[0][@"card_no"];
             NSString *bankName = [NSString stringWithFormat:@"%@(%@)",_bankListArray[0][@"card_name"],[cardNo substringFromIndex:cardNo.length-4]];
            [self popView:@"232" bankName:bankName couponInfo:_codeDic[@""] money:_codeDic[@"amount"]];
            
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        
        
    }];
}
-(void)crateRightBtn{
    UIButton * changeBtn = [[UIButton alloc]initWithFrame:self.rigthBarItemView.bounds];
    [changeBtn setImage:[UIImage imageNamed:@"iCON_more"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(detailTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:changeBtn];
    self.rigthBarItemView.hidden=NO;
}
- (void)detailTouch{
//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选项" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"消费记录" otherButtonTitles: nil];
//    sheet.actionSheetStyle = UIActionSheetStyleDefault;
//    //显示
//    [sheet showInView:self.view];
//    sheet.delegate = self;

    
}
//actionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        BillViewController *billVc = [[BillViewController alloc]init];
        [self.navigationController pushViewController:billVc animated:YES];
    }
}
- (void)createView
{
   
    _codeLabel.hidden = YES;
    
}
- (void)popView:(NSString *)codeStyle bankName:(NSString *)bankName couponInfo:(NSString *)couponInfo money:(NSString *)money
{
    
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    _payDetailPopView  = [PayDetailPopView createView];
    [_payDetailPopView.bankBtn setTitle:bankName forState:UIControlStateNormal];
    _payDetailPopView.cutLabel.text = couponInfo;
    _payDetailPopView.orderLabel.text = codeStyle;
    _payDetailPopView.moneyLabel.text = money;
    _payDetailPopView.delegate = self;
    _payDetailPopView.backgroundColor = [UIColor whiteColor];
    
    _payDetailPopView.frame = CGRectMake(0, WIN_HEIGHT/2-168, WIN_WIDTH, 336);
    [_bgView addSubview:_payDetailPopView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_payDetailPopView]||[touch.view isDescendantOfView:_bankPopView]||[touch.view isDescendantOfView:_codePopView]) {
        return NO;
    }
    
    return YES;
}
- (void)sureTapClick:(UITapGestureRecognizer *)tap{
    UIView * view = tap.view;
    [view removeFromSuperview];
    [view removeGestureRecognizer:tap];
}
- (IBAction)clickToLookCode:(id)sender {
    _codeLabel.hidden = NO;
}
- (IBAction)clickToChooseBankCard:(id)sender {
    [_timer invalidate];
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    _bankPopView = [[BankPopView alloc]initWithFrame:CGRectMake(0, (WIN_HEIGHT-264)/2, WIN_WIDTH, 264)];
    _bankPopView.delegate = self;
    [_bgView addSubview:_bankPopView];
    
}
//协议
- (void)clickTocancel
{
    [_bgView removeFromSuperview];
    
}
- (void)addBankCard{
    
    ResetPasswordViewController *resetVc= [[ResetPasswordViewController alloc]init];
    resetVc.phone = _bankListArray[0][@"cardholder_phone"];
    resetVc.type = 2;
   
    [self.navigationController pushViewController:resetVc animated:YES];
}

- (void)changeBankCard:(NSString *)bankName
{
    [self loadData];
    [self getQrCode:bankName] ;
    [_bgView removeFromSuperview];
    [_bankPopView removeFromSuperview];
}
//无绑定时弹起
- (void)showAlertView
{
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
   // [_bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(50, (WIN_HEIGHT-180)/2, WIN_WIDTH-100, 180)];
    _alertView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_alertView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, _alertView.width-20, 60)];
    label.numberOfLines = 2;
    label.text = @"您尚未绑定银行卡，绑定银行卡后可以向商家付款";
    label.font = [UIFont systemFontOfSize:15];
    [_alertView addSubview:label];
    
    UIButton *bankBtn = [[UIButton alloc]initWithFrame:CGRectMake(_alertView.width/2-60, 80, 120, 60)];
    [bankBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [bankBtn setTitle:@"查看支付银行" forState:UIControlStateNormal];
    [bankBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    [bankBtn addTarget:self action:@selector(clickToBank:) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:bankBtn];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _alertView.height-40, _alertView.width/2, 40)];
    UIButton *goBind = [[UIButton alloc]initWithFrame:CGRectMake(_alertView.width/2, _alertView.height-40, _alertView.width/2, 40)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goBind setTitle:@"去绑卡" forState:UIControlStateNormal];
    [goBind setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    backBtn.layer.borderColor = [UIColor grayColor].CGColor;
    goBind.layer.borderColor = [UIColor grayColor].CGColor;
    backBtn.layer.borderWidth = 1;
    goBind.layer.borderWidth = 1;
    
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [goBind addTarget:self action:@selector(clickToBindCard) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:goBind];
    [_alertView addSubview:backBtn];
}
- (void)clickToBank:(UIButton *)sender{
    BankListController *bankVc= [[BankListController alloc]init];
    [self.navigationController pushViewController:bankVc animated:YES];
}
- (void)clickToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickToBindCard
{
    [_bgView removeFromSuperview];
    AddBankCardController *AddVc = [[AddBankCardController alloc]init];
    AddVc.isfirstBindCard = YES;
    [self.navigationController pushViewController:AddVc animated:YES];
}
@end
