//
//  BankPopView.m
//  kaidexing
//
//  Created by companycn on 2018/3/8.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "BankPopView.h"
#import "BankPopTableViewCell.h"
#import "Global.h"
#import "HttpClient.h"
@implementation BankPopView
{
    NSInteger indexPathRow;
}
-(instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index{
   self = [super initWithFrame:frame];
    if (self) {
        indexPathRow = index;
        [self createView];
        [self loadData];
    }
    return self;
}
- (void)loadData{
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"unionpay/UnionpayBindCard" tp:@"get_member_card_list"] parameters:diction target:self success:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
         dispatch_async(dispatch_get_main_queue(), ^{
             NSMutableArray *arr =[NSMutableArray arrayWithArray: dic[@"data"]];
             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"Bitmap Copy 4",@"iamge" ,@"使用新卡付款",@"card_name",nil];
             [arr addObject:dic];
             _bankArr = [NSArray arrayWithArray:arr];
             [self.tableView reloadData];
         });
    } failue:^(NSDictionary *dic) {
        NSLog(@"失败%@",dic[@"msg"]);
        
        
    }];
}

- (void)createView{
    
    self.backgroundColor = [UIColor whiteColor];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self addSubview:headerView];
    UIButton *cancleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [headerView addSubview:cancleBtn];
    [cancleBtn setImage:[UIImage imageNamed:@"Combined Shape"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(clickToCancle) forControlEvents:UIControlEventTouchUpInside];
    UILabel *bankLabel = [[UILabel alloc]initWithFrame:CGRectMake( self.frame.size.width/2-60,0, 120, 44)];
    bankLabel.text = @"选择付款方式";
    [headerView addSubview:bankLabel];
    
    
    //_bankArr = [NSArray arrayWithObjects:@"中国银行",@"交通银行",@"工商银行",@"农业银行",@"使用新卡付款",nil];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   

}
-(void)clickToCancle{
    [self.delegate clickTocancel];
}
- (void)clickToAddBank{
    [self.delegate addBankCard];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bankArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BankPopTableViewCell";
    BankPopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil][0] ;
        if (indexPath.row !=indexPathRow&&indexPath.row!=_bankArr.count-1) {
            cell.tipImageView.hidden = YES;
        }
        if (indexPath.row ==_bankArr.count-1) {
            cell.tipImageView.image = [UIImage imageNamed:@"Path 3"];
            cell.bankLabel.text = _bankArr[indexPath.row][@"card_name"];
            cell.bankImageView.image = [UIImage imageNamed:@"Bitmap Copy 4"];
            
        }else{
        [cell.bankImageView setImageWithURL:[NSURL URLWithString: _bankArr[indexPath.row][@"logo_url"]]];
        NSString *cardNo = _bankArr[indexPath.row][@"card_no"];
        
        cell.bankLabel.text = [NSString stringWithFormat:@"%@(%@)",_bankArr[indexPath.row][@"card_name"],[cardNo substringFromIndex:cardNo.length-4]] ;
        cell.tipImageView.image = [UIImage imageNamed:@"Path 5"];
        
    }
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     BankPopTableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
   
    indexPathRow = indexPath.row;
    [self.tableView reloadData];
   
    if (indexPath.row == _bankArr.count-1) {
       [self.delegate addBankCard];
    }else{
        for (NSInteger i=0; i<_bankArr.count-2; i++) {
            
        }
         cell.tipImageView.hidden = NO;
        NSString *bankName =cell.bankLabel.text;
        [self.delegate changeBankCard:bankName ides: _bankArr[indexPath.row][@"ides"] index:indexPath.row];
    }
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    BankPopTableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
//    cell.tipImageView.hidden = YES;
//}
@end
