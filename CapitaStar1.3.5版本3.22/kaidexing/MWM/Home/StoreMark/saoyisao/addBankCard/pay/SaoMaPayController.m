//
//  SaoMaPayController.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "SaoMaPayController.h"
#import "PayDetailPopView.h"
#import "BankPopView.h"
#import "CodePopView.h"
#import "PaySuccessController.h"
#import "AddBankCardController.h"
#import "ResetPasswordViewController.h"
#import "FindPasswordViewController.h"
#import "BankListController.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import "AppDelegate.h"
#import "DES.h"

@interface SaoMaPayController ()<PayDetailPopViewDelegate,CodePopViewDelegate,BankPopViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)PayDetailPopView *payDetailPopView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)CodePopView *codePopView;
@property (nonatomic,strong)BankPopView *bankPopView;
@property (nonatomic,strong)NSDictionary *codeInfoDic;
@property (nonatomic,strong)NSArray *bankListArray;
@property (nonatomic,strong)NSDictionary *markingInfoDic;
@property (nonatomic,strong)NSString *ides;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)NSString *conponInfo;
@end

@implementation SaoMaPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"向商户付款";
    _index = 0;
    [self loadData];
    [self loadBankInfo:_index];
    [self createView];
    [Global sharedClient].bindCardBackWhere = 0;
    [Global sharedClient].resetPwdBackWhere = 0;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _index = 0;
    [self loadBankInfo:_index];
   
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removePopView];
}
-(NSDictionary *)codeInfoDic{
    if (!_codeInfoDic) {
        _codeInfoDic = [NSDictionary dictionary];
    }
    return _codeInfoDic;
}
- (NSArray *)bankListArray{
    if (!_bankListArray) {
        _bankListArray = [NSArray array];
    }
    return _bankListArray;
}
- (NSDictionary *)markingInfoDic{
    if (!_markingInfoDic) {
        _markingInfoDic = [NSDictionary dictionary];
    }
    return _markingInfoDic;
}
//扫码获取订单信息
- (void)loadData{
//Data:对象操作结果说明
//    currencyCode：交易币种
//    orderNo：订单号
//    orderType：订单类型
//    payeeInfo：收款方信息，用于收款
//    paymentValidTime：支付有效时间
//    respCode：应答码
//    respMsg：应答信息
//    txnAmt：交易金额
//    txnNo：交易序列号，用于支付

    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",[DES encryptUseDES: _QrImageUrl],@"qr_code", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_unionpay_qr_code_order_info"] parameters:params target:self success:^(NSDictionary *dic) {
        _codeInfoDic = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *money = [NSString stringWithFormat:@"%@",_codeInfoDic[@"txnAmt"]];
            _moneyField.text =money;
            _nameLabel.text =_codeInfoDic[@"shopName"];
           
           
            
        });
    } failue:^(NSDictionary *dic) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
    }];
    
}
//获取银行列表
- (void)loadBankInfo:(NSInteger)index{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _bankListArray = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            _ides = _bankListArray[index][@"ides"];
            
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
       
        
    }];
}

//查询订单状态
- (void)getPayStatus{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",[DES encryptUseDES: _codeInfoDic[@"txnNo"]],@"txnNo", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_unionpay_qrder_pay_status"] parameters:params target:self success:^(NSDictionary *dic) {
       NSLog(@"%@",dic);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD  showSuccessWithStatus:@"支付成功"];
            PaySuccessController *payVc = [[PaySuccessController alloc]init];
            payVc.money = _payDetailPopView.moneyLabel.text;
            payVc.bankName  = _payDetailPopView.bankBtn.titleLabel.text;
            
            [self.navigationController pushViewController:payVc animated:YES];
            
        });
    } failue:^(NSDictionary *dic) {
        
        NSLog(@"%@",dic[@"msg"]);
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
    }];
}
//查询营销信息
- (void)getMarkingInfo:(NSString *)ides index:(NSInteger)index {
//    {member_id}：会员编号（凯德星2.0提供）
//    {txnNo}：交易序列号（需要DESEncrypt加密）
//    {txnAmt}：交易金额
//    {currencyCode}：交易币种
//    {unionpay_id}：绑卡主键，直接拉取绑卡列表的加密主键
//    {deviceID}：设备标识，参考值：123456999
//    {deviceType}：设备类型，参考值：1
//    {accountIdHash}：accountIdHash，参考值：00000002
//    {sourceIP}：IP，设备IP
//    {payeeInfo}：收款方信息
    NSString *money =_moneyField.text;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",money ,@"txnAmt",[DES encryptUseDES:_codeInfoDic[@"txnNo"]],@"txnNo",_codeInfoDic[@"currencyCode"],@"currencyCode",ides,@"unionpay_id",[[NSBundle mainBundle] bundleIdentifier],@"deviceID",@"1",@"deviceType",[Global sharedClient].member_id,@"accountIdHash",[self getDeviceIPIpAddresses],@"sourceIP",_codeInfoDic[@"payeeInfo"],@"payeeInfo",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_unionpay_qrder_marketing_info"] parameters:params target:self success:^(NSDictionary *dic) {
        _markingInfoDic = dic[@"Data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"支付成功");
            NSString *cardNo =_bankListArray[index][@"card_no"];
            NSString *bankName = [NSString stringWithFormat:@"%@(%@)",_bankListArray[index][@"card_name"],[cardNo substringFromIndex:cardNo.length-4]];
           [self showPayDetailPopView:@"商户消费" bankName:bankName couponInfo:_markingInfoDic[@"couponInfo"]];
            
        });
    } failue:^(NSDictionary *dic) {
        NSLog(@"%@",dic[@"msg"]);
        NSString *cardNo =_bankListArray[index][@"card_no"];
        NSString *bankName = [NSString stringWithFormat:@"%@(%@)",_bankListArray[index][@"card_name"],[cardNo substringFromIndex:cardNo.length-4]];
          [self showPayDetailPopView:@"商户消费" bankName:bankName couponInfo:@"无"];
        
    }];
}

- (void)createView{
    
}

- (IBAction)Pay:(id)sender {
    
    
    NSString *txnNo = _codeInfoDic[@"txnNo"];
   
    [self getMarkingInfo:txnNo index:_index];
   
}
- (void)showPayDetailPopView:(NSString *)codeStyle bankName:(NSString *)bankName couponInfo:(NSString *)couponInfo
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
    _payDetailPopView.money= _moneyField.text;
    _payDetailPopView.delegate = self;
    
    
    _payDetailPopView.frame = CGRectMake(0, WIN_HEIGHT-346, WIN_WIDTH, 346);
    [_bgView addSubview:_payDetailPopView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_payDetailPopView]||[touch.view isDescendantOfView:_bankPopView]||[touch.view isDescendantOfView:_codePopView]) {
        return NO;
    }
   
    return YES;
}

- (void)sureTapClick:(UITapGestureRecognizer *)tap
{
    [self removePopView];
    
}
- (void)cancel
{
   
    [self removePopView];
    
}
-(void)chooseBank{
    [_payDetailPopView removeFromSuperview];
    _bankPopView = [[BankPopView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-264, WIN_WIDTH, 264) index:_index];
    _bankPopView.delegate = self;
    [_bgView addSubview:_bankPopView];
    
}

- (void)makeSurePay
{
    
    [_payDetailPopView removeFromSuperview];
    _codePopView = [[CodePopView alloc]initWithFrame:CGRectMake(0, WIN_HEIGHT/2-100, WIN_WIDTH, 200)];
    _codePopView.delegate = self;
    [_bgView addSubview:_codePopView];
    
    
}
//找回密码
- (void)findPwd{
    FindPasswordViewController *findVc = [[FindPasswordViewController alloc]init];
    findVc.phone = _bankListArray[_index][@"cardholder_phone"];
    [self.navigationController pushViewController:findVc animated:YES];
}
//最终付款
- (void)makeSureCode:(NSString *)pass
{
//    {member_id}：会员编号（凯德星2.0提供）
//    {txnNo}：交易序列号（需要DESEncrypt加密）
//    {txnAmt}：交易金额
//    {currencyCode}：交易币种
//    {unionpay_id}：绑卡主键，直接拉取绑卡列表的加密主键
//    {deviceID}：设备标识，参考值：123456999
//    {deviceType}：设备类型，参考值：1
//    {accountIdHash}：accountIdHash，参考值：00000002
//    {sourceIP}：IP，设备IP
//    {payeeInfo}：收款方信息
//    {couponInfo}：优惠信息，通过查询营销接口获取，没有就传空值
//    {pay_pwd}：支付密码（需要DESEncrypt加密）
    NSString *money = _moneyField.text;
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id,@"member_id",[DES encryptUseDES:_codeInfoDic[@"txnNo"]],@"txnNo",money,@"txnAmt",_codeInfoDic[@"currencyCode"],@"currencyCode",_ides,@"unionpay_id",[[NSBundle mainBundle] bundleIdentifier],@"deviceID",@"1",@"deviceType",[Global sharedClient].member_id,@"accountIdHash",[self getDeviceIPIpAddresses],@"sourceIP",_codeInfoDic[@"payeeInfo"],@"payeeInfo",_markingInfoDic[@"couponInfo"], @"couponInfo",pass,@"pay_pwd",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"unionpay_order_pwd_pay_money"] parameters:params target:self success:^(NSDictionary *dic) {
        _markingInfoDic = dic[@"Data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"支付成功");
            [self getPayStatus];
           
        });
    } failue:^(NSDictionary *dic) {
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
    
    }];
    
}

- (void)clickTocancel
{
    [self removePopView];
    
}
- (void)addBankCard
{
    
    ResetPasswordViewController *resetVc= [[ResetPasswordViewController alloc]init];
    resetVc.type = 2;
    [self.navigationController pushViewController:resetVc animated:YES];
}
- (void)changeBankCard:(NSString *)bankName ides:(NSString *)ides index:(NSInteger)index{
    
    [self removePopView];
    _index = index;
    _ides = ides;

    [self getMarkingInfo:ides index:index];
}

//获取ip地址
- (NSString *)getDeviceIPIpAddresses

{
    
    int sockfd =socket(AF_INET,SOCK_DGRAM, 0);
    
    //    if (sockfd <</span> 0) return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    
    
    int BUFFERSIZE =4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len =sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
            
            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
            
            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
            
            
            
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    
    
    
    
    
    NSString *deviceIP =@"";
    
    for (int i=0; i < ips.count; i++)
        
    {
        
        if (ips.count >0)
            
        {
            
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
            
            
        }
        
    }
    
    NSLog(@"deviceIP========%@",deviceIP);
    return deviceIP;
    
}
- (void)removePopView{
    for (UIView *view in _bgView.subviews) {
        [view removeFromSuperview];
    }
    [_bgView removeFromSuperview];
    _bgView = nil;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_moneyField resignFirstResponder];
}
@end
