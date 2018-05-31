//
//  ShopCollectionViewCell.m
//  kaidexing
//
//  Created by companycn on 2018/5/21.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "ShopCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickZan:(id)sender {
    
    self.returnValueBlock();
   
    
}

@end
