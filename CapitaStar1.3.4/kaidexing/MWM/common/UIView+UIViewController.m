//
//  UIView+UIViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "UIView+UIViewController.h"

@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    
    UIResponder *next = self.nextResponder;
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

@end
