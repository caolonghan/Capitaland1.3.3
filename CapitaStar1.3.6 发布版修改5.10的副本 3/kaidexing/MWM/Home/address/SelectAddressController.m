//
//  SelectAddressController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/17.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "SelectAddressController.h"

@interface SelectAddressController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView         *tableView1;

@end

@implementation SelectAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStylePlain];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView1.scrollEnabled=YES;
    self.tableView1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tableView1];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 150, 26)];
    lable.text=@"北京";
    lable.textAlignment=NSTextAlignmentLeft;
    lable.font=DESC_FONT;
    [cell addSubview:lable];
    
    UIView *lingView=[[UIView alloc]initWithFrame:CGRectMake(0, 42.5, WIN_WIDTH, 0.5)];
    lingView.backgroundColor=COLOR_LINE;
    [cell addSubview:lingView];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
