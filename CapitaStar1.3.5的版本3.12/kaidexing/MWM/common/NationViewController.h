//
//  NationViewController.h
//  ShouYi
//
//  Created by Hwang Kunee on 14-1-25.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "BaseViewController.h"
#import "MJNIndexView.h"
#import <QuartzCore/QuartzCore.h>


@interface NationViewController : BaseViewController

@property(nonatomic)int selectType;
@property(nonatomic)int parentId;
@property(nonatomic)NSString* parentName;
@property(nonatomic) NSDictionary* selectDic;

@end
