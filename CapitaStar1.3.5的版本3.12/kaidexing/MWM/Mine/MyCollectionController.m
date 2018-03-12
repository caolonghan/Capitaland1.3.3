//
//  MyCollectionController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/11.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyCollectionController.h"
#import "MyCollectionTableViewCell.h"
#import "ActivityViewCell.h"
#import "SoreDiscountsController.h"
#import "PullingRefreshTableView.h"
#import "SoreDiscountsController.h"
#import "RegistrationController.h"
#import "GroupViewController.h"
#import "GoViewController.h"
#import "ReTableView.h"

@interface MyCollectionController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>

@property (strong,nonatomic)UIView          *hiddenView;//rootview/
@property (strong,nonatomic)UISearchBar     *textField1;//搜索框
@property (strong,nonatomic)UISegmentedControl   *segment;
@property (strong,nonatomic)NSMutableArray  *dataAry;//所有数据

@end

@implementation MyCollectionController
{
    NSArray             *array;
    UIView              *nvcView;
    NSMutableArray      *act_detailAry;//商户链接
    NSMutableArray      *IdAry;//商户id
    NSMutableArray      *titleAry;//商户名字
    NSMutableArray      *typeAry;//商户类型说明
    NSMutableArray      *floor_nameAry;//商户地址
    NSMutableArray      *img_urlAry;//商户图片
    NSMutableArray      *mall_id_Ary;//商户id
    NSMutableArray      *urlAry;//H5
    NSMutableArray      *act_typeAry;
    
    NSMutableString     *tpStr;
    NSMutableString     *urlStr;
    
    NSString            *_activityType;
    CGFloat             view_H;
    NSMutableArray      *ShopFloorAry;//楼层名字
    NSMutableArray      *ShopFloorID;//楼层ID
    NSMutableArray      *ShopTypeAry;//业态名字
    NSMutableArray      *ShopTypeID;//业态ID
    
    NSString *floorID;//返回的楼层ID
    NSString *typeID; //返回的业态ID
    
    UIView *nilView1; //主界面没有数据
    
    ReTableView * tableView1;
    
    int            _page;//页数
    BOOL           isEnd;//是否有数据
 
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];


}

-(void)PopViewController
{
    [self.delegate.navigationController popViewControllerAnimated:YES];
}

-(void)initnvc
{
    nvcView = [[UIView alloc] initWithFrame:CGRectMake(44,STATUS_BAR_HEIGHT,WIN_WIDTH-44 - 10,43)];//
    nvcView.backgroundColor=APP_BTN_COLOR;
    
    _segment = [[UISegmentedControl alloc]initWithItems:nil];
    _segment.frame=CGRectMake(0,8,WIN_WIDTH-66,27);
    _segment.tintColor=[UIColor whiteColor];
    [_segment insertSegmentWithTitle: @"我的收藏商户" atIndex: 0 animated: NO ];
    [_segment insertSegmentWithTitle: @"商户活动"     atIndex: 1 animated: NO ];
    [_segment insertSegmentWithTitle: @"商场活动"     atIndex: 2 animated: NO ];
    //segment.segmentedControlStyle= UISegmentedControlStyleBar;
    _segment.selectedSegmentIndex =0;//设置默认选择项索引
    //设置跳转的方法
    [_segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [nvcView addSubview:_segment];
    [self.navigationBar addSubview:nvcView];
}

-(void)change:(UISegmentedControl *)Seg{
    
    switch (Seg.selectedSegmentIndex) {
            
        case 0:{
            isEnd           =false;
            tpStr.string=@"merchantcolllist";
            urlStr.string=@"usercenter";
            _page=1;
            _activityType=@"0";
            
            [self NetWorkRequest:nil];
            break;
        }
        case 1:{
            isEnd           =false;
            _page=1;
            tpStr.string=@"actmerchantcolllist";
            urlStr.string=@"usercenter";
            //清空数据
            _activityType=@"1";
            [self NetWorkRequest:nil];
            break;
        }
        case 2:{
            isEnd           =false;
            _page=1;
            tpStr.string=@"actmallcolllist";
            urlStr.string=@"usercenter";
            //清空数据
            _activityType=@"2";
            [self NetWorkRequest:nil];
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    act_detailAry   =[[NSMutableArray alloc]init];
    IdAry           =[[NSMutableArray alloc]init];
    titleAry        =[[NSMutableArray alloc]init];
    typeAry         =[[NSMutableArray alloc]init];
    floor_nameAry   =[[NSMutableArray alloc]init];
    img_urlAry      =[[NSMutableArray alloc]init];
    mall_id_Ary     =[[NSMutableArray alloc]init];
    urlAry          =[[NSMutableArray alloc]init];
    act_typeAry     =[[NSMutableArray alloc]init];
    
    ShopFloorAry    =[[NSMutableArray alloc]init];
    ShopFloorID     =[[NSMutableArray alloc]init];
    ShopTypeAry     =[[NSMutableArray alloc]init];
    ShopTypeID      =[[NSMutableArray alloc]init];
    
    isEnd           =false;
    tpStr           =[[NSMutableString alloc]initWithString:@"merchantcolllist"];
    urlStr          =[[NSMutableString alloc]initWithString:@"usercenter"];
    _activityType=@"0";
    floorID=@"0";
    typeID =@"0";
    _page=1;
    
    [self initHiddenView];
    [self initTableView];
    
    [self initnvc];
    [self NetWorkRequest:nil];//获取数据
}

-(void)tableView_refresh:(NSString *)type{
    [self NetWorkRequest:type];
}

#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString *)type
{
    
    NSString *string=[Util makeRequestUrl:urlStr tp:tpStr];

    NSDictionary*diction;
   
    //判断界面是否是空界面
   
    [nilView1 removeFromSuperview];

     if(type == nil || [type isEqualToString:REFRESH_METHOD]){
         _page=1;
         isEnd = false;
     }else {
         if (isEnd == true) {
             [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
             [tableView1 tableViewDidFinishedLoading];
             [tableView1 noticeNoMoreData];
             return;
         }
         _page++;
      }
    
        if (type == nil ) {
            [SVProgressHUD showWithStatus:@"正在努力加载中"];
        }
    
        if ([_activityType isEqualToString:@"0"]) {
            diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@(1000),@"source",@(_page),@"Page",@"10",@"pageSize",self.textField1.text,@"Key", nil];
            
        }else if ([_activityType isEqualToString:@"1"]) {
            diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@(_page),@"Page",@"10",@"pageSize",@(1000),@"source",self.textField1.text,@"Key", nil];
        }else if ([_activityType isEqualToString:@"2"]){
            diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@(_page),@"Page",@"10",@"pageSize",@(1000),@"source",self.textField1.text,@"Key", nil];
        }

    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    
    [HttpClient requestWithMethod:@"POST" path:string parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                [act_detailAry  removeAllObjects];
                [IdAry          removeAllObjects];
                [titleAry       removeAllObjects];
                [typeAry        removeAllObjects];
                [floor_nameAry  removeAllObjects];
                [img_urlAry     removeAllObjects];
                [mall_id_Ary    removeAllObjects];
                [urlAry         removeAllObjects];
                [act_typeAry    removeAllObjects];
            }
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"%@",dic[@"data"]);
                
                if ([_activityType isEqualToString:@"0"]) {
                    NSArray *dataAry =dic[@"data"][@"merchantist"];
                     isEnd   =[dic[@"data"][@"isEnd"]boolValue];
                    for (NSDictionary *dict in dataAry) {
                        NSString *idStr         = [Util isNil:dict[@"connectionid"]];
                        NSString *act_detailStr = [Util isNil:dict[@"act_detail"]];
                        NSString *img_urlStr    = [Util isNil:dict[@"logo_img_url"]];
                        NSString *titleStr      = [Util isNil:dict[@"shop_name"]];
                        NSString *typeStr       = [Util isNil:dict[@"mall_name"]];
                        NSString *floor_nameStr = [Util isNil:dict[@"floor_name"]];
                        NSString *shopdetail_url= [Util isNil:dict[@"shopdetail_url"]];
                        [IdAry          addObject:idStr];
                        [act_detailAry  addObject:act_detailStr];
                        [img_urlAry     addObject:img_urlStr];
                        [titleAry       addObject:titleStr];
                        [typeAry        addObject:typeStr];
                        [floor_nameAry  addObject:floor_nameStr];
                        [urlAry         addObject:shopdetail_url];
                        
                    }
                    
                }else if ([_activityType isEqualToString:@"1"]) {
                    NSArray *dataAry =dic[@"data"][@"actmerchantlist"];
                      isEnd   =[dic[@"data"][@"isEnd"]boolValue];
                    NSLog(@"%@",dataAry);
                    for (NSDictionary *dict in dataAry) {
                        NSString *idStr         = [Util isNil:dict[@"connectionid"]];
                        NSString *act_detailStr = [Util isNil:dict[@"act_detail"]];
                        NSString *img_urlStr    = [Util isNil:dict[@"img_url"]];
                        NSString *titleStr      = [Util isNil:dict[@"title"]];
                        NSString *typeStr       = [Util isNil:dict[@"type"]];
                        NSString *floor_nameStr = [Util isNil:dict[@"floor_name"]];
                        NSString *act_type      = [Util isNil:dict[@"act_type"]];
            
                        [IdAry          addObject:idStr];
                        [act_detailAry  addObject:act_detailStr];
                        [img_urlAry     addObject:img_urlStr];
                        [titleAry       addObject:titleStr];
                        [typeAry        addObject:typeStr];
                        [floor_nameAry  addObject:floor_nameStr];
                        [act_typeAry    addObject:act_type];
                    }
                    
                }else if([_activityType isEqualToString:@"2"]){
                    NSArray *dataAry =dic[@"data"][@"actmalllist"];
                    isEnd   =[dic[@"data"][@"isEnd"]boolValue];
                    NSLog(@"%@",dataAry);
                    for (NSDictionary *dict in dataAry) {
                        NSString *idStr         = [Util isNil:dict[@"connectionid"]];
                        NSString *img_urlStr    = [Util isNil:dict[@"img_url"]];
                        NSString *mall_id       = [Util isNil:dict[@"mall_id"]];
                        NSString *titleStr      = [Util isNil:dict[@"mall_name"]];
                        NSString *typeStr       = [Util isNil:dict[@"name"]];
                        NSString *act_detailStr = [Util isNil:dict[@"act_detail"]];
                         NSString *act_type      = [Util isNil:dict[@"type"]];
                        [IdAry            addObject:idStr];
                        [act_detailAry    addObject:act_detailStr];
                        [img_urlAry       addObject:img_urlStr];
                        [titleAry         addObject:titleStr];
                        [typeAry          addObject:typeStr];
                        [mall_id_Ary      addObject:mall_id];
                        [act_typeAry      addObject:act_type];
                    }
                    
                }
            }
            [tableView1 tableViewDidFinishedLoading];
            [tableView1 reloadData];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];


}

#pragma mark ---创建搜索视图---

-(void)initHiddenView
{
    self.hiddenView=[[UIView alloc]initWithFrame:self.view.bounds];
    self.hiddenView.backgroundColor=UIColorFromRGB(0xf0f0f0);
    
    view_H=NAV_HEIGHT;
   
    self.textField1=[[UISearchBar alloc]initWithFrame:CGRectMake(8, view_H+7, WIN_WIDTH-16, 27)];
    self.textField1.delegate=self;
    self.textField1.layer.masksToBounds=YES;
    self.textField1.layer.cornerRadius=5;
    self.textField1.backgroundColor=[UIColor whiteColor];
    self.textField1.placeholder=@"搜店铺、找优惠";
    self.textField1.keyboardType=UIKeyboardAppearanceDefault;
    self.textField1.returnKeyType=UIReturnKeySearch;
    self.textField1.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.textField1.bounds.size];
    [self.hiddenView addSubview:self.textField1];

    view_H=view_H+41;
    
    [self.view addSubview:self.hiddenView];
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)initTableView
{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,view_H, WIN_WIDTH, self.view.frame.size.height-view_H) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor whiteColor];
    tableView1.scrollEnabled=YES;
    tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView1.refreshTVDelegate=self;
    [self.hiddenView addSubview:tableView1];
    
    
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
    
    return titleAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return M_WIDTH(75);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     
        static NSString *reuseIdentifier=@"cellID1";
        
        MyCollectionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell==nil) {
            cell=[[MyCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        UIView *deleView=[cell viewWithTag:1000];
        [deleView removeFromSuperview];
    
        UILabel       *typeLab=[[UILabel alloc]init];
    
        UIImageView *colorView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(89),M_WIDTH(27), M_WIDTH(76.5), M_WIDTH(22))];
        [colorView setImage:[UIImage imageNamed:@"cancel111"]];
        [colorView setUserInteractionEnabled:YES];
    
        UIButton *duihuanBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(89),M_WIDTH(22), M_WIDTH(77), M_WIDTH(35))];
        duihuanBtn.tag=indexPath.row;
        
        [duihuanBtn addTarget:self action:@selector(duihuanTouch:) forControlEvents:UIControlEventTouchUpInside];
    
        [cell.bigImgView setImageWithURL:[NSURL URLWithString:img_urlAry[indexPath.row]]];
        cell.nameLab.text   =titleAry[indexPath.row];
        [cell.nameLab sizeToFit];
        cell.explainLab.text=typeAry[indexPath.row];
    
        if ([_activityType isEqualToString:@"2"]) {
            [cell.img_Down1 setImage:[UIImage imageNamed:@""]];
            cell.addressLab.text=@"";
        }else {
            [cell.img_Down1 setImage:[UIImage imageNamed:@"diqu"]];
            cell.addressLab.text=floor_nameAry[indexPath.row];
        }
    
        typeLab.frame=CGRectMake(CGRectGetMaxX(cell.nameLab.frame)+M_WIDTH(5),M_WIDTH(10),M_WIDTH(16),M_WIDTH(16));
        typeLab.textColor=[UIColor whiteColor];
        typeLab.textAlignment=NSTextAlignmentCenter;
        typeLab.tag=1000;
        typeLab.font=DESC_FONT;
        if ([_activityType isEqualToString:@"1"]) {
           int actInt=[act_typeAry[indexPath.row]intValue];
            if (actInt==0) {
                typeLab.text=@"促";
                typeLab.backgroundColor=[UIColor orangeColor];
            }else if(actInt==2){
                typeLab.text=@"券";
                typeLab.backgroundColor=[UIColor greenColor];
            }else if(actInt==4){
                typeLab.text=@"报";
                typeLab.backgroundColor=[UIColor redColor];
            }
            [cell addSubview:typeLab];
            
        
        }else if ([_activityType isEqualToString:@"2"]) {
            int actInt=[act_typeAry[indexPath.row]intValue];
            if (actInt==0 ||actInt==1){
                typeLab.text=@"促";
                typeLab.backgroundColor=[UIColor orangeColor];
            }else if (actInt==2 || actInt==3){
                typeLab.text=@"券";
                typeLab.backgroundColor=[UIColor greenColor];
            }else if (actInt==4 || actInt==5){
                typeLab.text=@"报";
                typeLab.backgroundColor=[UIColor redColor];
            }else if (actInt==6 ){
                typeLab.text=@"亲";
                typeLab.backgroundColor=[UIColor redColor];
            }else if (actInt==7 || actInt==8 || actInt==9 || actInt==10 || actInt==11 || actInt==12){
                typeLab.text=@"摇";
                typeLab.backgroundColor=[UIColor redColor];
            }
            [cell addSubview:typeLab];
            
        }
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [cell addSubview:colorView];
        [cell addSubview:duihuanBtn];
        return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
    [self.textField1 resignFirstResponder];
//    [tableView1 tableViewDidScroll:vScrollView];
}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoViewController *gVC=[[GoViewController alloc]init];
    gVC.path=urlAry[indexPath.row];
    
    if ([Util isNull:urlAry[indexPath.row]]) {
        return;
    }
    [self.delegate.navigationController pushViewController:gVC animated:YES];
    
}

//我收藏的商户id 取消收藏按钮
-(void)duihuanTouch:(UIButton *)sender
{
    int idid=[IdAry[sender.tag]intValue];
    [self confirm:@"确定取消收藏" afterOK:^{
     NSDictionary   *diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(idid),@"id", nil];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"nocoll"] parameters:diction  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:@"取消收藏成功"];
               
                _page=1;
                [self NetWorkRequest:nil];
                [SVProgressHUD dismiss];
            });
        }failue:^(NSDictionary *dic){
            
        }];
    }];
}

//输入框点击return
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _page=1;
    [self NetWorkRequest:nil];
    [searchBar resignFirstResponder];
}


//没有数据的时候显示的View
-(void)initnilView
{
    CGFloat    view1_H;
    CGFloat    img_H;
   
        view1_H=103;
        img_H  =85;
    
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0, view1_H, WIN_WIDTH, WIN_HEIGHT-view1_H)];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(150), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
    
}

-(void)shoucangTouch:(UIButton*)sender
{
    
    NSLog(@"点击了第%ld个btn",sender.tag);
    
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
