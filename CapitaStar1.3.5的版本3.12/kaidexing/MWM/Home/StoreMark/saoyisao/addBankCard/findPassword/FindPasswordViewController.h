//
//  FindPasswordViewController.h
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface FindPasswordViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong)NSString *phone;
@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;


@end
