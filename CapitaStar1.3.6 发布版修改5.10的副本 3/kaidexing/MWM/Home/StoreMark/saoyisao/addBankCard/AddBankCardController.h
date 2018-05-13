//
//  AddBankCardController.h
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface AddBankCardController : BaseViewController
@property (nonatomic,assign)BOOL isfirstBindCard;
@property (nonatomic,strong)NSString *cardholderName;

@property (nonatomic,strong)NSString *certifTp;
@property (nonatomic,strong)NSString *cardHolderId;
@property (nonatomic,strong)NSString *cardType;

@property (nonatomic,strong)NSString *customerInfo;
@end
