//
//  AppDelegate.h
//  IOS8Frame
//
//  Created by dwolf on 14-9-17.
//  Copyright (c) 2014年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
//#import "RTLbsMapManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{//RTLbsVerifyDelegate
    NSString* wbtoken;
    NSString* remindDayId;
    UINavigationController* navigationController;
    int dayType;
    BOOL _enterForeground;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
@property (nonatomic)BOOL enterForeground;
@end

