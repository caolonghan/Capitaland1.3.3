//
//  NotFirstBankInfoController.m
//  kaidexing
//
//  Created by companycn on 2018/3/10.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "NotFirstBankInfoController.h"
#import "CardInfoTableViewCell.h"
#import "TeleInfoController.h"
#import "CardInfoView.h"

@interface NotFirstBankInfoController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,carInfoViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)NSMutableArray *InfoArray;
@property (nonatomic,strong)CardInfoView *cardInfoView;

@end

@implementation NotFirstBankInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"验证银行卡信息";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self createTableView];
}
- (void)createTableView{
    CGFloat height ;
    if ([_cardType isEqualToString:@"01"]) {
        height = 443;
    }else{
        height=355;
    }
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor lightGrayColor];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_tableView.frame)+30, WIN_WIDTH-20, 44)];
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:@"验证信息" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithRed:114/255.0 green:220/255.0 blue:213/255.0 alpha:1]];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 3;
    [nextBtn addTarget:self action:@selector(clickToNext) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)clickToNext
{
    _InfoArray  = [NSMutableArray array];
    //借记卡
    if ([_cardType isEqualToString:@"01"]) {
       
            UITextField *textfield = (UITextField *)[self.view viewWithTag:1000];
            NSString *str = textfield.text;
            if ([Util isNull:str]) {
                [SVProgressHUD showErrorWithStatus:@"信息不能为空"];
                return;
            }
        
            if (![self isPhoneNumber:str]) {
                    [SVProgressHUD showErrorWithStatus:@"手机号填写错误"];
                    return;
                }
        
            [_InfoArray addObject:textfield.text];
           _cardHolderPhone = _InfoArray[0];
        
    }else{
        for (NSInteger i=0; i<3;i++) {
            UITextField *textfield = (UITextField *)[self.view viewWithTag:1000+i];
            NSString *str = textfield.text;
            if ([Util isNull:str]) {
                [SVProgressHUD showErrorWithStatus:@"信息不能为空"];
                return;
            }
            if (i==2) {
                if (![self isPhoneNumber:str]) {
                    [SVProgressHUD showErrorWithStatus:@"手机号填写错误"];
                    return;
                }
            }
            [_InfoArray addObject:textfield.text];
            
        }
        _expiredMonth = [_InfoArray[0] substringToIndex:1];
        _expiredYear =[_InfoArray[0] substringFromIndex:2];
        _CVN2 = _InfoArray[1];
        _cardHolderPhone = _InfoArray[2];
    }
    
    TeleInfoController *telVc= [[TeleInfoController alloc]init];
    telVc.cardType = _cardType;
    telVc.cardNum = _cardNum;
    telVc.cardName = _cardName;
    telVc.cardHolderId = _cardHolderId;
    telVc.cardHolderName = _cardHolderName;
    telVc.cardHolderPhone = _cardHolderPhone;
    telVc.CVN2 = _CVN2;
    telVc.expiredYear = _expiredYear;
    telVc.expiredMonth = _expiredMonth;
    telVc.certifTp = _certifTp;
    [self.navigationController pushViewController:telVc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 2;
    }else{
        if ([_cardType isEqualToString:@"01"]) {
            return 1;
        }
        else{
            return 3;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 44;
    }else{
        return 0.1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        
        static NSString *identifier = @"CardInfoTableViewCell";
        CardInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil][0];
            
            if (indexPath.row ==0 ) {
                cell.tagLabel.text = @"银行卡";
                cell.titleLabel.text = _cardName;
                
            }else{
                cell.tagLabel.text = @"卡 号";
                cell.titleLabel.text = _cardNum;
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selected = NO;
        return cell;
    }else{
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 11.5, 70, 21)];
            tagLabel.font = COMMON_FONT;
            UITextField *titleField = [[UITextField alloc]initWithFrame:CGRectMake(80, 11.5, WIN_WIDTH-130, 21)];
            titleField.delegate = self;
            titleField.tag = 1000+indexPath.row;
            titleField.font = COMMON_FONT;
            UIButton *tipBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-45, 10, 25, 25)];
            tipBtn.tag = 2000+indexPath.row;
            [tipBtn addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:tipBtn];
            [cell.contentView addSubview:tagLabel];
            [cell.contentView addSubview:titleField];
            if ([_cardType isEqualToString:@"01"]) {
                
                    tagLabel.text = @"手机号";
                    titleField.placeholder = @"银行预留手机号";
                    [tipBtn setImage:[UIImage imageNamed:@"Oval Copy"] forState:UIControlStateNormal];
                    
              
            }else{
                 if(indexPath.row ==0){
                    tagLabel.text = @"有效期";
                    titleField.placeholder = @"卡正面有效期，月份/年份";
                    [tipBtn setImage:[UIImage imageNamed:@"Oval Copy"] forState:UIControlStateNormal];
                    
                }else if (indexPath.row ==1){
                    tagLabel.text = @"卡验证码";
                    titleField.placeholder = @"卡片背面三位数字";
                    [tipBtn setImage:[UIImage imageNamed:@"Oval Copy"] forState:UIControlStateNormal];
                }else{
                    tagLabel.text = @"手机号";
                    titleField.placeholder = @"银行预留手机号";
                    [tipBtn setImage:[UIImage imageNamed:@"Oval Copy"] forState:UIControlStateNormal];
                }
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selected = NO;
        return cell;
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return @"提醒：后续只能绑定该持卡人的银行卡";
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 44)];
        footView.backgroundColor = [UIColor lightGrayColor];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 7, 30, 30)];
        [btn setImage:[UIImage imageNamed:@"Rectangle 9"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Rectangle 9 Copy"] forState:UIControlStateSelected];
        btn.selected = YES;
        [btn addTarget: self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btn];
        UILabel *word = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, WIN_WIDTH/2-50, 30)];
        word.text = @"同意《用户服务协议》";
        word.font = INFO_FONT;
        [footView addSubview:word];
        return footView;
    }
    return nil;
}
//同意协议
- (void)buttonClick{
    
    
}
//展示pop
- (void)buttonTouch:(UIButton *)sender{
    
    [self showCardInfoViewWithTag:sender.tag];
    
}
- (void)showCardInfoViewWithTag:(NSInteger)tag{
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
    tap.delegate = self;
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [_bgView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    NSInteger num = tag-2002;
    if ([_cardType isEqualToString:@"01"]) {
        
        _cardInfoView  = [[CardInfoView alloc]initWithFrame:CGRectMake(20, (WIN_HEIGHT-250)/2, WIN_WIDTH-40, 170) type:num];
        
    }else{
        CGFloat height;
        switch (tag-2002) {
            case 0:
                height =250;
                break;
            case 1:
                height =250;
                break;
            case 2:
                height =170;
                break;
            default:
                break;
        }
        _cardInfoView  = [[CardInfoView alloc]initWithFrame:CGRectMake(20, (WIN_HEIGHT-height)/2, WIN_WIDTH-40, height) type:num];
    }

    _cardInfoView.delegate = self;
    _cardInfoView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_cardInfoView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_cardInfoView]) {
        return NO;
    }
    
    return YES;
}
- (void)sureTapClick:(UITapGestureRecognizer *)tap
{
    [_cardInfoView removeFromSuperview];
    [_bgView removeFromSuperview];
    
    
}
//textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)isPhoneNumber:(NSString *)phone{
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phone];
    
    
}

@end
