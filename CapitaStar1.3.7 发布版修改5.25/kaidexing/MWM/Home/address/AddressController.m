//
//  AddressController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AddressController.h"
#import "AddaddressController.h"
#import "AddressCell.h"
#import "AdministrationController.h"
#import "ExpressOrderController.h"
#import "PullingRefreshTableView.h"
#import "ReTableView.h"

@interface AddressController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property (strong,nonatomic)ReTableView         *tableView1;
@end

@implementation AddressController
{
    NSMutableArray *dataAry;
    BOOL    addBool;
    int     _page;
    BOOL    isend;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (addBool==YES) {
        addBool=NO;
        [self NetWorkRequest:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataAry=[[NSMutableArray alloc]init];
    addBool=NO;
    isend  =NO;
    self.navigationBarTitleLabel.text=@"管理收货地址";
    self.tableView1.scrollEnabled=YES;
    [self NetWorkRequest:nil];
    [self initbuttomView];
}
-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}
-(void)NetWorkRequest:(NSString*)type
{
    if (type == nil || [type isEqualToString:REFRESH_METHOD]) {
        _page = 1;
        isend=NO;
    }else if (isend==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [self.tableView1 tableViewDidFinishedLoading];
        [self.tableView1 noticeNoMoreData];
        return;
    }else {
        _page++;
    }
    
    if (type == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", @"list",@"rtype",@"0",@"aid",@(_page),@"page",@"10",@"pageSize",@"1000", @"source", nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getaddress"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            NSArray *array_count=[dic allKeys];
            if (array_count==0) {
            }else{
                if (type == nil || [type isEqualToString:REFRESH_METHOD]) {
                    [dataAry removeAllObjects];
                }
                NSArray *array=dic[@"data"][@"list"];
                if (array.count==0) {
                }else{
                    isend=[dic[@"data"][@"isEnd"]boolValue];
                }
                
                [dataAry addObjectsFromArray:dic[@"data"][@"list"]];
                [self.tableView1 reloadData];
            }
            
            
            [SVProgressHUD dismiss];
            [self.tableView1 tableViewDidFinishedLoading];
        });
    } failue:^(NSDictionary *dic) {
        [self.tableView1 tableViewDidFinishedLoading];
    }];
}

-(UITableView*)tableView1
{
    if (!_tableView1) {
        self.tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(55)) style:UITableViewStylePlain];
        self.tableView1.delegate=self;
        self.tableView1.dataSource=self;
        self.tableView1.refreshTVDelegate=self;
        self.tableView1.backgroundColor=UIColorFromRGB(0xf4f4f4);
        self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView1];
    }
    return _tableView1;
}

-(void)initbuttomView
{
    UIButton *shouhuoBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(10),WIN_HEIGHT-M_WIDTH(45), WIN_WIDTH-M_WIDTH(20),M_WIDTH(35))];
    [shouhuoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shouhuoBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    shouhuoBtn.backgroundColor=APP_BTN_COLOR;
    shouhuoBtn.layer.masksToBounds=YES;
    shouhuoBtn.layer.cornerRadius=5;
    [shouhuoBtn addTarget:self action:@selector(addTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shouhuoBtn];
}
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(NetWorkRequest:) withObject:REFRESH_METHOD afterDelay:0.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [[NSDate alloc] init];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(NetWorkRequest:) withObject:MORE_METHOD afterDelay:0.f];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    [self.tableView1 tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [self.tableView1 tableViewDidEndDragging:vScrollView];
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return M_WIDTH(110);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_WIDTH(8);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellID1";
    AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier index:indexPath.section];
        cell.dizhiDelegate=self;
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic=dataAry[indexPath.section];
    cell.nameLab.text=[Util isNil:dic[@"name"]];
    cell.phoneLab.text=[Util isNil:dic[@"telephone"]];
    cell.dizhiLab.text=[Util isNil:dic[@"address"]];
    int isDefault=[[Util isNil:dic[@"isDefault"]]intValue];
    
    if (isDefault==1) {
        [cell.zhuangtaiImg setImage:[UIImage imageNamed:@"r_correct"]];
        cell.zhuangtaiLab.text=@"默认地址";
    }else {
        [cell.zhuangtaiImg setImage:[UIImage imageNamed:@"circular"]];
        cell.zhuangtaiLab.text=@"设为默认地址";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_typeStr isEqualToString:@"1"]) {
        NSDictionary *dic=dataAry[indexPath.section];
        NSString *province=[Util isNil:dic[@"id"]];
        if (_dizhiiddelegate && [_dizhiiddelegate respondsToSelector:@selector(setid_contents:)]) {
            [_dizhiiddelegate setid_contents:province];
        }
        [self.delegate.navigationController popViewControllerAnimated:YES];
    }
}


-(void)addTouch
{
    addBool=YES;
    AddaddressController *addVC=[[AddaddressController alloc]init];
    addVC.typeStr=@"0";
    [self.delegate.navigationController pushViewController:addVC animated:YES];
}

-(void)setdelete:(id)deleteIndex
{
    int index=[deleteIndex intValue];
    [self confirm:@"确定要删除吗？" afterOK:^{
        NSDictionary *dic=dataAry[index];
        NSString *dizhiId=[Util isNil:dic[@"id"]];
        NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:dizhiId,@"id",nil];
        [SVProgressHUD showWithStatus:@"数据加载中"];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"deladdress"] parameters:params target:self success:^(NSDictionary *dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",dic);
                [self NetWorkRequest:nil];
            });
        } failue:^(NSDictionary *dic) {
        }];
    }];
}

//----------id类型需要更改 换成 _typeStr------------

-(void)setMoren:(id)morenIndex
{
    int index=[morenIndex intValue];
    NSDictionary *dic=dataAry[index];
    NSString *strUrl = [[Util isNil:dic[@"address"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             [Global sharedClient].member_id, @"member_id",
                             [Util isNil:dic[@"name"]],@"name",
                             @"1",@"id",
                             @([[Util isNil:dic[@"province"]]intValue]), @"province",
                             @([[Util isNil:dic[@"city"]]intValue]),@"city",
                             @([[Util isNil:dic[@"area"]]intValue]),@"area",
                             strUrl,@"address",
                             @"2",@"post_Code",
                             [Util isNil:dic[@"telephone"]],@"telephone",
                             [Util isNil:dic[@"isInformation"]],@"isInformation",
                             @"1",@"isDefault",@"1000", @"source", nil];
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"addaddress"] parameters:params target:self success:^(NSDictionary *dic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            [self NetWorkRequest:nil];
        });
    } failue:^(NSDictionary *dic) {
        
    }];
    
}

-(void)setbianji:(id)bianjiIndex
{
    addBool=YES;
    int index=[bianjiIndex intValue];
    NSDictionary *dic=dataAry[index];
    
    AddaddressController *addVC=[[AddaddressController alloc]init];
    addVC.nameStr       = [Util isNil:dic[@"name"]];
    int par=[[Util isNil:dic[@"province"]]intValue];
    addVC.shengfenidStr = [NSString stringWithFormat:@"%d",par];
    int chengshiid=[[Util isNil:dic[@"city"]]intValue];
    addVC.chengshiidStr = [NSString stringWithFormat:@"%d",chengshiid];
    int area=[[Util isNil:dic[@"area"]]intValue];
    addVC.diquidStr     = [NSString stringWithFormat:@"%d",area];
    addVC.xiangxiStr    = [Util isNil:dic[@"address"]];
    addVC.youzhengStr   = [Util isNil:dic[@"post_code"]];
    addVC.is_jieshouStr = [Util isNil:dic[@"isInformation"]];
    addVC.is_morenStr   = [Util isNil:dic[@"isDefault"]];
    addVC.shoujihaoStr  = [Util isNil:dic[@"telephone"]];
    addVC.youxiang_str  = [Util isNil:dic[@"email"]];
    addVC.typeStr       = [Util isNil:dic[@"id"]];
    [self.delegate.navigationController pushViewController:addVC animated:YES];

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
