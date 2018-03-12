//
//  UserInfo.m
//  kaidexing
//
//  Created by dwolf on 2017/5/6.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "UserInfo.h"


NSString *const kMModelAmount = @"Amount";
NSString *const kMModelId = @"id";
NSString *const kMModelIntegralcount = @"integralcount";
NSString *const kMModelCouponcount = @"couponcount";
NSString *const kMModelMessage = @"message";
NSString *const kMModelMsgUrl = @"msg_url";
NSString *const kMModelMemberIdDes = @"member_id_des";
NSString *const kMModelBirth = @"birth";
NSString *const kMModelNickName = @"nick_name";
NSString *const kMModelPhone = @"phone";
NSString *const kMModelSex = @"sex";
NSString *const kMModelImgUrl = @"img_url";
NSString *const kMModelSource = @"source";
NSString *const kMModelUsername = @"username";
NSString *const kMModelCapitalMemberCard = @"capital_member_card";
NSString *const kMModelIsOffice = @"is_office";


@interface UserInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation UserInfo

@synthesize amount = _amount;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize integralcount = _integralcount;
@synthesize couponcount = _couponcount;
@synthesize message = _message;
@synthesize msgUrl = _msgUrl;
@synthesize memberIdDes = _memberIdDes;
@synthesize birth = _birth;
@synthesize nickName = _nickName;
@synthesize phone = _phone;
@synthesize sex = _sex;
@synthesize imgUrl = _imgUrl;
@synthesize source = _source;
@synthesize username = _username;
@synthesize capitalMemberCard = _capitalMemberCard;
@synthesize isOffice = _isOffice;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.amount = [self objectOrNilForKey:kMModelAmount fromDictionary:dict];
        self.internalBaseClassIdentifier = [self objectOrNilForKey:kMModelId fromDictionary:dict];
        self.integralcount = [[self objectOrNilForKey:kMModelIntegralcount fromDictionary:dict] doubleValue];
        self.couponcount = [[self objectOrNilForKey:kMModelCouponcount fromDictionary:dict] doubleValue];
        self.message = [[self objectOrNilForKey:kMModelMessage fromDictionary:dict] doubleValue];
        self.msgUrl = [self objectOrNilForKey:kMModelMsgUrl fromDictionary:dict];
        self.memberIdDes = [self objectOrNilForKey:kMModelMemberIdDes fromDictionary:dict];
        self.birth = [self objectOrNilForKey:kMModelBirth fromDictionary:dict];
        self.nickName = [self objectOrNilForKey:kMModelNickName fromDictionary:dict];
        self.phone = [[self objectOrNilForKey:kMModelPhone fromDictionary:dict] doubleValue];
        self.sex = [[self objectOrNilForKey:kMModelSex fromDictionary:dict] doubleValue];
        self.imgUrl = [self objectOrNilForKey:kMModelImgUrl fromDictionary:dict];
        self.source = [[self objectOrNilForKey:kMModelSource fromDictionary:dict] doubleValue];
        self.username = [self objectOrNilForKey:kMModelUsername fromDictionary:dict];
        self.capitalMemberCard = [self objectOrNilForKey:kMModelCapitalMemberCard fromDictionary:dict];
        self.isOffice = [[self objectOrNilForKey:kMModelIsOffice fromDictionary:dict] doubleValue];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.amount forKey:kMModelAmount];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kMModelId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.integralcount] forKey:kMModelIntegralcount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.couponcount] forKey:kMModelCouponcount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.message] forKey:kMModelMessage];
    [mutableDict setValue:self.msgUrl forKey:kMModelMsgUrl];
    [mutableDict setValue:self.memberIdDes forKey:kMModelMemberIdDes];
    [mutableDict setValue:self.birth forKey:kMModelBirth];
    [mutableDict setValue:self.nickName forKey:kMModelNickName];
    [mutableDict setValue:[NSNumber numberWithDouble:self.phone] forKey:kMModelPhone];
    [mutableDict setValue:[NSNumber numberWithDouble:self.sex] forKey:kMModelSex];
    [mutableDict setValue:self.imgUrl forKey:kMModelImgUrl];
    [mutableDict setValue:[NSNumber numberWithDouble:self.source] forKey:kMModelSource];
    [mutableDict setValue:self.username forKey:kMModelUsername];
    [mutableDict setValue:self.capitalMemberCard forKey:kMModelCapitalMemberCard];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isOffice] forKey:kMModelIsOffice];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.amount = [aDecoder decodeObjectForKey:kMModelAmount];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kMModelId];
    self.integralcount = [aDecoder decodeDoubleForKey:kMModelIntegralcount];
    self.couponcount = [aDecoder decodeDoubleForKey:kMModelCouponcount];
    self.message = [aDecoder decodeDoubleForKey:kMModelMessage];
    self.msgUrl = [aDecoder decodeObjectForKey:kMModelMsgUrl];
    self.memberIdDes = [aDecoder decodeObjectForKey:kMModelMemberIdDes];
    self.birth = [aDecoder decodeObjectForKey:kMModelBirth];
    self.nickName = [aDecoder decodeObjectForKey:kMModelNickName];
    self.phone = [aDecoder decodeDoubleForKey:kMModelPhone];
    self.sex = [aDecoder decodeDoubleForKey:kMModelSex];
    self.imgUrl = [aDecoder decodeObjectForKey:kMModelImgUrl];
    self.source = [aDecoder decodeDoubleForKey:kMModelSource];
    self.username = [aDecoder decodeObjectForKey:kMModelUsername];
    self.capitalMemberCard = [aDecoder decodeObjectForKey:kMModelCapitalMemberCard];
    self.isOffice = [aDecoder decodeDoubleForKey:kMModelIsOffice];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_amount forKey:kMModelAmount];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kMModelId];
    [aCoder encodeDouble:_integralcount forKey:kMModelIntegralcount];
    [aCoder encodeDouble:_couponcount forKey:kMModelCouponcount];
    [aCoder encodeDouble:_message forKey:kMModelMessage];
    [aCoder encodeObject:_msgUrl forKey:kMModelMsgUrl];
    [aCoder encodeObject:_memberIdDes forKey:kMModelMemberIdDes];
    [aCoder encodeObject:_birth forKey:kMModelBirth];
    [aCoder encodeObject:_nickName forKey:kMModelNickName];
    [aCoder encodeDouble:_phone forKey:kMModelPhone];
    [aCoder encodeDouble:_sex forKey:kMModelSex];
    [aCoder encodeObject:_imgUrl forKey:kMModelImgUrl];
    [aCoder encodeDouble:_source forKey:kMModelSource];
    [aCoder encodeObject:_username forKey:kMModelUsername];
    [aCoder encodeObject:_capitalMemberCard forKey:kMModelCapitalMemberCard];
    [aCoder encodeDouble:_isOffice forKey:kMModelIsOffice];
}

- (id)copyWithZone:(NSZone *)zone
{
    UserInfo *copy = [[UserInfo alloc] init];
    
    if (copy) {
        
        copy.amount = [self.amount copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.integralcount = self.integralcount;
        copy.couponcount = self.couponcount;
        copy.message = self.message;
        copy.msgUrl = [self.msgUrl copyWithZone:zone];
        copy.memberIdDes = [self.memberIdDes copyWithZone:zone];
        copy.birth = [self.birth copyWithZone:zone];
        copy.nickName = [self.nickName copyWithZone:zone];
        copy.phone = self.phone;
        copy.sex = self.sex;
        copy.imgUrl = [self.imgUrl copyWithZone:zone];
        copy.source = self.source;
        copy.username = [self.username copyWithZone:zone];
        copy.capitalMemberCard = [self.capitalMemberCard copyWithZone:zone];
        copy.isOffice = self.isOffice;
    }
    
    return copy;
}
@end
