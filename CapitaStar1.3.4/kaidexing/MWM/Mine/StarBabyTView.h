//
//  StarBabyTView.h
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarBabyTView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSArray     *dataArr;
@property (strong,nonatomic)NSString    *typestr;
@property (strong,nonatomic)NSString* xingBBId;
- (void)createSubviews :(NSArray*)jifenary;

-(void) removeFooterView;

@end
