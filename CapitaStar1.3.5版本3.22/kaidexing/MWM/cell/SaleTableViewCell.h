//
//  SaleTableViewCell.h
//  kaidexing
//
//  Created by dwolf on 16/5/19.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
