//
//  LineUpHomeController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "LineUpHomeController.h"
#import "PullingRefreshTableView.h"
#import "LineUpViewCell.h"
#import "PickController.h"
#import "ReTableView.h"

@interface LineUpHomeController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property (strong,nonatomic)UIView  *rootView;
@end

@implementation LineUpHomeController{
    
    ReTableView  *tableView1;
    NSInteger    page;
    NSMutableArray  *shopidAry;
    NSMutableArray  *booked_idAry;
    NSMutableArray  *booked_statusAry;//预定状态
    NSMutableArray  *floor_nameAry;//地址
    NSMutableArray  *food_typeAry; //食物类型
    NSMutableArray  *logo_img_urlAry;//食物logo
    NSMutableArray  *shop_nameAry;//食物名
    NSMutableArray  *dengdaiAry;//等待人数
    BOOL             isEnd;
    UIView          *headView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    isEnd =false;
    self.navigationBarTitleLabel.text=@"排队领号";
    self.rootView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIN_WIDTH, WIN_HEIGHT-64)];
    self.rootView.backgroundColor=[UIColor whiteColor];
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 1)];
    headView.backgroundColor=[UIColor whiteColor];
    [self.rootView addSubview:headView];
    [self.view addSubview:self.rootView];
    shopidAry           =[[NSMutableArray alloc]init];
    booked_idAry        =[[NSMutableArray alloc]init];
    booked_statusAry    =[[NSMutableArray alloc]init];
    floor_nameAry       =[[NSMutableArray alloc]init];
    food_typeAry        =[[NSMutableArray alloc]init];
    logo_img_urlAry     =[[NSMutableArray alloc]init];
    shop_nameAry        =[[NSMutableArray alloc]init];
    dengdaiAry          =[[NSMutableArray alloc]init];
    [self initTableView];
    [self NetWorkRequest:nil];
}

-(void)initTableView{

    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(headView.frame), WIN_WIDTH, WIN_HEIGHT-65) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.scrollEnabled=YES;
    tableView1.backgroundColor=[UIColor whiteColor];;
    tableView1.refreshTVDelegate=self;
    [self.rootView addSubview:tableView1];
}

-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}

-(void)NetWorkRequest:(NSString*)type
{
    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
        page = 1;
        isEnd = false;
    }else{
        if (isEnd == true) {
            [tableView1 tableViewDidFinishedLoading];
            [tableView1 noticeNoMoreData];
            return;
        }
        page ++;
    }
    
        
    
    int zz=[[Global sharedClient].markID intValue];
    
    [SVProgressHUD showWithStatus:@"数据加载中"];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(page),@"Page",@"10",@"pageSize",nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"queuelist"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            
            if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                [shopidAry             removeAllObjects];
                [booked_idAry          removeAllObjects];
                [booked_statusAry      removeAllObjects];
                [floor_nameAry         removeAllObjects];
                [food_typeAry          removeAllObjects];
                [logo_img_urlAry       removeAllObjects];
                [shop_nameAry          removeAllObjects];
                [dengdaiAry            removeAllObjects];
            }
            isEnd  =[dic[@"data"][@"isEnd"]boolValue];
            NSArray  *dataAry=dic[@"data"][@"queuelist"];
            for (NSDictionary  *dict in dataAry) {
                NSString    *booked_id      = [NSString stringWithFormat:@"%@",[Util isNil:dict[@"booked_id"]]];
                NSString    *booked_status  = [NSString stringWithFormat:@"%@",[Util isNil:dict[@"booked_status"]]];
                NSString    *floor_name     = [Util isNil:dict[@"floor_name"]];
                NSString    *logo_img_url   = [Util isNil:dict[@"logo_img_url"]];
                NSString    *shop_id        = [NSString stringWithFormat:@"%@",[Util isNil:dict[@"shop_id"]]];
                NSString    *shop_name      = [Util isNil:dict[@"shop_name"]];
                NSString    *food_type      = [Util isNil:dict[@"food_type"]];
                NSString    *total_wait_num = [NSString stringWithFormat:@"%@",[Util isNil:dict[@"total_wait_num"]]];
                
                [booked_idAry       addObject:booked_id];
                [booked_statusAry   addObject:booked_status];
                [floor_nameAry      addObject:floor_name];
                [logo_img_urlAry    addObject:logo_img_url];
                [shopidAry          addObject:shop_id];
                [shop_nameAry       addObject:shop_name];
                [food_typeAry       addObject:food_type];
                [dengdaiAry         addObject:total_wait_num];
            }
            [tableView1 reloadData];
            [tableView1 tableViewDidFinishedLoading];
            
            [SVProgressHUD dismiss];
        
        });
    }failue:^(NSDictionary *dic){
    }];
}


//#pragma mark - PullingRefreshTableViewDelegate
//- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(NetWorkRequest:) withObject:REFRESH_METHOD afterDelay:0.f];
//}
//
//- (NSDate *)pullingTableViewRefreshingFinishedDate{
//    return [[NSDate alloc] init];
//}
//
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(NetWorkRequest:) withObject:MORE_METHOD afterDelay:0.f];
//    
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return shop_nameAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return M_WIDTH(75);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_WIDTH(0.1);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellID1";
    LineUpViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[LineUpViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
  
    [cell.bigImgView setImageWithURL:[NSURL URLWithString:logo_img_urlAry[indexPath.row]]];
    cell.nameLab.text=shop_nameAry[indexPath.row];
    cell.explainLab.text=food_typeAry[indexPath.row];
    cell.addressLab.text=floor_nameAry[indexPath.row];
    cell.renshuLab.text=dengdaiAry[indexPath.row];
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    
//    [tableView1 tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PickController *vc=[[PickController alloc]init];
    vc.shopID=shopidAry[indexPath.row];
    [self.delegate.navigationController pushViewController:vc animated:YES];
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
