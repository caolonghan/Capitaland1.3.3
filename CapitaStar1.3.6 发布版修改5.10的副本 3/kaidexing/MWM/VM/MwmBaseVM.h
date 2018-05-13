//
//  MwmBaseVM.h
//  kaidexing
//
//  Created by dwolf on 2017/5/6.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"

@interface MwmBaseVM : NSObject{
    int page;
    Boolean isEnd;
}
@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

@property (nonatomic, strong, readonly) NSMutableArray<id>* tableData;


-(void) loadData;
-(void) loadMore;
-(int) tableSection;
-(int) tableRowCount;

@end
