//
//  StarBabyTView.m
//  kaidexing
//
//  Created by YaoHuiQiu on 16/5/18.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "StarBabyTView.h"

#import "StarBabyTVCell.h"
#import "Const.h"
#import "UIView+UIViewController.h"
#import "ExchangeViewController.h"
#import "MyScoreViewController.h"

@implementation StarBabyTView
{
    NSArray *jifenArray;
    
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//        if ([_typestr isEqualToString:@"0"]) {
//           
//        }else {
//             [self createSubviews];
//        }
        
    }
    return self;
}

- (void)createSubviews:(NSArray *)jifenary {
    
    jifenArray=[[NSArray alloc]init];
    jifenArray=jifenary;
    UIView * tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 68)];
    
    self.tableFooterView = tableFooterView;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 15, WIN_WIDTH - 15 *2, 38);
    btn.backgroundColor = APP_BTN_COLOR;
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = COMMON_FONT;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"获取更多星币" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getMoreStarCoin:) forControlEvents:UIControlEventTouchUpInside];
    
    [tableFooterView addSubview:btn];
}

-(void) removeFooterView{
    self.tableFooterView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"StarBabyTVCell";
    StarBabyTVCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[StarBabyTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.dataDic = _dataArr[indexPath.row];
    
    return cell;
}

- (void)getMoreStarCoin:(UIButton *)sender {
    
    ExchangeViewController * exchangeVC = [[ExchangeViewController alloc] init];
    exchangeVC.dataAry=jifenArray;
    exchangeVC.xingBBId = _xingBBId;
    MyScoreViewController * msVC = (MyScoreViewController *)self.viewController;
    
    [msVC.delegate.navigationController pushViewController:exchangeVC animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
