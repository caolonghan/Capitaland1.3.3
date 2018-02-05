//
//  UserCenterViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "UserCenterViewController.h"
#import "PasswordController.h"
#import "UserCenterTFV.h"

@interface UserCenterViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView * userCenterTV;
    
    NSArray * section_0;
    NSArray * section_1;
    UserCenterTFV * tableFView;
    NSMutableArray * section0_Data;
    NSMutableArray * section1_Data;
}
@end

@implementation UserCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [self networkRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarTitleLabel.text= @"用户中心";
    
    section_0 = @[@"头像", @"昵称"];
    section_1 = @[@"真实姓名", @"性别", @"生日", @"手机号"];
    
    [self createTableView];
    
    [self networkRequest];
}

- (void)networkRequest {
    
    NSString * path = [Util makeRequestUrl:@"member" tp:@"pinfo"];
    
    [section0_Data removeAllObjects];
    [section1_Data removeAllObjects];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @"1000", @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSDictionary * dataDic = dic[@"data"];
            
            dataDic  = [Util nullDic:dataDic];
            
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dataDic[@"img_url"] forKey:@"img_url"];
            [userDefaults setObject:dataDic[@"nick_name"] forKey:@"nick_name"];
            [userDefaults setObject:dataDic[@"phone"] forKey:@"phone"];
            [userDefaults setObject:dataDic[@"username"] forKey:@"username"];
            
            [Global sharedClient].img_url = [userDefaults valueForKey:@"img_url"];
            [Global sharedClient].nick_name = [userDefaults valueForKey:@"nick_name"];
            [Global sharedClient].phone = [userDefaults valueForKey:@"phone"];
            
            section0_Data = [[NSMutableArray alloc] init];
            [section0_Data addObject:dataDic[@"img_url"]];
            [section0_Data addObject:dataDic[@"nick_name"]];
            
            [Global sharedClient].nick_name=dataDic[@"nick_name"];
            
            section1_Data = [[NSMutableArray alloc] init];
            [section1_Data addObject:dataDic[@"username"]];
            NSLog(@"姓名%@",dataDic[@"username"]);
            NSString * sexStr = dataDic[@"sex"];
            NSString * sex = @"";
            if(![Util isNull:sexStr]){
                if ([sexStr isEqualToString:@"1"]) {
                    sex = @"男";
                } else {
                    sex = @"女";
                }
            }
            
            [section1_Data addObject:sex];
            if([dataDic[@"birth"] length] > 11){
                [section1_Data addObject:[dataDic[@"birth"] substringToIndex:10]];
            }else{
                [section1_Data addObject:dataDic[@"birth"]];
            }
            
            [section1_Data addObject:dataDic[@"phone"]];
            
//            [self createTableView];
            tableFView.section0_Data = section0_Data;
            tableFView.section1_Data = section1_Data;
            NSLog(@"真实姓名%@",section1_Data[0]);
            [userCenterTV reloadData];
            
            [SVProgressHUD dismiss];
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"%@",dic[@"msg"]);
    }];
}

- (void)createTableView {
    
    userCenterTV = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT) style:UITableViewStyleGrouped];
    userCenterTV.dataSource = self;
    userCenterTV.delegate = self;
    userCenterTV.backgroundColor = [UIColor whiteColor];
    //userCenterTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableFView = [[UserCenterTFV alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 90)];
    tableFView.viewC = self;
    tableFView.section0_Data = section0_Data;
    tableFView.section1_Data = section1_Data;
    
    userCenterTV.tableFooterView = tableFView;
    
    [self.view addSubview:userCenterTV];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
    }
    return section_1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 72;
        } else {
            
            return 50;
        }
    } else {
        
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"UserCenterTVCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = COMMON_FONT;
        cell.textLabel.textColor = COLOR_FONT_SECOND;
        
        UIImageView * coverIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIN_WIDTH - 16 - 50, 8, 50, 50)];
        coverIV.tag = 1000;
        coverIV.layer.cornerRadius = 25;
        coverIV.layer.masksToBounds = YES;
        coverIV.hidden = YES;
        
        [cell addSubview:coverIV];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(WIN_WIDTH - 16 - 150, 13, 150, 21)];
        
        label.tag = 2000;
        label.hidden = YES;
        label.font = COMMON_FONT;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = COLOR_FONT_SECOND;
        
        [cell addSubview:label];
    }
    if (indexPath.section == 0) {
        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.text = section_0[indexPath.row];
        
        if (indexPath.row == 0) {
            
            UIImageView * coverIV = [cell viewWithTag:1000];
            coverIV.hidden = NO;
            [coverIV setImageWithString:[section0_Data objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"user"]];
            coverIV.contentMode = UIViewContentModeScaleAspectFill;
            coverIV.clipsToBounds = YES;
            coverIV.backgroundColor = [UIColor whiteColor];

            
//            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 71, WIN_WIDTH, 1)];
//            view.backgroundColor = COLOR_LINE;
//            
//            [cell addSubview:view];
            
        } else {
            UILabel * label = [cell viewWithTag:2000];
            label.hidden = NO;
            label.text = [section0_Data lastObject];
        }
        
    } else {
        
        cell.textLabel.text = section_1[indexPath.row];
        
        if (indexPath.row != 4) {
            
            UILabel * label = [cell viewWithTag:2000];
            label.hidden = NO;
            //label.text = @"section_1";
            label.text = section1_Data[indexPath.row];
        }
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 49, WIN_WIDTH, 1)];
//        view.backgroundColor = COLOR_LINE;
//        
//        [cell addSubview:view];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        return 9;
    }
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 9)];
    view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 4) {
        //修改密码
        //1.8接口
        NSLog(@"点击了修改密码");
        PasswordController  *pVC=[[PasswordController alloc]init];
        [self.delegate.navigationController pushViewController:pVC animated:YES];
    }
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
