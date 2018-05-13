//
//  AddShoppingController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ShopeListController.h"
#import "PullingRefreshTableView.h"
#import "ShopTableViewCell.h"
#import "KDSearchBar.h"
#import "IntegralController.h"
#import "GoViewController.h"
#import "ReTableView.h"
@interface ShopeListController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,ZhuRefreshTableView>
@property (strong,nonatomic)NSMutableArray      *dataAry;
@property (strong,nonatomic)UIButton            *lBtn;
@property (strong,nonatomic)UIButton            *rBtn;
@property (strong,nonatomic)UIView              *radView;
@property (strong,nonatomic)KDSearchBar         *homeTextF;

@end

@implementation ShopeListController
{
    BOOL            isend;
    NSInteger       _pageNo;
    ReTableView     *tableView1;
    NSString        *sortStr;
    BOOL            L_R_Btn;//no 是左边，yes是右边
    UIView          *nvcView1;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNo=1;
    isend=NO;
    L_R_Btn=NO;
    sortStr=@"4";
    self.dataAry = [[NSMutableArray alloc]init];
    self.view.backgroundColor=UIColorFromRGB(0xf6f6f6);
    [self initHeadView];
    [self inittableview];
    [self NetWorkRequest :nil];
    [self initnvc];
    
}
-(void)initnvc
{
    
    nvcView1=[[UIView alloc]initWithFrame:CGRectMake(47, STATUS_BAR_HEIGHT + 6, WIN_WIDTH-94, 32)];
    nvcView1.backgroundColor=[UIColor clearColor];
    nvcView1.layer.masksToBounds=YES;
    nvcView1.layer.cornerRadius=5;
    
    self.homeTextF=[[KDSearchBar alloc]initWithFrame:nvcView1.bounds];
    self.homeTextF.newFrame = self.homeTextF.frame;
    self.homeTextF.placeholder=@"请输入想要查找的商品";
    self.homeTextF.delegate=self;
    self.homeTextF.searchBarStyle=UISearchBarStyleMinimal;
    self.homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    self.homeTextF.returnKeyType=UIReturnKeySearch;
    
    [nvcView1 addSubview:self.homeTextF];
    [self.navigationBar addSubview:nvcView1];
    
     UIButton * scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBtn setFrame:self.rigthBarItemView.bounds];
    [scanBtn setImage:[UIImage imageNamed:@"fangzi"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(img_BtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:scanBtn];
    self.rigthBarItemView.hidden = FALSE;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.homeTextF resignFirstResponder];
    [self NetWorkRequest:nil];
}


-(void)initHeadView
{
    
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, M_WIDTH(39)+2)];
    headview.backgroundColor=[UIColor whiteColor];
    self.lBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH/2, M_WIDTH(39))];
    [self.lBtn setBackgroundImage:[UIImage imageNamed:@"r_d_sales"] forState:UIControlStateNormal];
    [self.lBtn addTarget:self action:@selector(lBtn_2) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:self.lBtn];
    
    self.rBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2, 0, WIN_WIDTH/2, M_WIDTH(39))];
    [self.rBtn setBackgroundImage:[UIImage imageNamed:@"n_price"] forState:UIControlStateNormal];
    [self.rBtn addTarget:self action:@selector(rBtn_1) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:self.rBtn];
    _radView =[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(39),SCREEN_FRAME.size.width/2, 2)];
    _radView.backgroundColor=[UIColor redColor];
    [headview addSubview:_radView];
    [self.view addSubview:headview];
}

-(void)lBtn_1
{
    [self btnEnabled_no];
    if (L_R_Btn==YES) {
        [self.rBtn setBackgroundImage:[UIImage imageNamed:@"n_price"] forState:UIControlStateNormal];
        [self.rBtn addTarget:self action:@selector(rBtn_1) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.lBtn setBackgroundImage:[UIImage imageNamed:@"r_d_sales"] forState:UIControlStateNormal];
    [self.lBtn addTarget:self action:@selector(lBtn_2) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.2 animations:^{
       _radView.frame=CGRectMake(0,M_WIDTH(39),SCREEN_FRAME.size.width/2, 2);
    }];
    sortStr=@"4";
    L_R_Btn=NO;
    [self NetWorkRequest:nil];
}

-(void)lBtn_2
{
    [self btnEnabled_no];
    [self.lBtn setBackgroundImage:[UIImage imageNamed:@"r_u_sales"] forState:UIControlStateNormal];
    [self.lBtn addTarget:self action:@selector(lBtn_1) forControlEvents:UIControlEventTouchUpInside];
   
    [UIView animateWithDuration:0.2 animations:^{
        _radView.frame=CGRectMake(0,M_WIDTH(39),SCREEN_FRAME.size.width/2, 2);
    }];
    if (L_R_Btn==YES) {
        [self.rBtn addTarget:self action:@selector(rBtn_1) forControlEvents:UIControlEventTouchUpInside];
    }
    
    sortStr=@"5";
    [self NetWorkRequest:nil];
}


-(void)rBtn_1
{
    [self btnEnabled_no];
    if (L_R_Btn==NO) {
        [self.lBtn setBackgroundImage:[UIImage imageNamed:@"n_sales"] forState:UIControlStateNormal];
    }
    [self.lBtn addTarget:self action:@selector(lBtn_1) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.2 animations:^{
        _radView.frame=CGRectMake(SCREEN_FRAME.size.width/2,M_WIDTH(39),SCREEN_FRAME.size.width/2, 2);
    }];
    [self.rBtn setBackgroundImage:[UIImage imageNamed:@"r_d_price"] forState:UIControlStateNormal];
    [self.rBtn addTarget:self action:@selector(rBtn_2) forControlEvents:UIControlEventTouchUpInside];
    sortStr=@"1";
    L_R_Btn=YES;
    [self NetWorkRequest:nil];
}
-(void)rBtn_2
{
    [self btnEnabled_no];
   
    [self.lBtn addTarget:self action:@selector(lBtn_1) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.2 animations:^{
        _radView .frame=CGRectMake(SCREEN_FRAME.size.width/2,M_WIDTH(39),SCREEN_FRAME.size.width/2, 2);
    }];
    [self.rBtn setBackgroundImage:[UIImage imageNamed:@"r_u_price"] forState:UIControlStateNormal];
    [self.rBtn addTarget:self action:@selector(rBtn_1) forControlEvents:UIControlEventTouchUpInside];
    sortStr=@"2";
    [self NetWorkRequest:nil];
}
-(void)btnEnabled_yes
{
    self.lBtn.enabled=YES;
    self.rBtn.enabled=YES;
}
-(void)btnEnabled_no
{
    self.rBtn.enabled=NO;
    self.rBtn.enabled=NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_WIDTH(10);
}
-(void)tableView_refresh:(NSString *)type1{
    [self NetWorkRequest:type1];
}
-(void)NetWorkRequest : (NSString *)index
{
    if (index == nil || [index isEqualToString:REFRESH_METHOD]) {
        _pageNo = 1;
        isend=NO;
    }else if (isend==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [tableView1 tableViewDidFinishedLoading];
        [tableView1 noticeNoMoreData];
        return;
    }else {
        _pageNo++;
    }
    if (index == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    NSString *keyStr;
    if ([self.homeTextF.text isEqualToString:@""]) {
        keyStr=@"";
    }else {
        keyStr=self.homeTextF.text;
    }
    

    int zz=[[Global sharedClient].markID intValue];
    int sort=[sortStr intValue];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"integral_goods_list"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:@(sort),@"sort",@(0),@"type",@(0),@"small_type",@(0),@"s_type",@(zz),@"mall_id",@(_pageNo),@"page",@"10",@"pageSize",keyStr,@"Key",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == nil || [index isEqualToString:REFRESH_METHOD]) {
                [self.dataAry removeAllObjects];
            }
            [self.dataAry addObjectsFromArray:dic[@"data"][@"integralgoodslist"] ];
            isend=[dic[@"data"][@"isEnd"]intValue];
            [tableView1 reloadData];
            [tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
            [self btnEnabled_yes];
        });
    }failue:^(NSDictionary *dic){
            [self btnEnabled_yes];
    }];
}

-(void)inittableview{
    [Global sharedClient].is_EndheadRefresh=YES;
    tableView1 =[[ReTableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+M_WIDTH(39)+2, WIN_WIDTH, self.view.frame.size.height-NAV_HEIGHT-M_WIDTH(39)-2) style:UITableViewStylePlain];
    tableView1.dataSource=self;
    tableView1.delegate  =self;
    tableView1.scrollEnabled=YES;
    tableView1.backgroundColor=UIColorFromRGB(0xf0f0f0);
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    [Global sharedClient].is_EndheadRefresh=NO;
    tableView1.refreshTVDelegate=self;
    [self.view addSubview:tableView1];
    
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
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ceilf(_dataAry.count/2.0);
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return M_WIDTH(161)+81;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseIdentifier=@"ShopTableViewCell";
    ShopTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:reuseIdentifier owner:nil options:nil]firstObject];
    }
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    NSDictionary *dic1=self.dataAry[indexPath.row*2];
    cell.leftView.tag=indexPath.row*2;
    cell.rightView.tag=indexPath.row*2+1;
    [cell.leftView addGestureRecognizer:tapGesture];
    [cell.leftView addGestureRecognizer:tapGesture];
    [cell.leftImgView setImageWithURL:[NSURL URLWithString:[Util isNil:dic1[@"img_url"]]]];
    cell.lnameLabel.text=[Util isNil:dic1[@"title"]];
    int jifen_l=[[Util isNil:dic1[@"integral"]]intValue];
    cell.ljfLabel.text=[NSString stringWithFormat:@"%d%@",jifen_l,@"星积分"];
    cell.lCountLabel.text=@"123";
    int freight_type=[[Util isNil:dic1[@"freight_type"]]intValue];
    int is_virtual  =[[Util isNil:dic1[@"is_virtual"]]intValue];
    if (is_virtual==0) {
        if(freight_type==0){
            cell.lkdBtn.hidden=YES;
        }else {
            cell.lkdTrailConst=0;
            cell.lkdBtn.hidden=NO;
        }
        cell.lztBtn.hidden=YES;
    }

    if((indexPath.row+1)*2  > self.dataAry.count){
        cell.rightView.hidden=YES;
    }else{
        NSDictionary *dic2=self.dataAry[indexPath.row*2 +1];
        [cell.rightImgView setImageWithURL:[NSURL URLWithString:[Util isNil:dic2[@"img_url"]]]];
        cell.rnameLabel.text=[Util isNil:dic2[@"title"]];
        int jifen_l=[[Util isNil:dic2[@"integral"]]intValue];
        cell.rjfLabel.text=[NSString stringWithFormat:@"%d%@",jifen_l,@"星积分"];
        cell.rCountLabel.text=@"123";
        int freight_type1=[[Util isNil:dic2[@"freight_type"]]intValue];
        int is_virtual1  =[[Util isNil:dic2[@"is_virtual"]]intValue];
        if (is_virtual1==0) {
            if(freight_type1==0){
                cell.rkdBtn.hidden=YES;
            }else {
                cell.rkdTrailConst=0;
                cell.rkdBtn.hidden=NO;
            }
            cell.rztBtn.hidden=YES;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=UIColorFromRGB(0xf0f0f0);
    return cell;
}
- (void)event:(UITapGestureRecognizer *)gesture
{
    NSDictionary *dic1=self.dataAry[gesture.view.tag];
    GoViewController *vc=[[GoViewController alloc]init];
    vc.path=[Util isNil:dic1[@"integral_detail"]];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
-(void)img_BtnTouch:(UIButton*)sender
{
//    IntegralController *iVC=[[IntegralController alloc]init];
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    [self.homeTextF resignFirstResponder];
//    [tableView1 tableViewDidScroll:vScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
