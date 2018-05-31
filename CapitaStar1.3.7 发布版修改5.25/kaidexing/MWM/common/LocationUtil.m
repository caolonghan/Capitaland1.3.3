//
//  LocationUtil.m
//  kaidexing
//
//  Created by dwolf on 16/5/25.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "LocationUtil.h"
#import "Const.h"

@implementation LocationUtil


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            NSString *currentCity = placeMark.locality;
            // ? placeMark.locality : placeMark.administrativeArea;
            if (!currentCity) {
                //currentCity = NSLocalizedString(@home_cannot_locate_city, comment:@无法定位当前城市);
                [_locDelegate locError:nil];
            }else{
                [_locDelegate afterLoc:currentCity loc:currentLocation];
            }
            
        } else if (error == nil && placemarks.count == 0) {
            [_locDelegate locError:nil];
            // NSLog(@No location and error returned);
        } else if (error) {
            
            if(_locDelegate != nil && [_locDelegate respondsToSelector:@selector(locError:)]){
                @try {
                    [_locDelegate locError:nil];
                } @catch (NSException *exception) {
                    NSLog(@"Location error: %@", exception);
                } @finally {
                    
                }
                
            }
            
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
}

//- (void)locate
//
//{
//    
//    // 判断定位操作是否被允许
//    
//    if([CLLocationManager locationServicesEnabled]) {
//        
//        self.locationManager = [[CLLocationManager alloc] init] ;
//        
//        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy=kCLLocationAccuracyKilometer;
//        
//        self.locationManager.distanceFilter=1000.0f;
//        if (IS_IOS_8) {
//            [self.locationManager  requestAlwaysAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
//        }
//        // 开始定位
//        [self.locationManager startUpdatingLocation];
//        
//    }else {
//        
//        //提示用户无法进行定位操作
//        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
//                                  
//                                  @"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        [alertView show];
//        if(_locDelegate != nil && [_locDelegate respondsToSelector:@selector(locError:)]){
//            [_locDelegate locError:nil];
//        }
//        
//    }
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
-(BOOL)isLocate{
    
    // 判断定位操作是否被允许
    BOOL isL;
    if([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyKilometer;
        
        self.locationManager.distanceFilter=1000.0f;
        if (IS_IOS_8) {
            [self.locationManager  requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
        isL=YES;
    }else {
        
        //提示用户无法进行定位操作
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  
                                  @"提示" message:@"定位不成功 ,请前往设置-隐私中开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        [alertView show];
        if(_locDelegate != nil && [_locDelegate respondsToSelector:@selector(locError:)]){
            [_locDelegate locError:nil];
        }
        
        isL=NO;
    }

    return isL;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    int type;
//    if (status != kCLAuthorizationStatusNotDetermined) {
//        type=0;
//        if (_locDelegate && [_locDelegate respondsToSelector:@selector(userLocChoice:)]) {
//            [_locDelegate userLocChoice:type];
//        }
//        
//    }
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
            {
                NSLog(@"用户还未决定授权");
                type=3;
//                if (_locDelegate && [_locDelegate respondsToSelector:@selector(userLocChoice:)]) {
//                    [_locDelegate userLocChoice:type];
//                }
                break;
            }
            case kCLAuthorizationStatusRestricted:
            {
                NSLog(@"访问受限");
                type=2;
                if (_locDelegate && [_locDelegate respondsToSelector:@selector(userLocChoice:)]) {
                    [_locDelegate userLocChoice:type];
                }
                break;
            }
            case kCLAuthorizationStatusDenied:
            {
                // 类方法，判断是否开启定位服务
                if ([CLLocationManager locationServicesEnabled]) {
                    NSLog(@"定位服务开启，被拒绝");
                    type=3;
                    if (_locDelegate && [_locDelegate respondsToSelector:@selector(userLocChoice:)]) {
                        [_locDelegate userLocChoice:type];
                    }
                } else {
                    NSLog(@"定位服务关闭，不可用");
                    type=4;
                    if (_locDelegate && [_locDelegate respondsToSelector:@selector(userLocChoice:)]) {
                        [_locDelegate userLocChoice:type];
                    }
                }
                break;
            }
            case kCLAuthorizationStatusAuthorizedAlways:
            {
                NSLog(@"获得前后台授权");
                type=5;
                if (_locDelegate && [_locDelegate respondsToSelector:@selector(userLocChoice:)]) {
                    [_locDelegate userLocChoice:type];
                }
                break;
            }
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {
                NSLog(@"获得前台授权");
                type=6;
                if (_locDelegate && [_locDelegate respondsToSelector:@selector(userLocChoice:)]) {
                    [_locDelegate userLocChoice:type];
                }
                break;
            }
            default:
                break;
        }
    
}


//计算两点距离
+ (CLLocationDistance)locationManager:(CLLocation *)current before:(CLLocation *)before {
    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:before];
    return meters;
}

@end
