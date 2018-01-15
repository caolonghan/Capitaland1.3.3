//
//  AddrListCell.m
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "AddrListCell.h"
#import "Const.h"

@implementation AddrListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _defaultLabel.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    _defaultLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
