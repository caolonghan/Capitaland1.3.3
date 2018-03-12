//
//  UserInfo.h
//  kaidexing
//
//  Created by dwolf on 2017/5/6.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MModel.h"

@interface UserInfo : MModel

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *internalBaseClassIdentifier;
@property (nonatomic, assign) double integralcount;
@property (nonatomic, assign) double couponcount;
@property (nonatomic, assign) double message;
@property (nonatomic, strong) NSString *msgUrl;
@property (nonatomic, strong) NSString *memberIdDes;
@property (nonatomic, strong) NSString *birth;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) double phone;
@property (nonatomic, assign) double sex;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, assign) double source;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *capitalMemberCard;
@property (nonatomic, assign) double isOffice;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
