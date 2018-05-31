//
//  ShopCollectionViewCell.h
//  kaidexing
//
//  Created by companycn on 2018/5/21.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueBlock) (void);

@interface ShopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (nonatomic,strong)NSDictionary *shopDic;
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic,strong)NSString *shopId;
@end
