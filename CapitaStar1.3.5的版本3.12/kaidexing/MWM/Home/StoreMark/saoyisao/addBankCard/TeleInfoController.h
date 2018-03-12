//
//  TeleInfoController.h
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface TeleInfoController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *errorBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;


//请求参数
//member_id}：会员编号（凯德星2.0提供）
//{card_name}：银行卡名称（需要DESEncrypt加密）
//{card_no}：卡号（需要DESEncrypt加密）
//{card_type}：卡类型(01：借记卡 02：贷记卡（含准贷记卡）)（需要DESEncrypt加密）
//{cardholder_name}：持卡人姓名（需要DESEncrypt加密）
//{certif_tp}：证件类型 01：身份证 02：军官证 03：护照 04：回乡证 05：台胞证 06：警官证 07：士兵证 99：其它证件（需要DESEncrypt加密）
//{cardholder_id}：持卡人证件号码（需要DESEncrypt加密）
//{cardholder_phone}：手机号（需要DESEncrypt加密）
//{cvn2}：银联卡后三位数字（信用卡）（需要DESEncrypt加密）
//{expired_year}：有效期年份（信用卡）（需要DESEncrypt加密）
//{expired_month}：有效期月份（信用卡）（需要DESEncrypt加密）
//{sms_code}：短信验证码（需要DESEncrypt加密）

//参数
@property (nonatomic,strong)NSString *cardType;
@property (nonatomic,strong)NSString *cardName;
@property (nonatomic,strong)NSString *cardNum;
@property (nonatomic,strong)NSString *cardHolderName;
@property (nonatomic,strong)NSString *certifTp;
@property (nonatomic,strong)NSString *cardHolderId;
@property (nonatomic,strong)NSString *cardHolderPhone;
@property (nonatomic,strong)NSString *CVN2;
@property (nonatomic,strong)NSString *expiredYear;
@property (nonatomic,strong)NSString *expiredMonth;
@property (nonatomic,strong)NSString *customerInfo;
@end
