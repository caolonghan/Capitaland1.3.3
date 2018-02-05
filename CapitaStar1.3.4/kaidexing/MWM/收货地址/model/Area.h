//
//  Area.h
//  kaidexing
//
//  Created by dwolf on 2017/6/10.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MJSONModel.h"

@interface Area : MJSONModel
@property (nonatomic, readwrite, retain) NSString<Optional>* id;
@property (nonatomic, readwrite, retain) NSString<Optional>* name ;
@property (nonatomic, readwrite, retain) NSString<Optional>* type;
@property (nonatomic, readwrite, retain) NSString<Optional>* parent_id;
@end
