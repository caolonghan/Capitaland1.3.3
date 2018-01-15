//
//  AddressVM.h
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MwmBaseVM.h"
#import "AddressModel.h"

@interface AddressVM : MwmBaseVM
//修改某个位置的地址数据
-(void) updateAddress:(int) index;

//新增地址
-(void) addAddress:(AddressModel*) model;


//删除地址
-(void) deleteAddress:(AddressModel*) model;
@end
