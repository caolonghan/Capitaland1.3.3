//
//  LocationUtil.h
//  kaidexing
//
//  Created by dwolf on 16/5/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol LocationDelegate <NSObject>
@optional
-(void) afterLoc:(NSString*) city loc:(CLLocation*)loc;

-(void) locError:(NSString*) city;

-(void) userLocChoice:(int)type; // 0 已选择 1用户还未决定授权  2访问受限 3定位服务开启，被拒绝 4定位服务关闭，不可用  5授予权限  6限时授予权限

@end
@interface LocationUtil : NSObject<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) id <LocationDelegate> locDelegate;
//- (void)locate;
-(BOOL)isLocate;

//计算两点距离
+ (CLLocationDistance)locationManager:(CLLocation *)current before:(CLLocation *)before;
@end
