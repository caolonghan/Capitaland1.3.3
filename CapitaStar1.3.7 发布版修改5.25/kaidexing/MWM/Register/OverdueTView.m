//
//  OverdueTView.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "OverdueTView.h"

#import "MyTicketViewController.h"
#import "TicketTVCell.h"

static NSString * identifier = @"TicketTVCell";

@implementation OverdueTView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UINib * nib = [UINib nibWithNibName:@"TicketTVCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identifier];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 97;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TicketTVCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.dataDic = _dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 14;
        
    } else {
        
        return 6;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height;
    
    if (section == 0) {
        
        height = 14;
        
    } else {
        
        height = 6;
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), height)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //self.viewController.delegate.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
