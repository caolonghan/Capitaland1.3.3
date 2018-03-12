//
//  MSearchBar.h
//  ABAS
//
//  Created by dwolf on 16/6/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSearchBar : UISearchBar{
    UIColor *bgColor;
    UIColor *tfColor;
    CGRect newFrame;
    BOOL reSize;
    float cornerRadius;
}
@property UIColor* bgColor;
@property UIColor* tfColor;
@property CGRect newFrame;
@property BOOL reSize;
@property float cornerRadius;
@end
