//
//  VoucherDetailViewController.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "VoucherDetailViewController.h"

#import "VoucherDetailTVCell.h"

@interface VoucherDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation VoucherDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"核销";
    
    
    [self createSubviews];
}

- (void)createSubviews {
    
    UITableView * tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT)];
    tableV.dataSource = self;
    tableV.delegate = self;
    tableV.backgroundColor = UIColorFromRGB(0xf0f0f0);
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.scrollEnabled = NO;
    
    [self.view addSubview:tableV];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 43)];
    view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 293;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"VoucherDetailTVCell";
    VoucherDetailTVCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[VoucherDetailTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
