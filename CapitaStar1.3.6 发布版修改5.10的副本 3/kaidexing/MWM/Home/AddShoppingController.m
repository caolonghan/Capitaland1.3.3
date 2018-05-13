//
//  AddShoppingController.m
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AddShoppingController.h"
#import "PullingRefreshTableView.h"
#import "addShopingCell.h"
#import "ReTableView.h"

@interface AddShoppingController ()<UITableViewDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,addshopTouch,ZhuRefreshTableView>
@property (nonatomic)       UICollectionView    *collectionView1;
@property (strong,nonatomic)NSMutableArray      *titleAry;//保存商场信息的数组
@property (strong,nonatomic)NSMutableArray      *imgAry;//保存商场图片的数组（正方形图片）
@property (strong,nonatomic)NSMutableArray      *idAry;//保存商场ID的数组
@property (strong,nonatomic)NSMutableArray      *isFouceAry;//判断是否关注
@property (strong,nonatomic)NSMutableArray      *mall_idAry;//
@property (strong,nonatomic)NSMutableArray      *remAry;
@property (strong,nonatomic)NSMutableArray      *addAry;


@end

@implementation AddShoppingController
{
    BOOL     isend;
    NSInteger  _pageNo;
    ReTableView     *tableView1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleAry    = [[NSMutableArray alloc]init];
    self.imgAry      = [[NSMutableArray alloc]init];
    self.idAry       = [[NSMutableArray alloc]init];
    self.isFouceAry  = [[NSMutableArray alloc]init];
    self.remAry      = [[NSMutableArray alloc]init];
    self.addAry      = [[NSMutableArray alloc]init];
    _pageNo=1;
    isend=NO;
    self.view.backgroundColor=UIColorFromRGB(0xf6f6f6);
    [self inittableview];
    [self NetWorkRequest :nil];
    [self initqueren];
}

-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}

-(void)NetWorkRequest : (NSString *)page
{
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    NSString *cityStr;
    NSUserDefaults *userCity=[NSUserDefaults standardUserDefaults];
    if ([userCity valueForKey:@"city"]==nil) {
        cityStr=@"1";
    }else{
        cityStr=[userCity valueForKey:@"city"];
        
    }
    NSDictionary  *dicton=[[NSDictionary alloc]initWithObjectsAndKeys:cityStr,@"city",[Global sharedClient].member_id,@"member_id",nil ];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadmalllist"] parameters:dicton  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
         
        [self.idAry         removeAllObjects];
        [self.titleAry      removeAllObjects];
        [self.imgAry        removeAllObjects];
        [self.isFouceAry    removeAllObjects];
  
        NSArray *array=dic[@"data"][@"fouce_malllist"];
    
        for (NSDictionary *dict in array) {
            NSString  *mall_name= [Util isNil:dict[@"mall_name"]];
            NSString  *idStr    = [Util isNil:dict[@"mall_id"]];
            NSString  *isfouce  = [Util isNil:dict[@"isFouce"]];
            NSString  *logoStr  = [Util isNil:dict[@"mall_logo_img_url"]];
            
            [_addAry addObject:idStr];
            [self.titleAry      addObject:mall_name];
            [self.idAry         addObject:idStr];
            [self.isFouceAry    addObject:isfouce];
            [self.imgAry        addObject:logoStr];
        }
           NSArray *array1=dic[@"data"][@"nofouce_malllist"];
            for (NSDictionary *dict1 in array1) {
                NSString  *mall_name= [Util isNil:dict1[@"mall_name"]];
                NSString  *idStr    = [Util isNil:dict1[@"mall_id"]];
                NSString  *isfouce  = [Util isNil:dict1[@"isFouce"]];
                NSString  *logoStr  = [Util isNil:dict1[@"mall_logo_img_url"]];
                
                [_remAry addObject:idStr];
                [self.titleAry      addObject:mall_name];
                [self.idAry         addObject:idStr];
                [self.isFouceAry    addObject:isfouce];
                [self.imgAry        addObject:logoStr];
            }

            [tableView1 reloadData];
        
//            NSString *titltStr=[NSString stringWithFormat:@"%@%ld%@",@"我已关注的商场(",_addAry.count,@")"];
//            self.navigationBarTitleLabel.text=titltStr;
             [tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}

-(void)inittableview{
    [Global sharedClient].is_EndheadRefresh=YES;
    tableView1 =[[ReTableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, self.view.frame.size.height-NAV_HEIGHT-M_WIDTH(47)) style:UITableViewStylePlain];
    tableView1.dataSource=self;
    tableView1.delegate  =self;
    tableView1.scrollEnabled=YES;
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    [Global sharedClient].is_EndheadRefresh=NO;
    tableView1.refreshTVDelegate=self;
    [self.view addSubview:tableView1];
    
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ceilf(_titleAry.count/2.0);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (WIN_WIDTH-22)/2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 9;
    }else{
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseIdentifier=@"cell1";
    addShopingCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[addShopingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier index:indexPath.section];
        cell.addDelegate=self;
    }
    
    NSString* title = self.titleAry[indexPath.section*2];
    NSString *mall_logo_img_url;
    if ([Util isNull:self.imgAry[indexPath.section*2]]) {
        mall_logo_img_url=@"nilimg";
        [cell.logoImg2 setImage:[UIImage imageNamed:mall_logo_img_url]];
    }else {
    }
    
    cell.shopName1.text = title;
    
    int   celltag=[self.isFouceAry[indexPath.section*2] intValue];
    if (celltag==1) {
        
        [cell.typeImg1 setImage:[UIImage imageNamed:@"ICON-r"]];
        [cell.colorView1 setImage:[UIImage imageNamed:@"black_30"]];
    }else {
        
        [cell.typeImg1 setImage:[UIImage imageNamed:@"ICON-b"]];
        [cell.colorView1 setImage:[UIImage imageNamed:@""]];
    }
    
    if((indexPath.section+1)*2  > self.titleAry.count){
        cell.view2.hidden = YES;
        
    }else{
        title = self.titleAry[indexPath.section*2+1];
        cell.shopName2.text = title;
        NSString *mall_logo_img_url1;
        if ([Util isNull:self.imgAry[indexPath.section*2+1]]) {
            mall_logo_img_url1=@"nilimg";
            [cell.logoImg2 setImage:[UIImage imageNamed:mall_logo_img_url1]];
        }else{
        }
        
        int   celltag2=[self.isFouceAry[indexPath.section*2 +1] intValue];
        if (celltag2==1) {
            [cell.typeImg2 setImage:[UIImage imageNamed:@"ICON-r"]];
            [cell.colorView2 setImage:[UIImage imageNamed:@"black_30"]];
        }else  {
            [cell.typeImg2 setImage:[UIImage imageNamed:@"ICON-b"]];
            [cell.colorView2 setImage:[UIImage imageNamed:@""]];
        }
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

//确认关注按钮
-(void)initqueren
{
    UIView  *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView1.frame), WIN_WIDTH, M_WIDTH(47))];
    bottomView.backgroundColor=[UIColor whiteColor];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(8), M_WIDTH(6), WIN_WIDTH-M_WIDTH(16), M_WIDTH(35))];
    btn.backgroundColor=APP_BTN_COLOR;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"确认关注" forState:UIControlStateNormal];
    btn.titleLabel.font=BIG_FONT;
    [btn addTarget:self action:@selector(querenTouch) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    [self.view addSubview:bottomView];
}
-(void)querenTouch
{
    NSString *str;
    NSString *str2;
    if (_addAry.count == 0) {
        str=@"";
    }else if(_addAry.count == 1){
        str = _addAry[0];
    }else if(_addAry.count >1){
        str =_addAry[0];
        for (NSInteger  i=1; i<_addAry.count; i++) {
            str=[NSString stringWithFormat:@"%@,%@",str,_addAry[i]];
        }
    }
    
    if (_remAry.count ==0) {
        str2=@"";
    }else if(_remAry.count == 1){
        str2 = _remAry[0];
    }else if(_remAry.count >1){
        str2=_remAry[0];
        for (NSInteger  j=1; j<_remAry.count; j++) {
            str2=[NSString stringWithFormat:@"%@,%@",str2,_remAry[j]];
        }
    }
    
    NSDictionary *dicton=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id ,@"member_id",str,@"colllist_id",str2,@"ncollist_id",nil];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"collection" tp:@"sureattentionlist"] parameters:dicton  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_remAry removeAllObjects];
                [_addAry removeAllObjects];
                if (_guanzhuDelegate &&[_guanzhuDelegate respondsToSelector:@selector(setguanzhu:)]) {
                    [_guanzhuDelegate setguanzhu:nil];
                }
                [self.delegate.navigationController popViewControllerAnimated:YES];
                
            });
        }failue:^(NSDictionary *dic){
            
        }];
}


//返回代理
-(void)setaddshopTouch1:(id)addshopindex
{
    int       index=[addshopindex intValue];
    id  isfouce=_idAry[index];
    int  isf  =[_isFouceAry[index]intValue];
    
    if (isf==1) {
        [_remAry addObject:isfouce];
        [_addAry removeObject:isfouce];
        [_isFouceAry replaceObjectAtIndex:index withObject:@"0"];
    }else if(isf==0){
        [_addAry addObject:isfouce];
        [_remAry removeObject:isfouce];
        [_isFouceAry replaceObjectAtIndex:index withObject:@"1"];
    }
    
    [tableView1 reloadData];
}

//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    
//    [tableView1 tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
//  
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
