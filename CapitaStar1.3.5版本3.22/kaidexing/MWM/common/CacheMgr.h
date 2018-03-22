//
//  SmartCacheMgr.h
//  SurfingShare
//
//  Created by Hwang Kunee on 13-7-15.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface CacheMgr : NSObject

+ (void)removeFromDiskAll;

+ (void)removeFromDisk:(NSString*) key;

+ (void) saveToDisk:(NSObject*) value key:(NSString*) key;

+ (NSObject*) readFromDisk:(NSString*) key clazz:(Class) clazz;

+ (void)saveToDisk:(NSObject*) value key:(NSString*) key second:(int) second;

@end
