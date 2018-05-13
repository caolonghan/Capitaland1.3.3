//
//  NotLoggedInController.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/11/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@protocol NotDelegate <NSObject>

-(void)notLoadData;

@end

@interface NotLoggedInController : BaseViewController

@property (assign,nonatomic)id<NotDelegate>nDelegate;

@property (strong,nonatomic)NSString *setInType; //0是未登录  1 是有登录有返回按钮
//@property (copy, nonatomic)void(^back)(void);
@end
