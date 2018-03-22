//
//  BankListController.m
//  kaidexing
//
//  Created by companycn on 2018/3/7.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BankListController.h"
#import "ChooseStyleTableViewCell.h"

@interface BankListController ()<UITableViewDelegate,UITableViewDataSource,bankCardStyleDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *bankArray;
@property (nonatomic,strong)NSArray *imgArray;
@end

@implementation BankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createTableView];
    self.navigationBarTitleLabel.text = @"支持的银行卡";
    self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
    self.navigationBar.backgroundColor = RGBCOLOR(0, 135, 140);
}
-(void)redefineBackBtn{
    [self redefineBackBtn:[UIImage imageNamed:@"AR_back"] :CGRectMake(0, 0, 44,44)];
}
- (void)loadData
{
    
}
- (NSArray*)bankArray
{
    if (!_bankArray) {
        _bankArray  = [NSArray array];
    }
    return  _bankArray;
}
-(NSArray*)imgArray
{
    if (!_imgArray) {
        _imgArray  = [NSArray array];
    }
    return  _imgArray;
}
- (void)createTableView
{
    _tableView =[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }else{
        return _bankArray.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
   
    static NSString *identifier = @"ChooseStyleTableViewCell";
    ChooseStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.delegate = self;
    if (!cell) {
        cell = [[ChooseStyleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.section ==0) {
            cell.titleLabel.text = @"储蓄卡";
        }else
        {
             cell.titleLabel.text = @"信用卡";
    }
    }
         return cell;
    }else{
        static NSString *identifier = @"tableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.text = _bankArray[indexPath.section];
            cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.section]];
    }
         return cell;
       
}
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"选择卡类型";
    }else
    {
        return @"热门银行";
    }
    
}
@end
