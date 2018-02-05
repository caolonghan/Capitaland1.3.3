//
//  SPARAppCache.m
//  EasyAR3D
//
//  Created by Qinsi on 9/29/16.
//
//

#import "SPARAppCache.h"
#import "SPARApp.h"
#import "SPARTarget.h"
#import "SPARUtil.h"
#import "Downloader.h"

@interface SPARAppCache()
@property (nonatomic, strong) NSMutableDictionary *appsByARID;
@property (nonatomic, strong) NSMutableDictionary *appsByTargetUID;
@end

@implementation SPARAppCache

static NSString *kCacheIndex = @"cache_index";
static NSString *kPackageURL = @"packageURL";
static NSString *kTimestamp = @"timestamp";

+ (NSString *)getCacheIndexPath {
    NSString *supportDir = [SPARUtil getSupportDirectory];
    [SPARUtil ensureDirectory:supportDir];
    return [supportDir stringByAppendingPathComponent:kCacheIndex];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadCacheInfo];
    }
    return self;
}

- (void)updateAppTargetIndex:(SPARApp *)app {
    SPARTarget *target = app.target;
    if (target) {
        self.appsByTargetUID[target.uid] = app;
    }
}

- (void)loadCacheInfo {
    self.appsByARID = [NSMutableDictionary new];
    NSData *jsonData = [NSData dataWithContentsOfFile:[SPARAppCache getCacheIndexPath]];
    if (jsonData) {
        NSError *error;
        NSDictionary *saveDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) {
            NSLog(@"Error: %@", error);
        }

        if (saveDict) {
            for (NSString *arid in saveDict) {
                self.appsByARID[arid] = [SPARApp SPARAppFromDict:saveDict[arid]];
            }
        }
    }

    self.appsByTargetUID = [NSMutableDictionary new];
    for (NSString *arid in self.appsByARID) {
        SPARApp *app = self.appsByARID[arid];
        [self updateAppTargetIndex:app];
    }
}

- (void)saveCacheInfo {
    NSMutableDictionary *saveDict = [NSMutableDictionary new];
    for (NSString *arid in self.appsByARID) {
        SPARApp *app = self.appsByARID[arid];
        saveDict[arid] = [app toDict];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:saveDict options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }

    [jsonData writeToFile:[SPARAppCache getCacheIndexPath] atomically:YES];
}

- (NSString *)getLocalPathForURL:(NSString *)url {
    for (NSString *arid in self.appsByARID) {
        SPARApp *app = self.appsByARID[arid];
        SPARTarget *target = app.target;
        if (target && [url isEqualToString:target.url]) return [app getLocalPathForTargetURL];

        NSString *res = [app getLocalPathForPackageFileURL:url];
        if (res) return res;
    }
    return nil;
}

- (SPARApp *)getAppByARID:(NSString *)arid {
    return self.appsByARID[arid];
}

- (SPARApp *)getAppByTargetUID:(NSString *)targetUID {
    return self.appsByTargetUID[targetUID];
}

- (SPARApp *)getAppByTargetDesc:(NSString *)targetDesc {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[targetDesc dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:kNilOptions
                                                           error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    NSString *targetUID = json[@"images"][0][@"uid"];
    return [self getAppByTargetUID:targetUID];
}

- (NSInteger)getAppLastUpdateTime:(NSString *)arid {
    SPARApp *app = [self getAppByARID:arid];
    if (!app) return 0;
    return app.timestamp;
}

- (void)updateApp:(SPARApp *)app {
    NSString *arid = app.ARID;
    self.appsByARID[arid] = app;
    [self updateAppTargetIndex:app];
    [self saveCacheInfo];
}

- (void)clearCache {
    [self.appsByARID removeAllObjects];
    [self.appsByTargetUID removeAllObjects];
    [self saveCacheInfo];
    [SPARUtil deleteQuietly:[SPARAppCache getCacheIndexPath]];
}

@end
