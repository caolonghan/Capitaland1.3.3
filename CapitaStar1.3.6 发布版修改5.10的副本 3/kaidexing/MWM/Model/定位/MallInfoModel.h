//
//  MallInfoModel.h
//  kaidexing
//
//  Created by dwolf on 2017/5/27.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MJSONModel.h"

@interface MallInfoModel : MJSONModel
@property(nonatomic,retain) NSString<Optional>* address ;
@property(nonatomic,retain) NSString<Optional>* app_img;
@property(nonatomic,retain) NSString<Optional>*lat;
@property(nonatomic,retain) NSString<Optional>*lng;
@property(nonatomic,retain) NSString<Optional>* mall_close_time;
@property(nonatomic,retain) NSString<Optional>* mall_id;
@property(nonatomic,retain) NSString<Optional>* mall_id_des;
@property(nonatomic,retain) NSString<Optional>* mall_install_status;
@property(nonatomic,retain) NSString<Optional>* mall_logo_img_url;
@property(nonatomic,retain) NSString<Optional>* mall_name;
@property(nonatomic,retain) NSString<Optional>*mall_open_time;
@property(nonatomic,retain) NSString<Optional>* mall_remark;
@property(nonatomic,retain) NSString<Optional>* mall_url_prefix;
@property(nonatomic,retain) NSString<Optional>* traffic;
@end
