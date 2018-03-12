//
//  StoreDetailsController.h
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "MyNBTabController.h"
#import "ReScrollView.h"

@protocol rootIndex <NSObject>

-(void)setindex:(NSInteger)index;

-(void)createLocationPrompt:(NSDictionary*)dic type:(NSString*)typeStr;

@end


@interface StoreDetailsController : MyNBTabController<ZhuRefreshScrollView>
@property (nonatomic,strong)NSString *is_login_enter;
@property (assign,nonatomic)id<rootIndex>indexDedegate;

-(void)loadData;
- (void)loadAD;
@end
