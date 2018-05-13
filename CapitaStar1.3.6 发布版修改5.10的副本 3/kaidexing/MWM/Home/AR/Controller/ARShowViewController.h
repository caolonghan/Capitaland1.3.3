//
//  ARShowViewController.h
//  sightpDemo
//
//  Created by YangTengJiao on 16/9/22.
//  Copyright © 2016年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "easyar3d/EasyARSceneController.h"
#define ARAppKey @"8c4bf3bc5d7c13e6c181cc33acaffef6"
#define ARAppSecret @"c4e7955d57213d0b032d073b11074d1d35ec065cfa2482bff0484a0a28ce3afe"

@interface ARShowViewController : EasyARSceneController

@property (nonatomic, strong) NSString* mall_id;//商场ID
@property (nonatomic, strong) NSString* member_id;//人员ID

@end
