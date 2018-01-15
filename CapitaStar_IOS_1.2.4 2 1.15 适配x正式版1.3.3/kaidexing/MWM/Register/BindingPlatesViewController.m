//
//  BindingPlatesViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/4.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "BindingPlatesViewController.h"
#import "AddCarController.h"



@interface BindingPlatesViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView * tableV;
    
    NSArray * dataArr;
    
    BOOL   pushBool;
    
}
@end

@implementation BindingPlatesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text= @"绑定车牌号";
    pushBool=YES;
    [self loadData];
}

- (void)loadData {
    
    NSString * path = [Util makeRequestUrl:@"usercenter" tp:@"carnolist"];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @"1000", @"source", nil];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dataArr = dic[@"data"];
            if (dataArr.count) {
                
                if (tableV) {
                    [tableV reloadData];
                } else {
                    [self createTableView];
                }
            } else {
                [self createTableView];
//                if (pushBool==YES) {
//                      pushBool=NO;
//                      [self.delegate.navigationController pushViewController:[[AddCarController alloc] init] animated:YES];
//                }
              
            }
            [SVProgressHUD dismiss];
        });
        
    } failue:^(NSDictionary *dic) {
    }];
}




- (void)createTableView {
    
    tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT- NAV_HEIGHT)];
    
    tableV.dataSource = self;
    tableV.delegate = self;
    tableV.backgroundColor = COLOR_LINE;
    
    UIView * tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 53)];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 10, WIN_WIDTH - 2 * 10, 36);
    btn.backgroundColor = APP_BTN_COLOR;
    btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = COMMON_FONT;
    [btn setTitle:@"新增车牌号" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNewPlate:) forControlEvents:UIControlEventTouchUpInside];
    
    [tableFooterView addSubview:btn];
    
    tableV.tableFooterView = tableFooterView;
    
    [self.view addSubview:tableV];
}




- (void)addNewPlate:(UIButton *)sender {
    
    [self.delegate.navigationController pushViewController:[[AddCarController alloc] init] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"BindingPlate";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =COLOR_LINE;
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 60)];
        view.backgroundColor = [UIColor whiteColor];
        
        [cell addSubview:view];
        
        
        UILabel * topLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 21)];
        topLab.textColor = COLOR_FONT_BLACK;
        topLab.font = COMMON_FONT;
        topLab.tag = 8000;
        
        [view addSubview:topLab];
        
        
        UILabel * bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topLab.frame) + 10, 150, 21)];
        bottomLab.textColor = COLOR_FONT_SECOND;
        bottomLab.font = DESC_FONT;
        bottomLab.tag = 9000;
        
        [view addSubview:bottomLab];
        
        
    }
    UILabel * topLab = [cell viewWithTag:8000];
    
    topLab.text = [dataArr[indexPath.row] valueForKey:@"car_no"];
    [topLab sizeToFit];
    
    
//    NSString * temp = [[dataArr[indexPath.row] valueForKey:@"creat_time"] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString * temp = [dataArr[indexPath.row]valueForKey:@"creat_time"];
    UILabel * bottomLab = [cell viewWithTag:9000];
    bottomLab.text  = temp;
    bottomLab.frame = CGRectMake(10, CGRectGetMaxY(topLab.frame) + 2, 150, 21);
    [bottomLab sizeToFit];
    
    for(UIView* subView in cell.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            [subView removeFromSuperview];
        }
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame = CGRectMake(WIN_WIDTH - 10 - 70, (60 - 30)/2, 70, 30);
    btn.backgroundColor = APP_BTN_COLOR;
    btn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = DESC_FONT;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeBinding:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = indexPath.row + 200;
    [cell addSubview:btn];
    
    
    
    return cell;
}
- (void)removeBinding:(UIButton *)sender{
    
    [self confirm:@"确认解除绑定？" afterOK:^{
        int index=(int)sender.tag;
        [self loadData:index];
    }];
}

- (void)loadData:(int)sender {
    
    NSString * path = [Util makeRequestUrl:@"usercenter" tp:@"removecarno"];
    NSDictionary *dic=dataArr[sender - 200];
    NSString * car_no =dic[@"car_no"];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", car_no, @"car_no", @"1000", @"source", nil];
    
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        [SVProgressHUD showSuccessWithStatus:dic[@"data"]];
        
        [self loadData];
        
    } failue:^(NSDictionary *dic) {
        
        
    }];
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
