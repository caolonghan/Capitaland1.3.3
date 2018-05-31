//
//  FindViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "FindViewController.h"
#import "SearchDetailsCell.h"
@interface FindViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView     *tableView1;//
@end

@implementation FindViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.delegate.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0,64, WIN_WIDTH, self.view.frame.size.height-109) style:UITableViewStylePlain];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
    self.tableView1.backgroundColor=[UIColor whiteColor];
    self.tableView1.scrollEnabled=YES;

    [self.view addSubview:self.tableView1];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseIdentifier=@"cellID2";
    
    SearchDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[SearchDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-------点击了cell--------");
    
    
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
