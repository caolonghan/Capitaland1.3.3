//
//  ChooseStyleTableViewCell.h
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol bankCardStyleDelegate <NSObject>
-(void)chooseBankCardStyle;
@end
@interface ChooseStyleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak)id<bankCardStyleDelegate>delegate;
@end
