//
//  CityMall.h
//  kaidexing
//
//  Created by dwolf on 2017/5/27.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MJSONModel.h"
#import "MallInfoModel.h"

@interface CityMall : MJSONModel
@property(nonatomic,retain) NSNumber<Optional>* adcity_iddress ;
@property(nonatomic,retain) NSString<Optional>* city_name;
@property(nonatomic,retain) NSArray<MallInfoModel*><Optional>*mall_list;
@end
