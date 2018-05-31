//
//  KTPhotoView+SDWebImage.m
//  Sample
//
//  Created by Henrik Nyh on 3/18/10.
//

#import "KTPhotoView+SDWebImage.h"
#import "SDWebImageManager.h"

@implementation KTPhotoView (SDWebImage)

- (void)setImageWithURL:(NSURL *)url {
   [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
   SDWebImageManager *manager = [SDWebImageManager sharedManager];
   UIImage *cachedImage = nil;
   if (url) {
     cachedImage = [[manager imageCache] imageFromDiskCacheForKey:[url absoluteString]];
   }
   
   if (cachedImage) {
      //[self setImage:[UIImage imageNamed:@"photo_loading_img.png"]];
      [self setImage:cachedImage];
   }
   else {
      if (placeholder) {
          [self setImage:placeholder];
      }
      
      if (url) {
          UIActivityIndicatorView *nativeIndicator=[[UIActivityIndicatorView alloc] initWithFrame:self.frame];
    nativeIndicator.tag=1009;
          [nativeIndicator setColor:[UIColor whiteColor]];
          [nativeIndicator startAnimating];
          nativeIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
          [self addSubview:nativeIndicator];
        [manager downloadWithURL:url options:nil progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            
            [nativeIndicator stopAnimating];
            [nativeIndicator removeFromSuperview];
            if(finished && !error){
                [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                //[self setImage:image];
            }
        }];
      }
   }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
   [self setImage:image];
}

@end