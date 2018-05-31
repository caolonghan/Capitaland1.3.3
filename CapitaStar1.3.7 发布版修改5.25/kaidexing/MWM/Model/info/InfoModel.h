//
//  InfoModel.h
//  kaidexing
//
//  Created by dwolf on 2017/5/12.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "MJSONModel.h"

@interface InfoModel : MJSONModel
@property (nonatomic, assign) NSNumber<Optional> *ids;
@property (nonatomic, assign) NSNumber<Optional>* mall_id;
@property (nonatomic, strong) NSString<Optional> *sub_title; //"咨询信息",
@property (nonatomic, strong) NSString<Optional> *title; //咨询信息测试2",
@property (nonatomic, strong) NSString<Optional> *contents;
@property (nonatomic, strong) NSString<Optional> *link_url;
@property (nonatomic, strong) NSString<Optional> *img_url;
@property (nonatomic, strong) NSString<Optional> *sort_id;
@property (nonatomic, strong) NSString<Optional> *status;
@property (nonatomic, strong) NSString<Optional> *add_uid;
@property (nonatomic, strong) NSString<Optional> *create_time;
@property (nonatomic, strong) NSString<Optional> *update_time;
@property (nonatomic, strong) NSString<Optional> *vedio_url;
@end
