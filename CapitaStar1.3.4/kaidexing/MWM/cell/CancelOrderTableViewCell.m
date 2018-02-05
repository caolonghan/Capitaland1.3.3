//
//  CancelOrderTableViewCell.m
//  kaidexing
//
//  Created by dwolf on 16/5/13.
//  Copyright (c) 2016年 dwolf. All rights reserved.
//

#import "CancelOrderTableViewCell.h"
#import "Const.h"

@implementation CancelOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _processBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _processBtn.layer.borderWidth = 1;
    _processBtn.layer.borderColor = BLACK_COLOR.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
