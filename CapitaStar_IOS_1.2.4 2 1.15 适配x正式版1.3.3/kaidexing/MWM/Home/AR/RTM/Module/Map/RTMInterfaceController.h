//
//  RTMInterfaceController.h
//  CapitaLand
//
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 模块入口类
 */

@interface RTMInterfaceController : UINavigationController
@property (nonatomic, strong, readonly) NSString * defaultBuildingID;
@property (nonatomic, strong) NSDictionary * destinationPOI;

/*
 加载目的地
 destinationPOI字典key
 buildingID建筑物ID
 floorID楼层ID
 name商铺名称
 */
+ (instancetype)loadControllerWithDestinationPOI:(NSDictionary *) destinationPOI;

+ (instancetype)loadController:(NSString *) defaultBuildingID;
@end
