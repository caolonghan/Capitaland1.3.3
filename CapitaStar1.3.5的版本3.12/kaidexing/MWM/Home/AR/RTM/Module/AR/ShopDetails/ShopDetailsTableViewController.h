//
//  ShopDetailsTableViewController.h
//  CapitaLand
//
//  Created by wang jinchang on 2017/10/17.
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTPOI.h"
@protocol ShopDetailsDelegate;
@interface ShopDetailsTableViewController : UITableViewController
@property (nonatomic,strong)RTPOI    *poi;
@property (nonatomic,strong)NSString *floor;
@property (nonatomic,weak) id<ShopDetailsDelegate>delegate;
@end


@protocol ShopDetailsDelegate <NSObject>
- (void)userTouchGoHere:(RTPOI*)poi;
@end
