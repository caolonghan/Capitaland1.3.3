//
//  Unpacker.m
//  EasyAR3D
//
//  Created by Qinsi on 9/21/16.
//
//

#import "Unpacker.h"
#import "SSZipArchive.h"

@implementation Unpacker

static NSString *kTaskName = @"Unpack";

+ (void)unpackPath:(NSString *) src to:(NSString *) dst force:(bool) force
completionHandler:(void (^)(NSError *err))completionHandler
   progressHandler:(void (^)(NSString *taskName, float progress))progressHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // TODO: DRY with Downloader
        NSFileManager *fm = [NSFileManager defaultManager];
        bool fileExists = [fm fileExistsAtPath:dst];
        if (fileExists && !force) {
            completionHandler(nil);
            return;
        }

        NSError *error;
        if (!fileExists) {
            [fm createDirectoryAtPath:dst withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                completionHandler(error);
                return;
            }
        }

        [SSZipArchive unzipFileAtPath:src toDestination:dst overwrite:force password:nil
                      progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
#pragma unused (entry, zipInfo)
                          progressHandler(kTaskName, entryNumber / (float)total);
                      }
                    completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
#pragma unused (path, succeeded)
                        completionHandler(error);
                    }];
    });
}

@end
