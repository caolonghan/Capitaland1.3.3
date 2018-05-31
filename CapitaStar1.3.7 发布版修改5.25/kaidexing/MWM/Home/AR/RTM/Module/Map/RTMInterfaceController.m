//
//  RTMInterfaceController.m
//  CapitaLand
//
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import "RTMInterfaceController.h"

@interface RTMInterfaceController ()
@property (nonatomic, strong) NSString * defaultBuildingID;
@end

@implementation RTMInterfaceController

+ (instancetype)loadController:(NSString *)defaultBuildingID{
    RTMInterfaceController * controller = [[UIStoryboard storyboardWithName:@"RTM" bundle:nil] instantiateViewControllerWithIdentifier:@"RTMInterfaceController"];
    controller.defaultBuildingID = defaultBuildingID;
    return controller;
}

+ (instancetype)loadControllerWithDestinationPOI:(NSDictionary *)destinationPOI{
    RTMInterfaceController * controller = [[UIStoryboard storyboardWithName:@"RTM" bundle:nil] instantiateViewControllerWithIdentifier:@"RTMInterfaceController"];
    controller.destinationPOI = destinationPOI;
    return controller;
}

@end
