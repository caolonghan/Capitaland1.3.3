//
//  FollowViewController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "FollowViewController.h"
#import "AddShoppingController.h"
#import "MJRefresh.h"
#import "FollowCell.h"
@interface FollowViewController ()<UITableViewDelegate,UITableViewDataSource,follTouch>

@property (nonatomic)UICollectionView        *collectionView;

@property (strong,nonatomic)NSMutableArray      *titleAry;//保存商场信息的数组
@property (strong,nonatomic)NSMutableArray      *imgAry;//保存商场图片的数组（正方形图片）
@property (strong,nonatomic)NSMutableArray      *idAry;//保存商场ID的数组
@property (strong,nonatomic)UITableView         *tableView1;
@property (strong,nonatomic)NSMutableArray      *cookieAry;

@end

@implementation FollowViewController
{
    NSInteger  _pageNo;
    UIView      *nvcontrView;
    UIView      *nilView1;
    BOOL        shuaxin;
}

-(void)viewWillAppear:(BOOL)animated{
    [self initLeftPOP];
    if (shuaxin==YES) {
        shuaxin=NO;
        [self.tableView1 removeFromSuperview];
        [self inittableview];
        [self NetWorkRequest];
    }
}

-(void)initLeftPOP{
    nvcontrView = [[UIView alloc] initWithFrame:CGRectMake(WIN_WIDTH-60,20,60,44)];//
    nvcontrView.backgroundColor=[UIColor clearColor];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:nvcontrView.bounds];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
     btn.titleLabel.font=COMMON_FONT;
    [btn  setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gengguoTouch) forControlEvents:UIControlEventTouchUpInside];
    [nvcontrView addSubview:btn];
    [self.navigationBar addSubview:nvcontrView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    shuaxin=NO;
    self.navigationBarTitleLabel.text=@"我关注的商场";
    self.view.backgroundColor=RGBCOLOR(222, 222, 222);
    self.titleAry =[[NSMutableArray alloc]init];
    self.imgAry   =[[NSMutableArray alloc]init];
    self.idAry    =[[NSMutableArray alloc]init];
    self.cookieAry=[[NSMutableArray alloc]init];
    _pageNo=1;
    self.view.backgroundColor=UIColorFromRGB(0xf6f6f6);
    [self inittableview];
    [self NetWorkRequest];
}


-(void)NetWorkRequest
{
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    [self.titleAry  removeAllObjects];
    [self.imgAry    removeAllObjects];
    [self.idAry     removeAllObjects];
    [self.cookieAry removeAllObjects];
    [nilView1 removeFromSuperview];

    NSString *cityStr;
    NSUserDefaults *userCity=[NSUserDefaults standardUserDefaults];
    if ([userCity valueForKey:@"city"]==nil) {
        cityStr=@"1";
    }else{
        cityStr=[userCity valueForKey:@"city"];
        
    }
    NSDictionary  *dicton=[[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"city",[Global sharedClient].member_id,@"member_id",@"100",@"pageSize",@"1",@"Page",nil ];
    
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadmalllist"] parameters:dicton  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *array=dic[@"data"][@"malllist"];
            
            for (NSDictionary *dict in array) {
                NSString *isFouce=dict[@"isFouce"];
                int dd=[isFouce intValue];
                if (dd==1) {
                    NSString  *mall_name= [Util isNil:dict[@"mall_name"]];
                    NSString  *idStr    = [Util isNil:dict[@"mall_id"]];
                    NSString  *logoStr  = [Util isNil:dict[@"mall_logo_img_url"]];
                    NSString  *cookie   = [Util isNil:dict[@"mall_id_des"]];
                    
                    [self.titleAry addObject:mall_name];
                    [self.idAry    addObject:idStr];
                    [self.imgAry   addObject:logoStr];
                    [self.cookieAry addObject:cookie];
                }
            }
            [self.tableView1 reloadData];
            [SVProgressHUD dismiss];
            if (_titleAry.count==0) {
                [self initnilView];
            }
        });
    }failue:^(NSDictionary *dic){
    }];
}

//没有数据的时候显示的View
-(void)initnilView{
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
}

-(void)inittableview{
    self.tableView1 =[[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, self.view.frame.size.height-NAV_HEIGHT) style:UITableViewStylePlain];
    self.tableView1.dataSource=self;
    self.tableView1.delegate  =self;
    self.tableView1.scrollEnabled=YES;
    self.tableView1.backgroundColor=RGBCOLOR(222, 222, 222);
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView1];
}

#pragma mark - PullingRefreshTableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ceilf(_titleAry.count/2.0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (WIN_WIDTH-22)/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 9;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
    
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor=RGBCOLOR(222, 222, 222);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier=@"cell1";
    FollowCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[FollowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier index:indexPath.section];
        cell.follDelegate=self;
    }
    
    NSString* title = self.titleAry[indexPath.section*2];
//    NSString *mall_logo_img_url =[NSString stringWithFormat:@"%@%@",HTTP_Img,self.imgAry[indexPath.section*2]];
  
    cell.shopName1.text = title;
//    [cell.logoImg1 setImageWithURL:[NSURL URLWithString:mall_logo_img_url]];
    
    
    if((indexPath.section+1)*2  > self.titleAry.count){
        cell.view2.hidden = YES;
        
    }else{
        title = self.titleAry[indexPath.section*2+1];
        cell.shopName2.text = title;
//        NSString *mall_logo_img_url1 =[NSString stringWithFormat:@"%@%@",HTTP_Img,self.imgAry[indexPath.section*2+1]];
//        [cell.logoImg2 setImageWithURL:[NSURL URLWithString:mall_logo_img_url1]];
    }

    cell.backgroundColor=RGBCOLOR(222, 222, 222);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
//返回代理
-(void)setindexTouch:(id)follTouch{
    int   celltag=[follTouch intValue];
    [Global sharedClient].shopName = self.titleAry[celltag-1];
    [Global sharedClient].markID   = self.idAry[celltag-1];
    [Global sharedClient].isFouce  = @"1";
    [Global sharedClient].markCookies  =self.cookieAry[celltag-1];
    [Global sharedClient].action   = @"1";
    [self.delegate.navigationController popViewControllerAnimated:NO];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [nvcontrView removeFromSuperview];
}

-(void)gengguoTouch
{
    shuaxin=YES;
    AddShoppingController *adVC=[[AddShoppingController alloc]init];
    [self.delegate.navigationController pushViewController:adVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
