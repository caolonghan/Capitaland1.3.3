//
//  LocationModel.h
//  kaidexing
//
//  Created by dwolf on 2017/5/27.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MJSONModel.h"

@interface LocationModel : MJSONModel
@property (nonatomic,retain) NSString<Optional>* lat;
@property (nonatomic,retain) NSString<Optional>* lng;
@end
