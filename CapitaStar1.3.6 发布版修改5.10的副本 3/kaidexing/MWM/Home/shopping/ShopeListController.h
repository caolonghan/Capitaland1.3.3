//
//  AddShoppingController.h
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@protocol guanzhuTouch <NSObject>

-(void)setguanzhu:(id)sender;

@end


@interface ShopeListController : BaseViewController

@property (assign,nonatomic)id<guanzhuTouch>guanzhuDelegate;

@end
