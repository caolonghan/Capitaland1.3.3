//
//  MwmBaseVM.m
//  kaidexing
//
//  Created by dwolf on 2017/5/6.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MwmBaseVM.h"


@implementation MwmBaseVM
@synthesize tableData;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
     tableData = [[NSMutableArray alloc] init];
    _successObject = [RACSubject subject];
    _failureObject = [RACSubject subject];
    _errorObject = [RACSubject subject];
    
}

//为表格提供的section数量方法
-(int) tableSection{
    return 1;
}

//为表格提供的表格行数方法
-(int) tableRowCount{
    return tableData.count;
}


@end
