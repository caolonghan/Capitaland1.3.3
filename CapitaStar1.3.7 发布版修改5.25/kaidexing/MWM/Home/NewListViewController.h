//
//  NewListViewController.h
//  kaidexing
//
//  Created by 朱巩拓 on 2016/10/27.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "ScreenViewController.h"

@interface NewListViewController : BaseViewController<screeViewDelegate>

@property (strong,nonatomic)NSString    *setInType;//不需要商场id登录  0 商户  1餐饮  2购物

@end
