//
//  MyApplicationViewController.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@protocol MyguanliDelegate <NSObject>

-(void)myguanliLoadData:(NSString*)pop;

@end

@interface MyApplicationViewController : BaseViewController

@property (strong,nonatomic)NSString *idStr;

@property (assign,nonatomic)id<MyguanliDelegate>mDelegate;

@property (strong,nonatomic)NSString *building_idStr;//建筑id

@end
