//
//  SPARPackage.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import "SPARPackage.h"
#import "Downloader.h"
#import "Unpacker.h"
#import "SPARUtil.h"

@interface SPARPackage()
@property (nonatomic, strong) NSString *packageURL;
@property (nonatomic, strong) NSMutableDictionary *fileMap;
@end

@implementation SPARPackage

static NSString *kManifest = @"manifest.json";
static NSString *kPackage = @"package";

static NSString *kKeyURL = @"url";

+ (SPARPackage *)SPARPackageFromDict:(NSDictionary *)dict {
    NSString *packageURL = dict[kKeyURL];
    SPARPackage *res = [[SPARPackage alloc] initWithURL:packageURL];
    return res;
}

- (NSDictionary *)toDict {
    return @{
             kKeyURL: self.packageURL,
             };
}

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        self.packageURL = url;
        self.fileMap = [NSMutableDictionary new];
        [self createFilesMap];
    }
    return self;
}

- (NSString *)getPackageURL {
    return self.packageURL;
}

- (NSString *)getDownloadPath {
    return [[self getUnpackPath] stringByAppendingPathExtension:@"zip"];
}

- (NSString *)getUnpackPath {
    NSString *downloadPath = [Downloader getDownloadPath:[Downloader packagesPath]];
    NSString *localName = [Downloader getLocalNameForURL:self.packageURL];
    return [downloadPath stringByAppendingPathComponent:localName];
}

- (NSString *)getFileLocalPath:(NSString *)fileName {
    return [[self getUnpackPath] stringByAppendingPathComponent:fileName];
}

- (NSString *)getManifestURL {
    return [@"file://" stringByAppendingString:[self getFileLocalPath:kManifest]];
}

- (NSDictionary *)getPackageManifest {
    NSString *manifestPath = [self getFileLocalPath:kManifest];
    NSData *data = [NSData dataWithContentsOfFile:manifestPath];
    if (!data) return nil;
    NSError *error;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    return res;
}

- (void)createFilesMap {
    NSDictionary *manifest = [self getPackageManifest];
    if (!manifest) return;
    NSDictionary *urlMap = [manifest objectForKey:kPackage];
    for (NSString *url in urlMap) {
        NSString *fileName = [urlMap objectForKey:url];
        NSString *localPath = [self getFileLocalPath:fileName];
        [self.fileMap setObject:localPath forKey:url];
    }
    NSString *manifestPath = [self getFileLocalPath:kManifest];
    [self.fileMap setObject:manifestPath forKey:[self getManifestURL]];
}

- (NSString *)getLocalPathForURL:(NSString *)url {
    return [self.fileMap objectForKey:url];
}

- (void)deploy:(bool) force completionHandler:(void (^)(NSError *error)) completeHandler
progressHandler:(void (^)(NSString * taskName, float progress)) progressHandler {
    Downloader *dl = [Downloader new];
    NSString *downloadPath = [self getDownloadPath];
    [dl download:self.packageURL to:downloadPath force:force completionHandler:^(NSError *err) {
        if (err) {
            completeHandler(err);
            return;
        }

        NSString *unpackPath = [self getUnpackPath];
        [Unpacker unpackPath:downloadPath to:unpackPath force:YES completionHandler:^(NSError *err) {
            if (!err) {
                [self createFilesMap];
            }
            completeHandler(err);
        } progressHandler:progressHandler];
    } progressHandler:progressHandler];
}

- (void)destroy {
    [SPARUtil deleteQuietly:[self getDownloadPath]];
    [SPARUtil deleteQuietly:[self getUnpackPath]];
}

@end
