//
//  SaoMaPayController.h
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface SaoMaPayController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)NSString *QrImageUrl;
@end
