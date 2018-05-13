//
// Created by azu on 2013/10/10.
//


#import "UITabBarItem+compatible_iOS6_iOS7.h"


@implementation UITabBarItem (compatible_iOS6_iOS7)
+ (instancetype)tabBarItemWithTitle:(NSString *) title image:(UIImage *) image selectedImage:(UIImage *) selectedImage {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.title = title;
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
        tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else {
        tabBarItem.image = image;
    }
    if ([tabBarItem respondsToSelector:@selector(selectedImage)]) {
        [tabBarItem setSelectedImage:selectedImage];
    } else {
        [tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:image];
    }
    return tabBarItem;
}
@end