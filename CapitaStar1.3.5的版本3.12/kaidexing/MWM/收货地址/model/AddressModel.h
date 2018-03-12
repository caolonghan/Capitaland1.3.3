//
//  AddressModel.h
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MJSONModel.h"

@interface AddressModel : MJSONModel
@property (nonatomic, readwrite, retain) NSString<Optional>* add_date;
@property (nonatomic, readwrite, retain) NSString<Optional>* address ;
@property (nonatomic, readwrite, retain) NSString<Optional>* area;
@property (nonatomic, readwrite, retain) NSString<Optional>* city;
@property (nonatomic, readwrite, retain) NSString<Optional>* email;
@property (nonatomic, readwrite, retain) NSString<Optional>* id;
@property (nonatomic, readwrite, retain) NSString<Optional>* isDefault;
@property (nonatomic, readwrite, retain) NSString<Optional>* isInformation;
@property (nonatomic, readwrite, retain) NSString<Optional>* member_id;
@property (nonatomic, readwrite, retain) NSString<Optional>* name;
@property (nonatomic, readwrite, retain) NSString<Optional>* post_code;
@property (nonatomic, readwrite, retain) NSString<Optional>* province;
@property (nonatomic, readwrite, retain) NSString<Optional>* telephone;
@property (nonatomic, readwrite, retain) NSString<Optional>* update_date;
@end
