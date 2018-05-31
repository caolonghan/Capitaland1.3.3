//
//  CityViewController.h
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol cityDelegate <NSObject>

-(void)setCity:(id)cityTouch;

@end


@interface CityViewController : BaseViewController

@property (nonatomic,assign)id<cityDelegate>citdelegate;

@end
