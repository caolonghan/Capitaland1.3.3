//
//  uploadPicViewController.h
//  kaidexing
//
//  Created by company on 2017/8/29.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface uploadPicViewController : BaseViewController

@property(strong,nonatomic)NSDictionary* locationDic;
@property(copy,nonatomic) void(^back)(void);

@end
