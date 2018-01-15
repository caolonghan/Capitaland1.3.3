/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "Util.h"

static char operationKey;

@implementation UIImageView (WebCache)

-(void)setImageWithString:(NSString*) url{
    [self setImageWithString:url placeholderImage:nil];
}

-(void)setImageWithString:(NSString*) url placeholderImage:(UIImage*) placeholderImage{
    if(url == nil){
        return;
    }
    NSString* imgUrl = nil;
    if([url rangeOfString:@"http://"].location == NSNotFound){
        imgUrl = [NSString stringWithFormat:@"%@%@",IMG_HOST,url];
    }
    NSString* newUrl = nil;
    if(imgUrl == nil || [imgUrl isEqual:[NSNull null]] || [imgUrl  isEqual: @""]){
        newUrl = url;
    }else{
        newUrl = imgUrl;
    }
    NSURL* nurl = [Util makeUIImageViewUrlWithString:newUrl];
    [self setImageWithURL:nurl placeholderImage:placeholderImage];
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock
{
    
    [self cancelCurrentImageLoad];

    self.image = placeholder;
    
    
    if (url)
    {
        __weak UIImageView *wself = self;
        if(![SDWebImageManager.sharedManager exists:url] && self.tag != NO_ALPHA_IMAGEVIEW){
            
            wself.alpha = 0.4f;
        }
        //wself.alpha=0;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            if (!wself) return;
            void (^block)(void) = ^
            {
                __strong UIImageView *sself = wself;
                if (!sself) return;
                if (image)
                {
                    sself.image = image;
                    [sself setNeedsLayout];
                }
                if (completedBlock && finished)
                {
                    completedBlock(image, error, cacheType);
                }
                
            };
            if(self.tag != NO_ALPHA_IMAGEVIEW){
                [UIView animateWithDuration:1.0
                                      delay:0.0
                                    options:UIViewAnimationCurveEaseOut
                                 animations:^(void){
                                     wself.alpha=1.0;
                                 }
                                 completion:^(BOOL finished) {}];
            }
            if ([NSThread isMainThread])
            {
                block();
            }
            else
            {
                dispatch_sync(dispatch_get_main_queue(), block);
            }
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)cancelCurrentImageLoad
{
    // Cancel in progress downloader from queue
    id<SDWebImageOperation> operation = objc_getAssociatedObject(self, &operationKey);
    if (operation)
    {
        [operation cancel];
        objc_setAssociatedObject(self, &operationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
