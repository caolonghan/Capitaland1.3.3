//
//  ApplicationCell.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/22.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ApplicationCell.h"

@implementation ApplicationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stateBtnImg.contentMode = UIViewContentModeScaleAspectFit;
    self.stateBtnImg.enabled=NO;
    [self.stateBtnImg setTitle:@"" forState:UIControlStateNormal];
    self.stateBtnImg.alpha=1.0;
    self.stateBtnImg.hidden= YES;
    self.lineView1.hidden=YES;
    self.lineView2.hidden=YES;
}

-(void)canEdit:(BOOL)ishidden{
    ishidden =ishidden?NO:YES;
    self.stateBtnImg.hidden =ishidden;
    self.lineView1.hidden=ishidden;
    self.lineView2.hidden=ishidden;
}


@end
