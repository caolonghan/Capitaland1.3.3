//
//  IndexMallVM.h
//  kaidexing
//
//  Created by dwolf on 2017/5/27.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MwmBaseVM.h"
#import "MallInfoModel.h"
#import "CityMall.h"
#import "LocationModel.h"

@interface IndexMallVM : MwmBaseVM
//最近的商场
@property (nonatomic,readonly) MallInfoModel* nearMall;

@property (nonatomic,readonly) NSArray<MallInfoModel*>* recMalls;
@property (nonatomic,readonly) NSArray<CityMall*>* cityMalls;

-(void) getMallList:(LocationModel*) locModel;



@end
