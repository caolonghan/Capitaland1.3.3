//
//  ShopTableViewCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "Const.h"

@implementation ShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lkdBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _lkdBtn.layer.borderColor = [UIColor redColor].CGColor;
    _lkdBtn.layer.borderWidth = 1;
    
    _rkdBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _rkdBtn.layer.borderColor = [UIColor redColor].CGColor;
    _rkdBtn.layer.borderWidth = 1;
    
    _lztBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _lztBtn.layer.borderColor = [UIColor redColor].CGColor;
    _lztBtn.layer.borderWidth = 1;
    
    _rztBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _rztBtn.layer.borderColor = [UIColor redColor].CGColor;
    _rztBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
