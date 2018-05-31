//
//  IndoorMapController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/7/28.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "RTLbsMapView.h"
//#import "RTLbsBuildInfo.h"
//#import "RTLbsWebService.h"
//@interface IndoorMapController : BaseViewController<RTLbsMapViewDelegate,RTLbsWebServiceDelegate>
@interface IndoorMapController : BaseViewController
@property (strong,nonatomic)NSString *myBuildString;//当前建筑物Id
@property (strong,nonatomic)NSString *myFloorId;//当前楼层Id
@property (strong,nonatomic)NSString *shopName;//当前楼层商户标注

@end
