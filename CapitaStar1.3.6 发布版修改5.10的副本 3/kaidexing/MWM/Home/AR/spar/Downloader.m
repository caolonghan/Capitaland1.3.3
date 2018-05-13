//
//  Downloader.m
//  EasyAR3D
//
//  Created by Qinsi on 9/20/16.
//
//

#import "Downloader.h"
#import "Auth.h"
#import "SPARUtil.h"

@interface Downloader () <NSURLSessionDownloadDelegate>
@property (nonatomic, copy) void (^completionHandler)(NSError *error);
@property (nonatomic, copy) void (^progressHandler)(NSString *taskName, float progress);
@property (nonatomic, retain) NSURL *targetURL;
@end

@implementation Downloader

static NSString *kTaskName = @"Download";
static NSString *kPackagesPath = @"packages";
static NSString *kTargetsPath = @"targets";

+ (NSString *)packagesPath {
    return kPackagesPath;
}

+ (NSString *)targetsPath {
    return kTargetsPath;
}

+ (NSString *)getLocalNameForURL:(NSString *)url {
    return [Auth sha1Hex:url];
}

+ (NSString *)getDownloadPath:(NSString *)path {
    NSString *dir = [SPARUtil getSupportDirectory];
    NSString *targetPath = [dir stringByAppendingPathComponent:path];
    [SPARUtil ensureDirectory:targetPath];
    return targetPath;
}

- (void)download:(NSString *) url to:(NSString *) dst force:(bool) force
completionHandler:(void (^)(NSError *err)) completionHandler progressHandler:(void (^)(NSString *taskName, float progress)) progressHandler {
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    bool fileExists = [fm fileExistsAtPath:dst];
    if (fileExists) {
        if (!force) {
            completionHandler(nil);
            return;
        }
        [fm removeItemAtPath:dst error:&error];
        if (error) {
            completionHandler(error);
            return;
        }
    }

    NSString *path = [dst stringByDeletingLastPathComponent];
    bool pathExists = [fm fileExistsAtPath:path];
    if (!pathExists) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            completionHandler(error);
            return;
        }
    }

    self.targetURL = [NSURL fileURLWithPath:dst];
    self.completionHandler = completionHandler;
    self.progressHandler = progressHandler;

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:url]];
    [task resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
#pragma unused (session, downloadTask, bytesWritten)
    float prog = totalBytesWritten / (float)totalBytesExpectedToWrite;
    if (totalBytesExpectedToWrite < 0) {
        prog = 0;
    }
    self.progressHandler(kTaskName, prog);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
#pragma unused (session, task)
    if (error) {
        self.completionHandler(error);
        [session finishTasksAndInvalidate];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
#pragma unused (session, downloadTask)
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm moveItemAtURL:location toURL:self.targetURL error:&error];
    self.completionHandler(error);
    [session finishTasksAndInvalidate];
}

@end
