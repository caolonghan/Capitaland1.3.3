//
//  SPARTarget.m
//  EasyAR3D
//
//  Created by Qinsi on 9/29/16.
//
//

#import "SPARTarget.h"

@implementation SPARTarget

static NSString *kTypeImage = @"image";

static NSString *kKeyTargetType = @"targetType";
static NSString *kKeyTargetDesc = @"targetDesc";
static NSString *kKeyImage = @"image";
static NSString *kKeyUId = @"uid";

+ (SPARTarget *)SPARTargetFromDict:(NSDictionary *)dict {
    NSString *targetType = dict[kKeyTargetType];
    NSDictionary *targetDesc = dict[kKeyTargetDesc];
    SPARTarget *res = [[SPARTarget alloc] initWithType:targetType andDesc:targetDesc];
    return res;
}

- (instancetype)initWithType:(NSString *)type andDesc:(NSDictionary *)desc {
    self = [super init];
    if (self) {
        self.type = type;
        self.desc = desc;
        if ([kTypeImage isEqualToString:type]) {
            self.url = desc[kKeyImage];
            self.uid = desc[kKeyUId];
        }
    }
    return self;
}

- (NSDictionary *)toDict {
    return @{
             kKeyTargetType: self.type,
             kKeyTargetDesc: self.desc,
             };
}

@end
