//
//  AddressModel.m
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
-(id) init{
    self = [super init];
    if(self){
        _add_date= @"";
        _address = @"";
        _area= @"";
        _city= @"";
        _email= @"";
        _id= @"";
        _isDefault= @"";
        _isInformation= @"";
        _member_id= @"";
        _name= @"";
        _post_code= @"";
        _province= @"";
        _telephone= @"";
        _update_date= @"";
        return self;
    }
    return nil;
}

@end
