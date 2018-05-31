//
//  SPARAppCache.h
//  EasyAR3D
//
//  Created by Qinsi on 9/29/16.
//
//

#import <Foundation/Foundation.h>

@class SPARApp;

@interface SPARAppCache : NSObject

- (SPARApp *)getAppByARID:(NSString *)arid;
- (SPARApp *)getAppByTargetDesc:(NSString *)targetDesc;
- (NSString *)getLocalPathForURL:(NSString *)url;
- (NSInteger)getAppLastUpdateTime:(NSString *)arid;
- (void)updateApp:(SPARApp *)app;
- (void)clearCache;

@end
