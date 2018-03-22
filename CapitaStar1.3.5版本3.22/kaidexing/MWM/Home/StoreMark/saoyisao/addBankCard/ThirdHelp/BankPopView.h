//
//  BankPopView.h
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BankPopViewDelegate<NSObject>
- (void)clickTocancel;
-(void)addBankCard;
- (void)changeBankCard:(NSString*)bankName ides:(NSString *)ides index:(NSInteger)index;
@end
@interface BankPopView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *bankArr;
-(instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index;
@property (nonatomic,weak)id<BankPopViewDelegate>delegate;
@end
