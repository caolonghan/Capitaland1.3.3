//
//  SPARPreloadCache.m
//  EasyAR3D
//
//  Created by Qinsi on 10/24/16.
//
//

#import "SPARPreloadCache.h"
#import "SPARUtil.h"

@interface SPARPreloadCache()
@property (nonatomic, strong) NSMutableDictionary *preloads;
@end

@implementation SPARPreloadCache

static NSString *kPreloadCacheIndex = @"preload_cache_index";

+ (NSString *)getCacheIndexPath {
    NSString *supportDir = [SPARUtil getSupportDirectory];
    [SPARUtil ensureDirectory:supportDir];
    return [supportDir stringByAppendingPathComponent:kPreloadCacheIndex];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadCacheInfo];
    }
    return self;
}

- (void)loadCacheInfo {
    self.preloads = [NSMutableDictionary new];
    NSDictionary *saveDict = [SPARUtil jsonFromFile:[SPARPreloadCache getCacheIndexPath]];
    if (saveDict) {
        for (NSString *preloadID in saveDict) {
            NSString *preloadInfo = saveDict[preloadID];
            if (preloadID) {
                NSDictionary *preloadJSON = [SPARUtil jsonFromString:preloadInfo];
                if (preloadJSON) {
                    self.preloads[preloadID] = preloadJSON;
                }
            }
        }
    }
}

- (void)saveCacheInfo {
    NSMutableDictionary *saveDict = [NSMutableDictionary new];
    for (NSString *preloadID in self.preloads) {
        NSDictionary *preloadJSON = self.preloads[preloadID];
        saveDict[preloadID] = [SPARUtil stringFromJson:preloadJSON];
    }
    [SPARUtil writeToFile:[SPARPreloadCache getCacheIndexPath] fromJson:saveDict];
}

- (NSDictionary *)getPreloadJSON:(NSString *)preloadID {
    return self.preloads[preloadID];
}

- (void)updatePreloadJSON:(NSDictionary *)preloadJSON withID:(NSString *)preloadID {
    self.preloads[preloadID] = preloadJSON;
    [self saveCacheInfo];
}

- (void)clearCache {
    [self.preloads removeAllObjects];
    [self saveCacheInfo];
    [SPARUtil deleteQuietly:[SPARPreloadCache getCacheIndexPath]];
}

@end
