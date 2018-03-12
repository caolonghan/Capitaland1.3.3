//
//  SPARApp.m
//  EasyAR3D
//
//  Created by Qinsi on 9/29/16.
//
//

#import "SPARApp.h"
#import "SPARTarget.h"
#import "SPARPackage.h"
#import "Downloader.h"
#import "SPARUtil.h"
#import "Downloader.h"

@implementation SPARApp

static NSString *kKeyARID = @"arid";
static NSString *kKeyPackageURL = @"packageURL";
static NSString *kKeyTimestamp = @"timestamp";
static NSString *kKeyImages = @"images";
static NSString *kKeySize = @"size";

static NSString *kKeyTarget = @"target";

+ (SPARApp *)SPARAppFromDict:(NSDictionary *)dict {
    NSString *arid = dict[kKeyARID];
    NSString *url = dict[kKeyPackageURL];
    NSInteger timestamp = [dict[kKeyTimestamp] integerValue];
    SPARApp *res = [[SPARApp alloc] initWithARID:arid URL:url timestamp:timestamp];
    NSDictionary *targetDict = dict[kKeyTarget];
    if (targetDict) {
        res.target = [SPARTarget SPARTargetFromDict:targetDict];
    }
    return res;
}

- (NSDictionary *)toDict {
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithDictionary:@{
             kKeyARID: self.ARID,
             kKeyPackageURL: self.package.getPackageURL,
             kKeyTimestamp: [NSNumber numberWithInteger:self.timestamp],
             }];
    if (self.target) {
        res[kKeyTarget] = [self.target toDict];
    }
    return res;
}

- (instancetype)initWithARID:(NSString *)arid URL:(NSString *)url timestamp:(NSInteger) timestamp {
    self = [super init];
    if (self) {
        self.ARID = arid;
        self.package = [[SPARPackage alloc] initWithURL:url];
        self.timestamp = timestamp;
    }
    return self;
}

- (bool)hasTarget {
    return self.target != nil && self.target.url != nil;
}

- (NSString *)getTargetURL {
    if (![self hasTarget]) return nil;
    return self.target.url;
}

- (NSString *)getTargetDesc {
    if (![self hasTarget]) return nil;
    NSDictionary *desc = @{
                           kKeyImages: [NSArray arrayWithObjects:self.target.desc, nil],
                           };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:desc options:kNilOptions error:&error];
    if (!jsonData) return @"{}";
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *)getLocalPathForTargetURL {
    if (![self hasTarget]) return nil;
    NSString *downloadPath = [Downloader getDownloadPath:[Downloader targetsPath]];
    NSString *downloadFileName = [Downloader getLocalNameForURL:self.target.url];
    return [downloadPath stringByAppendingPathComponent:downloadFileName];
}

- (NSString *)getLocalPathForPackageFileURL:(NSString *)url {
    return [self.package getLocalPathForURL:url];
}

- (void)prepareTarget:(bool)force completionHandler:(void (^)(NSError *error)) completeHandler
      progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler {
    if (![self hasTarget]) {
        completeHandler([NSError errorWithDomain:@"No target" code:-1 userInfo:nil]);
        return;
    }

    NSString *dst = [self getLocalPathForTargetURL];
    if ([SPARUtil pathExists:dst] && !force) {
        completeHandler(nil);
        return;
    }

    [[Downloader new] download:self.target.url to:dst force:force completionHandler:completeHandler progressHandler:progressHandler];
}

- (void)deployPackage:(bool)force completionHandler:(void (^)(NSError *error)) completeHandler
      progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler {
    [self.package deploy:force completionHandler:completeHandler progressHandler:progressHandler];
}

- (NSString *)getManifestURL {
    return [self.package getManifestURL];
}

- (void)destroy {
    if ([self hasTarget]) {
        [SPARUtil deleteQuietly:[self getLocalPathForTargetURL]];
    }
    [self.package destroy];
}

@end
