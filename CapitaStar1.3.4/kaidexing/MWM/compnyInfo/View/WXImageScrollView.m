//
//  WXImageScrollView.m
//  WXCustomCamera
//
//  Created by wx on 16/7/8.
//  Copyright © 2016年 WX. All rights reserved.
//

#import "WXImageScrollView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height



@implementation WXImageScrollView
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        //self.clipsToBounds = YES;
        self.clipsToBounds = NO;
        self.bounces = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;        
    }
    return self;
}
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}
#pragma mark Configure scrollView to display new image (tiled or not)

- (void)displayImage:(UIImage *)image
{
    // clear the previous imageView
    [imageView removeFromSuperview];
    imageView = nil;
    
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float imageViewWidth = 0;
    float imageViewHeight = 0;
    if (imageWidth/imageHeight >= SCREEN_WIDTH/SCREEN_HEIGHT) {
        imageViewHeight = SCREEN_HEIGHT;
        imageViewWidth = imageViewHeight*imageWidth/imageHeight;
    }else{
        imageViewWidth = SCREEN_WIDTH;
        imageViewHeight = imageViewWidth*imageHeight/imageWidth;
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewWidth, imageViewHeight)];
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    [self configureForImageSize:CGSizeMake(imageViewWidth, imageViewHeight)];
}

- (void)configureForImageSize:(CGSize)imageSize 
{    
    self.contentSize = imageSize;
    self.maximumZoomScale = 2;
    self.minimumZoomScale = 0.5;
    self.zoomScale = 1;
    //    [self setContentOffset:CGPointMake(self.frame.origin.x, self.frame.origin.y)];
    [self setContentOffset:CGPointMake((imageSize.width - self.frame.size.width) / 2, (imageSize.height - self.frame.size.height) / 2)];
}
-(void)setContentOffsetIfPhotoFromCamera
{
    [self setContentOffset:CGPointMake((imageView.frame.size.width - self.frame.size.width) / 2, self.frame.origin.y)];
}

@end
