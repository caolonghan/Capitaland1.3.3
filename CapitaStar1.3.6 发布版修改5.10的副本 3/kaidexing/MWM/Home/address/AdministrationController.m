//
//  AdministrationController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AdministrationController.h"
#import "AddressCell.h"
#import "AddressController.h"
@interface AdministrationController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView         *tableView1;

@end

@implementation AdministrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text=@"管理地址";
    self.tableView1.scrollEnabled=YES;
    //增加收货地址
    
    [self initbuttomView1];
}
-(UITableView*)tableView1//WIN_HEIGHT
{
    if (!_tableView1) {
        self.tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, self.view.frame.size.height-122) style:UITableViewStylePlain];
        self.tableView1.delegate=self;
        self.tableView1.dataSource=self;
        self.tableView1.backgroundColor=UIColorFromRGB(0xf4f4f4);
        
        self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView1];
    }
    return _tableView1;
}

-(void)initbuttomView1
{
    UIButton *shouhuoBtn=[[UIButton alloc]initWithFrame:CGRectMake(10,self.view.frame.size.height-46.5, WIN_WIDTH-20,35)];
    [shouhuoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shouhuoBtn setTitle:@"管理收货地址" forState:UIControlStateNormal];
    shouhuoBtn.backgroundColor=APP_BTN_COLOR;
    shouhuoBtn.layer.masksToBounds=YES;
    shouhuoBtn.layer.cornerRadius=5;
    [shouhuoBtn addTarget:self action:@selector(addTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shouhuoBtn];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cell_H;
    if (indexPath.section==0) {
        cell_H=82;
    }else {
        cell_H=72;
    }
    
    return cell_H;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        static NSString *reuseIdentifier=@"cellID2";
        AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell==nil) {
            
            cell=[[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier index:indexPath.section];
            
        }
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.nameLab.text=@"王楼楼";
        
        cell.phoneLab.text=@"18221175026";
        
        cell.dizhiLab.text=@"182211750sdasdasdasdasdasdasdasdad26adasdasd";
        
        
        return cell;
        
    }else  if (indexPath.section!=0) {
        static NSString *reuseIdentifier=@"cellID3";
        AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell==nil) {
            
            cell=[[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier index:indexPath.section];
            
        }
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.nameLab.text=@"王楼楼";
        
        cell.phoneLab.text=@"18221175026";
        
        cell.dizhiLab.text=@"182211750sdasdasdasdasdasdasdasdad26adasdasd";
        return cell;
    }
    return nil;
}

-(void)addTouch
{
    AddressController *adVC=[[AddressController alloc]init];
    [self.delegate.navigationController pushViewController:adVC animated:YES];
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
