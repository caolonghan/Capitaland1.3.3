//
//  DES.h
//  kaidexing
//
//  Created by companycn on 2018/3/9.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"


@interface DES : NSObject

+(NSString *) encryptUseDES:(NSString *)plainText ;
@end
