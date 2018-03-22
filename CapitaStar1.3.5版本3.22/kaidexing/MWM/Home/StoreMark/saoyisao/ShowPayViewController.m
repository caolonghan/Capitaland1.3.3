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
#import "BankListController.h"
#import "PayDetailPopView.h"
#import "ResetPasswordViewController.h"
#import "PaySuccessController.h"
#import "FindPasswordViewController.h"
#import "BillViewController.h"

#define codeStr @"1wfsfsefessef"
@interface ShowPayViewController ()<BankPopViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,PayDetailPopViewDelegate,CodePopViewDelegate>
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)PayDetailPopView *payDetailPopView;
@property (nonatomic,strong)BankPopView *bankPopView;
@property (nonatomic,strong)CodePopView *codePopView;
@property (nonatomic,strong)UIView *recodeView;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSArray *bankListArray;
@property (nonatomic,strong)NSDictionary *qrDic;
@property (nonatomic,strong)NSDictionary *codeDic;
@property (nonatomic,strong)NSString *ides;
@property (nonatomic,assign)BOOL isChangePayDetailView;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)BOOL isBigAmount;

@end

@implementation ShowPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image1 = [MMScanViewController createBarCodeImageWithString:codeStr barSize:CGSizeMake(WIN_WIDTH-40, 100)];
    [_codeImageView1 setImage: image1 ];
    _codeLabel.text = codeStr;
    UIImage *image2 = [MMScanViewController createQRImageWithString:codeStr QRSize:CGSizeMake(130, 130)];
    [_codeIamgeView2 setImage: image2];
    
    self.navigationBarTitleLabel.text = @"向商家付款";
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    self.navigationBarLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    _index = 0;
    [self loadBankInfo:_index];
    [self crateRightBtn];
    [self createView];
    [[UIScreen mainScreen] setBrightness: 1];//设置屏幕亮度
    [Global sharedClient].bindCardBackWhere = 1;
    [Global sharedClient].resetPwdBackWhere = 1;
  
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isBack == NO) {
        _index =0;
         [self loadBankInfo:_index];
       
    }
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removePopView];
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
-(void)loadBankInfo:(NSInteger)index
{
    
     NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _bankListArray = dic[@"data"];
        [Global sharedClient].hasBankCard = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getQrCode:_bankListArray[index][@"ides"]];
            NSString *num = _bankListArray[index][@"card_no"] ;
            NSString *last4Num = [num substringFromIndex:num.length-4];
       
            _BankCardLabel.text = [NSString stringWithFormat:@"%@(%@)",_bankListArray[index][@"card_name"],last4Num];
        });
    
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        NSString *result = [NSString stringWithFormat:@"%@",dic[@"result"]];
        if ([result isEqualToString:@"-1"]) {
             [self showAlertView];
            [Global sharedClient].hasBankCard = NO;
        }
      

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
            [_codeImageView1 setImage: image1 ];
            
//            UIImage *image2 = [MMScanViewController createQRImageWithString:_qrDic[@"qrImgUrl"] QRSize:CGSizeMake(130, 130)];
//            [_codeIamgeView2 setImage: image2];
            [_codeIamgeView2 setImageWithURL:[NSURL URLWithString:_qrDic[@"qrImgUrl"]]];
            _codeLabel.text = _qrDic[@"qrNo"];
            
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        [SVProgressHUD showErrorWithStatus:@"二维码获取失败"];
        _bankNameBtn.enabled = NO;
        
    }];
    
}
//开始轮巡
- (void)beginTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getQrCodeStatus) userInfo:nil repeats:YES];
     [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
   
}
//获取轮巡订单状态
- (void)getQrCodeStatus{
   
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"memberID",_qrDic[@"qrNo"],@"qrCode",nil];
    
    [HttpClient requestWithMethod:@"GET" path:[Util makeRequestUrl:@"unionpay/BackTrans" tp:@"GetQrcodeStatus"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _codeDic = dic[@"data"];
        [_timer invalidate];
        NSString *money = [NSString stringWithFormat:@"%@",_codeDic[@"amount"]];
        //_codeDic[@"merchantInfo"];
        dispatch_async(dispatch_get_main_queue(), ^{
          
                PaySuccessController *payVc= [[PaySuccessController alloc]init];
                payVc.money =money;
            NSString *cardNo =_bankListArray[_index][@"card_no"];
                        NSString *bankName = [NSString stringWithFormat:@"%@(%@)",_bankListArray[_index][@"card_name"],[cardNo substringFromIndex:cardNo.length-4]];
                payVc.bankName  = bankName;
                [self.navigationController pushViewController:payVc animated:YES];
            
            });
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
         NSString *result = [NSString stringWithFormat:@"%@",dic[@"result"]];
         dispatch_async(dispatch_get_main_queue(), ^{
            
        if ([result isEqualToString:@"1001"]) {
            [_timer invalidate];
           
            _isBigAmount = YES;
            [self createCodePopView];
        }
            
         });
    }];
}

//弹出密码框
- (void)createCodePopView{
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    _codePopView = [[CodePopView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT/2-100, WIN_WIDTH, 200)];
    _codePopView.delegate = self;
    [_bgView addSubview:_codePopView];
}
-(void)crateRightBtn{
    UIButton * changeBtn = [[UIButton alloc]initWithFrame:self.rigthBarItemView.bounds];
    [changeBtn setImage:[UIImage imageNamed:@"iCON_more"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(detailTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:changeBtn];
    self.rigthBarItemView.hidden=NO;
}
- (void)detailTouch{
    [_timer invalidate];
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];

    _recodeView = [[UIView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT-120, WIN_WIDTH, 120)];
    _recodeView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_recodeView];
    UIButton *recodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-40, 0, 80, 60)];
    [recodeBtn addTarget:self action:@selector(clickToRecode:) forControlEvents:UIControlEventTouchUpInside];
    [recodeBtn setTitle:@"支付记录" forState:UIControlStateNormal];
    [recodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    recodeBtn.titleLabel.font = COMMON_FONT;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 60, WIN_WIDTH-20, 1)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-40, 60, 80, 60)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
     cancleBtn.titleLabel.font = COMMON_FONT;
    [cancleBtn setTitleColor:RGBCOLOR(0, 135, 140) forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(ClickRecodeCancle:) forControlEvents:UIControlEventTouchUpInside];
    [_recodeView addSubview:recodeBtn];
    [_recodeView addSubview:line];
    [_recodeView addSubview:cancleBtn];
}
- (void)clickToRecode:(UIButton *)sender{
    [self removePopView];
    [_timer invalidate];
    BillViewController *billVc = [[BillViewController alloc]init];
    [self.navigationController pushViewController:billVc animated:YES];
}
- (void)ClickRecodeCancle:(UIButton *)sender
{
    [self removePopView];
    [self beginTimer];
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
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[_bgView class]]) {
            return;
        }
    }
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    
    _payDetailPopView  = [PayDetailPopView createView];
    _payDetailPopView.bankName = bankName;
    _payDetailPopView.couponInfo = couponInfo;
    _payDetailPopView.bankStyle = codeStyle;
    _payDetailPopView.money = money;
   _payDetailPopView.delegate = self;
    _payDetailPopView.frame = CGRectMake(0, WIN_HEIGHT-346, WIN_WIDTH, 346);
    [_bgView addSubview:_payDetailPopView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_payDetailPopView]||[touch.view isDescendantOfView:_bankPopView]||[touch.view isDescendantOfView:_codePopView]||[touch.view isDescendantOfView:_recodeView]) {
        return NO;
    }
    
    return YES;
}
- (void)sureTapClick:(UITapGestureRecognizer *)tap{
    [self beginTimer];
    [self removePopView];
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
    
    _bankPopView = [[BankPopView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-264, WIN_WIDTH, 264) index:_index];
    _bankPopView.delegate = self;
    [_bgView addSubview:_bankPopView];
    
}
//协议
- (void)clickTocancel
{
    [self beginTimer];
    [self removePopView];
    
}
- (void)addBankCard{
    
     [self removePopView];
    ResetPasswordViewController *resetVc= [[ResetPasswordViewController alloc]init];
    resetVc.phone = _bankListArray[_index][@"cardholder_phone"];
    resetVc.type = 2;
   
    [self.navigationController pushViewController:resetVc animated:YES];
}

- (void)changeBankCard:(NSString *)bankName ides:(NSString *)ides index:(NSInteger)index
{
    [self removePopView];
    _ides = ides;
    _index = index;
    [self loadBankInfo:index];
    
    _BankCardLabel.text = bankName;
    if (_isChangePayDetailView) {
        
        [self getQrCodeStatus];
    }
    
    
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
    _alertView.layer.cornerRadius = 5;
    _alertView.layer.masksToBounds = YES;
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
   
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(backBtn.frame), _alertView.frame.size.width,1)];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(_alertView.frame.size.width/2, CGRectGetMinY(backBtn.frame), 1,bankBtn.frame.size.height)];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_alertView addSubview:line1];
    [_alertView addSubview:line2];
    
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [goBind addTarget:self action:@selector(clickToBindCard) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:goBind];
    [_alertView addSubview:backBtn];
}
- (void)clickToBank:(UIButton *)sender{
    [self removePopView];
    BankListController *bankVc= [[BankListController alloc]init];
    [self.navigationController pushViewController:bankVc animated:YES];
}
- (void)clickToBack{
    [self removePopView];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickToBindCard
{
    [self removePopView];
    AddBankCardController *AddVc = [[AddBankCardController alloc]init];
    AddVc.isfirstBindCard = YES;
    [self.navigationController pushViewController:AddVc animated:YES];
}
//payDetailView代理
- (void)makeSurePay{
    [self removePopView];
    [self createCodePopView];
    
}
- (void)cancel
{
    [self beginTimer] ;
   [self removePopView];
}
//找回密码
- (void)findPwd{
    FindPasswordViewController *findVc = [[FindPasswordViewController alloc]init];
    findVc.phone = _bankListArray[_index][@"cardholder_phone"];
    [self.navigationController pushViewController:findVc animated:YES];
}
- (void)chooseBank{
    _isChangePayDetailView = YES;
    [self removePopView];
    [self clickToChooseBankCard:_bankNameBtn];
}

- (void)makeSureCode:(NSString *)pass{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"memberID",_qrDic[@"qrNo"],@"qrCode",pass,@"pwd",nil];
    
    [HttpClient requestWithMethod:@"GET" path:[Util makeRequestUrl:@"unionpay/BackTrans" tp:@"ConfirmPwd"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _codeDic = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self beginTimer];
            

            
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        
        
    }];
}
- (void)removePopView{
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
    [_bgView removeFromSuperview];
    _bgView = nil;
}
@end
