//
//  AreaVM.h
//  kaidexing
//
//  Created by dwolf on 2017/6/10.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MwmBaseVM.h"
#import "Area.h"

@interface AreaVM : MwmBaseVM
-(void) loadData:(NSString*) pId level:(int)level;
-(void)loadArea:(NSString *)pid type:(int)type;
-(id)loadArea:(NSString *)id;
@end
