//
//  FloorViewController.h
//  kaidexing
//
//  Created by dwolf on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseWebViewController.h"
#import "ConfirmPaymentView.h"
#import "AliManager.h"

@interface GoViewController : BaseWebViewController<ConfirmPayDelegate,AlimsgDelegata>
@property (strong,nonatomic)  NSString *path;
@property (nonatomic,assign)BOOL isParking;
@end
