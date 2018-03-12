//
//  MalllistViewController.h
//  kaidexing
//
//  Created by company on 2017/8/30.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "BaseViewController.h"

@interface MalllistViewController : BaseViewController

@property(nonatomic,copy)void(^autoLoc)();
@property(nonatomic,copy)void(^getInAR)();
@property(nonatomic,assign)BOOL shouldPost;
@property (nonatomic,assign)NSInteger type;
@end
