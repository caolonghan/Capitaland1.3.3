//
//  AddrListCell.h
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddrListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImgView;
@property (weak, nonatomic) IBOutlet UIImageView *noDefaultImgView;
@property (weak, nonatomic) IBOutlet UIImageView *editImgView;
@property (weak, nonatomic) IBOutlet UIImageView *delImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeadConst;

@end
