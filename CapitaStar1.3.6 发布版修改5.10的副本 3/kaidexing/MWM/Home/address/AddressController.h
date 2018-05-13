//
//  AddressController.h
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressCell.h"

@protocol dizhiIdDelegeta <NSObject>

-(void)setid_contents:(id)contents;

@end

@interface AddressController : BaseViewController<addressDelegate>
@property (strong,nonatomic)NSString   *typeStr;
@property (assign,nonatomic)id<dizhiIdDelegeta>dizhiiddelegate;

@end
