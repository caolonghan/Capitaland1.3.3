//
//  ShowPayViewController.h
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface ShowPayViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *codeIamgeView2;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *BankCardLabel;
@property (weak, nonatomic) IBOutlet UIButton *bankNameBtn;


@property (nonatomic,assign)BOOL isBack;
@end
