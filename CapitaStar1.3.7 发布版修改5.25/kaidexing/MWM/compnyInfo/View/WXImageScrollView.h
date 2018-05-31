//
//  WXImageScrollView.h
//  WXCustomCamera
//
//  Created by wx on 16/7/8.
//  Copyright © 2016年 WX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXImageScrollView : UIScrollView<UIScrollViewDelegate> {
    UIImageView        *imageView;
}

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;
-(void)setContentOffsetIfPhotoFromCamera;
@end
