//
//  InfoVM.h
//  kaidexing
//
//  Created by dwolf on 2017/5/12.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MwmBaseVM.h"
#import "InfoModel.h"

@interface InfoVM : MwmBaseVM
-(NSMutableArray<InfoModel*>*) getInfoModeList;
-(void) getConsultList:(NSString*) type;
@end
