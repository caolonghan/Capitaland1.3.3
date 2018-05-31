//
//  SfNavigationController.m
//  SurfingShare
//
//  Created by Hwang Kunee on 13-7-18.
//  Copyright (c) 2013年 Hwang Kunee. All rights reserved.
//

#import "SfNavigationController.h"

@interface SfNavigationController ()

@end

@implementation SfNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //对于IPAD，不允许转屏
    if(iPhoneOniPad) {
        return NO;
    }
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(BOOL)shouldAutorotate {
    //对于IPAD，不允许转屏
    if(iPhoneOniPad) {
        return NO;
    }
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    //对于IPAD，不允许转屏
    if(iPhoneOniPad) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

@end
