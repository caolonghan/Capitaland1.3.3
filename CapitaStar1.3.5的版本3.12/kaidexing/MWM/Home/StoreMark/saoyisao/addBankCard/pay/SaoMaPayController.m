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
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
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
@end

@implementation SaoMaPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"向商户付款";
    
    [self loadData];
    [self loadBankInfo];
    [self createView];
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
            [_imageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
            _moneyField.text =_codeInfoDic[@"txnAmt"];
            _nameLabel.text =_codeInfoDic[@"shopName"];
           
           
            
        });
    } failue:^(NSDictionary *dic) {
        [SVProgressHUD showErrorWithStatus:@"信息有误"];
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
    }];
    
}
//获取银行列表
- (void)loadBankInfo{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        _bankListArray = dic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            _ides = _bankListArray[0][@"ides"];
            
        });
        
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
       
        
    }];
}
//查询订单状态
- (void)getPayStatus:(NSString *)ides{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys: [Global sharedClient].member_id, @"member_id",[DES encryptUseDES: _codeInfoDic[@"txnNo"]],@"txnNo", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_unionpay_qrder_pay_status"] parameters:params target:self success:^(NSDictionary *dic) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"支付成功");
            
            
        });
    } failue:^(NSDictionary *dic) {
        
        
        NSString *cardNo =_bankListArray[0][@"card_no"];
        NSString *bankName = [NSString stringWithFormat:@"%@(%@)",_bankListArray[0][@"card_name"],[cardNo substringFromIndex:cardNo.length-4]];
        [self showPayDetailPopView:@"2322" bankName:bankName couponInfo:@"优惠"];
        //  [self getMarkingInfo:(nsstring];
    }];
}
//查询营销信息
- (void)getMarkingInfo:(NSString *)ides{
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
            NSString *cardNo =_bankListArray[0][@"card_no"];
            NSString *bankName = [NSString stringWithFormat:@"%@(%@)",_bankListArray[0][@"card_name"],[cardNo substringFromIndex:cardNo.length-4]];
          //  [self showPayDetailPopView:@"2322" bankName:bankName couponInfo:_markingInfoDic[@"couponInfo"]];
            
        });
    } failue:^(NSDictionary *dic) {
        [SVProgressHUD showErrorWithStatus:@"信息有误"];
        
      
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_bgView removeFromSuperview];
}
- (void)createView{
    
}

- (IBAction)Pay:(id)sender {
    
    
    NSString *txnNo = _codeInfoDic[@"txnNo"];
    [self getPayStatus:txnNo];
   
    
}
- (void)showPayDetailPopView:(NSString *)codeStyle bankName:(NSString *)bankName couponInfo:(NSString *)couponInfo
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
    _payDetailPopView.moneyLabel.text = _moneyField.text;
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

- (void)sureTapClick:(UITapGestureRecognizer *)tap
{
    UIView * view = tap.view;
    [view removeFromSuperview];
    [view removeGestureRecognizer:tap];
    
    
    
}
- (void)cancel
{
    [_payDetailPopView removeFromSuperview];
    [_codePopView removeFromSuperview];
    [_bgView removeFromSuperview];
    
}
-(void)chooseBank{
    [_payDetailPopView removeFromSuperview];
    _bankPopView = [[BankPopView alloc]initWithFrame:CGRectMake(0, (WIN_HEIGHT-264)/2, WIN_WIDTH, 264)];
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
            PaySuccessController *payVc = [[PaySuccessController alloc]init];
            payVc.moneyLabel.text = money;
            payVc.bankLabel.text  = _payDetailPopView.bankBtn.titleLabel.text;
            
            [self.navigationController pushViewController:payVc animated:YES];
            [_bgView removeFromSuperview];
        });
    } failue:^(NSDictionary *dic) {
        [SVProgressHUD showErrorWithStatus:@"信息有误"];
        
        
        
    }];
    
}

- (void)clickTocancel
{
    [_bankPopView removeFromSuperview];
    [_bgView removeFromSuperview];
    
}
- (void)addBankCard
{
    
    ResetPasswordViewController *resetVc= [[ResetPasswordViewController alloc]init];
    resetVc.type = 2;
    [self.navigationController pushViewController:resetVc animated:YES];
}
- (void)changeBankCard:(NSString *)bankName ides:(NSString *)ides{
    
    [_bgView removeFromSuperview];
    [_bankPopView removeFromSuperview];
    _ides = ides;
    [self getPayStatus:ides];
    [_payDetailPopView.bankBtn setTitle:bankName forState:UIControlStateNormal];
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


@end
