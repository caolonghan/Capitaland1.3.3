//
// Created by azu on 2013/10/10.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITabBarItem (compatible_iOS6_iOS7)
+ (instancetype)tabBarItemWithTitle:(NSString *) title image:(UIImage *) image selectedImage:(UIImage *) selectedImage;
@end