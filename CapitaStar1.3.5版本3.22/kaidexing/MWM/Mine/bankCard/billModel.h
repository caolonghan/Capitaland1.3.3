//
//  billModel.h
//  kaidexing
//
//  Created by companycn on 2018/3/19.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface billModel : JSONModel
//member_id int default(0),--会员member_id
//reqType nvarchar(20),--交易类型
//comInfo nvarchar(200),--银行对账流水信息
//issCode nvarchar(50),--付款方机构代码
//orderNo nvarchar(50),--订单号
//respCode nvarchar(20),--应答码
//respMsg nvarchar(50),--响应信息
//status int default(0),--0-未支付，1-已支付
//type int default(0),--0-主动扫码，1-被动扫码
//qrCode nvarchar(200),--二维码
//origTxnAmt int default(0),--初始交易金额
//shopName nvarchar(100),--交易商户信息
//add_time datetime default(getdate())--添加时间


@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *txnTime;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *payCardType;

@end
