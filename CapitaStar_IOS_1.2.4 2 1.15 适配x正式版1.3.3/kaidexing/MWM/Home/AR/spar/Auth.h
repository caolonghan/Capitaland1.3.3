//
//  Auth.h
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import <Foundation/Foundation.h>

@interface Auth : NSObject

+ (NSString *)sha1Hex:(NSString *)str;
+ (NSString *)generateSignature:(NSDictionary *)param withSecret:(NSString *)secret;
+ (NSDictionary *)signParam:(NSDictionary *)param withKey:(NSString *)key andSecret:(NSString *)secret;

@end
