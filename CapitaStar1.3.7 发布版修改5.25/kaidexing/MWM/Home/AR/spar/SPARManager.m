//
//  SPARManager.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import "SPARManager.h"
#import "SPARApp.h"
#import "Auth.h"
#import "JSONLoader.h"
#import "SPARAppCache.h"
#import "SPARPreloadCache.h"
#import "SPARUtil.h"
#import "SPARTarget.h"
#import "Downloader.h"

@interface SPARManager()
@property (nonatomic, strong) NSString *serverAddr;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;
@property (nonatomic, strong) SPARAppCache *cache;
@property (nonatomic, strong) SPARPreloadCache *preloadCache;
@end

@implementation SPARManager

static NSString *kStatusCode = @"statusCode";
static NSString *kResult = @"result";
static NSString *kMessage = @"message";
static NSString *kInfo = @"info";
static NSString *kTimestamp = @"timestamp";
static NSString *kScene = @"scene";
static NSString *kPackage = @"package";

static NSString *kApps = @"apps";
static NSString *kARID = @"arid";
static NSString *kPackageURL = @"packageURL";
static NSString *kTargetType = @"targetType";
static NSString *kTargetDesc = @"targetDesc";

static NSString *kPackagePath = @"/mobile/info/";
static NSString *kPreloadPath = @"/mobile/preload/";

+ (instancetype)sharedManager {
    static SPARManager *inst = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [SPARManager new];
    });
    return inst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [SPARAppCache new];
        self.preloadCache = [SPARPreloadCache new];
    }
    return self;
}

- (void)setServerAddress:(NSString *)addr {
    self.serverAddr = addr;
}

- (void)setServerAccessTokens:(NSString *)key secret:(NSString *)secret {
    self.appKey = key;
    self.appSecret = secret;
}

- (NSString *)getLocalPathForURL:(NSString *)url {
    return [self.cache getLocalPathForURL:url];
}

- (void)clearCache {
    [self.cache clearCache];
    [self.preloadCache clearCache];
    [SPARUtil deleteQuietly:[Downloader getDownloadPath:[Downloader packagesPath]]];
    [SPARUtil deleteQuietly:[Downloader getDownloadPath:[Downloader targetsPath]]];
}

- (void)loadApp:(NSString *)arid
completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self loadApp:arid force:NO completionHandler:completionHandler progressHandler:progressHandler];
}

- (void)loadApp:(NSString *)arid force:(bool)force
          completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self loadApp:arid key:self.appKey secret:self.appSecret force:force
            completionHandler:completionHandler progressHandler:progressHandler];
}

- (bool)tryFromCache:(NSString *)arid force:(bool)force
      completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler {
    SPARApp *app = [self.cache getAppByARID:arid];
    if (app && !force) {
        completionHandler(app, nil);
        return YES;
    }
    return NO;
}

- (void)loadApp:(NSString *)arid key:(NSString *)key secret:(NSString *)secret force:(bool)force
          completionHandler:(void (^)(SPARApp *app, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {

    NSDictionary *params = [Auth signParam:[NSDictionary new] withKey:key andSecret:secret];
    NSString *endPoint = [self.serverAddr stringByAppendingFormat:@"%@%@", kPackagePath, arid];
    NSString *urlStr = [SPARUtil addQueryParam:params toURL:endPoint];
    [JSONLoader loadFromURL:urlStr completionHandler:^(NSDictionary *jso, NSError *err) {
        if (err) {
            if (![self tryFromCache:arid force:force completionHandler:completionHandler]) {
                completionHandler(nil, err);
            }
            return;
        }
        NSInteger statusCode = [jso[kStatusCode] integerValue];
        if (statusCode != 0) {
            NSString *msg = jso[kResult][kMessage];
            if (!msg) msg = @"non zero status code";
            completionHandler(nil, [NSError errorWithDomain:msg code:statusCode userInfo:nil]);
            return;
        }
        NSDictionary *info = jso[kResult][kInfo];
        NSInteger timestamp = [info[kTimestamp] integerValue];
        NSString *pkgURL = info[kScene][kPackage];
        if (timestamp <= [self.cache getAppLastUpdateTime:arid] && !force) {
            completionHandler([self.cache getAppByARID:arid], nil);
            return;
        }
        SPARApp *app = [[SPARApp alloc] initWithARID:arid URL:pkgURL timestamp:timestamp];
        [app deployPackage:YES completionHandler:^(NSError *error) {
            if (error) {
                completionHandler(nil, error);
            } else {
                [self.cache updateApp:app];
                completionHandler(app, nil);
            }
        } progressHandler:progressHandler];
    } progressHandler:progressHandler];
}

- (void)preloadApps:(NSString *)preloadID
  completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
    progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self preloadApps:preloadID force:NO completionHandler:completionHandler progressHandler:progressHandler];
}

- (void)preloadApps:(NSString *)preloadID force:(bool)force
 completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
   progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    [self preloadApps:preloadID key:self.appKey secret:self.appSecret force:force
   completionHandler:completionHandler progressHandler:progressHandler];
}

- (void)preloadAppsFromJSON:(NSDictionary *)jso force:(bool)force
          completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    NSArray *jsa = jso[kResult][kApps];
    NSArray *apps = [self appsFromJSONArray:jsa];
    [self preloadAppsInList:apps force:force completionHandler:completionHandler progressHandler:progressHandler];
}

- (bool)tryPreloadFromCache:(NSString *)preloadID force:(bool)force
          completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
            progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    NSDictionary *preloadJSON = [self.preloadCache getPreloadJSON:preloadID];
    if (preloadJSON && !force) {
        [self preloadAppsFromJSON:preloadJSON force:force
                completionHandler:completionHandler progressHandler:progressHandler];
        return true;
    }
    return false;
}

- (void)preloadApps:(NSString *)preloadID key:(NSString *)key secret:(NSString *)secret force:(bool)force
 completionHandler:(void (^)(NSArray *apps, NSError *error)) completionHandler
   progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {

    NSDictionary *params = [Auth signParam:[NSDictionary new] withKey:key andSecret:secret];
    NSString *endPoint = [self.serverAddr stringByAppendingFormat:@"%@%@", kPreloadPath, preloadID];
    NSString *urlStr = [SPARUtil addQueryParam:params toURL:endPoint];

    [JSONLoader loadFromURL:urlStr completionHandler:^(NSDictionary *jso, NSError *err) {
        // TODO: DRY
        if (err) {
            if (![self tryPreloadFromCache:preloadID force:force
                         completionHandler:completionHandler progressHandler:progressHandler]) {
                completionHandler(nil, err);
            }
            return;
        }

        NSInteger statusCode = [jso[kStatusCode] integerValue];
        if (statusCode != 0) {
            NSString *msg = jso[kResult][kMessage];
            if (!msg) msg = @"non zero status code";
            completionHandler(nil, [NSError errorWithDomain:msg code:statusCode userInfo:nil]);
            return;
        }

        [self preloadAppsFromJSON:jso force:force completionHandler:^(NSArray *apps, NSError *error) {
            [self.preloadCache updatePreloadJSON:jso withID:preloadID];
            completionHandler(apps, error);
        } progressHandler:progressHandler];
    } progressHandler:progressHandler];
}

- (NSArray *)appsFromJSONArray:(NSArray *)jsa {
    NSMutableArray *res = [NSMutableArray new];
    for (NSDictionary *jso in jsa) {
        NSString *arid = jso[kARID];
        NSString *packageURL = jso[kScene][kPackage];
        NSInteger timestamp = [jso[kTimestamp] integerValue];
        NSString *targetType = jso[kTargetType];
        NSDictionary *targetDesc = jso[kTargetDesc];
        SPARApp *app = [[SPARApp alloc] initWithARID:arid URL:packageURL timestamp:timestamp];
        if (targetType && targetDesc) {
            SPARTarget *target = [[SPARTarget alloc] initWithType:targetType andDesc:targetDesc];
            app.target = target;
        }
        [res addObject:app];
    }
    return res;
}

- (void)preloadAppsInList:(NSArray *)apps force:(bool)force
  completionHandler:(void (^)(NSArray *, NSError *))completionHandler
    progressHandler:(void (^)(NSString *, float))progressHandler {

    if (!apps || apps.count == 0) {
        completionHandler(nil, [NSError errorWithDomain:@"empty app list" code:-1 userInfo:nil]);
        return;
    }

    __block NSUInteger finished = 0;
    for (SPARApp *app in apps) {
        [self.cache updateApp:app];
        [app prepareTarget:force completionHandler:^(NSError *error) {
            if (error) {
                completionHandler(nil, error);
                return;
            }

            finished++;
            if (finished == apps.count) {
                completionHandler(apps, nil);
            }
            //progressHandler(@"preload", finished / (float)apps.count);
        } progressHandler:progressHandler]; // TODO: allow nil handlers
    }
}

- (SPARApp *)getAppByTargetDesc:(NSString *)targetDesc {
    return [self.cache getAppByTargetDesc:targetDesc];
}

@end
