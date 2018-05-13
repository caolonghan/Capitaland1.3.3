//
//  UIImageCompress.h
//  ATP
//
//  Created by Hwang Kunee on 13-8-21.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//
#import <UIKit/UIKit.h>



@interface UIImage (Compress)

- (UIImage *)compressedImage;

- (CGFloat)compressionQuality;

- (NSData *)compressedData;

- (NSData *)compressedData:(CGFloat)compressionQuality;

@end

