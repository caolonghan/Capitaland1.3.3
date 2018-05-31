//
//  BankCardView.h
//  kaidexing
//
//  Created by companycn on 2018/3/15.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCardView : UIView

@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UILabel *bankNameLabel;
@property (strong, nonatomic)UILabel *cardStyleLabel;
@property (strong, nonatomic)UILabel *cardNoLabel;

@property (nonatomic,strong)NSString *bankImageUrl;
@property (nonatomic,strong)NSString *bankName;
@property (nonatomic,strong)NSString *cardStyle;
@property (nonatomic,strong)NSMutableString *cardNo;
@end
