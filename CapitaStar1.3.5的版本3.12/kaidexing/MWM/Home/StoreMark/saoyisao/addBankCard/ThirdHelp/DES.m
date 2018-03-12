//
//  DES.m
//  kaidexing
//
//  Created by companycn on 2018/3/9.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "DES.h"
const NSString *key = @"KDAPIKEY";
const Byte iv[] = {};
@implementation DES

+(NSString *) encryptUseDES:(NSString *)plainText 
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,[textData bytes], dataLength,
                                          buffer, 1024,&numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}


@end
