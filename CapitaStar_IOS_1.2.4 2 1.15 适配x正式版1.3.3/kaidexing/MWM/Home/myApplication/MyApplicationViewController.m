//
//  MyApplicationViewController.m
//  kaidexing
//
//  Created by 朱巩拓 on 2016/12/10.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyApplicationViewController.h"
#import "PFUIKit.h"
#import "CollectionViewController.h"
#import "ApplicationCell.h"
#import "FindStoreController.h"
#import "ActivityController.h"
#import "FoodViewController.h"
#import "IndoorMapController.h"
#import "GoViewController.h"
#import "ExpressOrderController.h"
#import "ParkingController.h"
#import "NewRegisterController.h"
#import "GoodsRootController.h"
#import "ParkingLotController.h"
#import "LineUpHomeController.h"
#import "CreateStarBabyViewController.h"
#import "UnifiedShopViewC.h"
#import "CompanyVC.h"
#import "InfoListViewController.h"
#import "RTMInterfaceController.h"

#define CELL_H WIN_WIDTH/4
#define CELL_TOP_H M_WIDTH(38)


@interface MyApplicationViewController ()<UITableViewDelegate,UITableViewDataSource,CollectionViewControllerDelegate>

@end

@implementation MyApplicationViewController{
    CollectionViewController *tableView1;
    NSArray     *sectionAry;
    BOOL         isChange;
    UIButton    *changeBtn;
    NSMutableArray *myIDAry;
    NSMutableDictionary *dataDic;
    
    NSMutableArray *allAry;
    NSMutableArray *myAry;
    
    //NSDictionary *ceshiDic;

    
    int myCellY;
    int allCellY;
    int isLoad;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isChange=NO;
    self.navigationBarTitleLabel.text=@"应用管理";
    myCellY=0;
    allCellY=0;
    isLoad = 0;
    //[self devNavDic];
    [self crateRightBtn];
    [self createAry];
    [self crateTableView];
    [self loadData];
}

-(void)createAry{
    dataDic = [[NSMutableDictionary alloc]init];
    myAry = [[NSMutableArray alloc]init];
    allAry =[[NSMutableArray alloc]init];
    sectionAry = @[@"我的应用",@"全部应用"];
}

-(void)crateRightBtn{
    changeBtn = [[UIButton alloc]initWithFrame:self.rigthBarItemView.bounds];
    [changeBtn setTitle:@"管理" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [changeBtn addTarget:self action:@selector(changeTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.rigthBarItemView addSubview:changeBtn];
    self.rigthBarItemView.hidden=NO;
}

-(void)changeTouch:(UIButton*)sender{
    if (isChange==NO) {
        isChange=YES;
        [changeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [tableView1.collectionView reloadData];

    }else{
        isChange=NO;
        isLoad++;
        [changeBtn setTitle:@"管理" forState:UIControlStateNormal];
        if (myAry.count>0) {
            NSMutableArray *dataary = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in myAry) {
                int idint = [dic[@"id"] intValue];
                [dataary addObject:[NSString stringWithFormat:@"%d",idint]];
            }
            _idStr = [dataary componentsJoinedByString:@","];
        }else{
            _idStr=@"";
        }
        [self loadData];
    }
}

#pragma mark ---请求网络---
-(void)loadData{
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    int zz=[[Global sharedClient].markID intValue];

    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:
                          [Global sharedClient].member_id,@"member_id",@(zz),@"mall_id",
                          _idStr,@"navlist_id",
                          [Global sharedClient].isoffice
                         ,@"is_office",nil];
    [myAry  removeAllObjects];
    [allAry removeAllObjects];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"index" tp:@"membernavlist"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            dataDic  = dic[@"data"];
            [myAry  addObjectsFromArray:dataDic[@"member_nav_list"]];
            allAry = [NSMutableArray arrayWithArray:dataDic[@"nav_list"]];
            tableView1.dataArr =@[myAry,allAry];
            [tableView1.collectionView reloadData];
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
    }];
}

- (void)backBtnOnClicked:(id)sender{
    if (isLoad > 0) {
        if (_mDelegate &&[_mDelegate respondsToSelector:@selector(myguanliLoadData:)]) {
            [_mDelegate myguanliLoadData:nil];
            [self.delegate.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.delegate.navigationController popViewControllerAnimated:YES];
    }
}

-(void)crateTableView{
    tableView1 = [[CollectionViewController alloc] init];
    tableView1.view.frame = CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT);
    
    tableView1.delegate = self.delegate;
    tableView1.collectViewDelegate = self;
    tableView1.coloumNum = 4;
    tableView1.itemSpace = 0;
    tableView1.itemHeight = WIN_WIDTH/4;
  //  tableView1.edgeInset = UIEdgeInsetsMake(20, 10, 20, 10);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview: tableView1.view];
    tableView1.collectionView.frame = tableView1.view.bounds;
    tableView1.collectionView.backgroundColor = [UIColor whiteColor];
}

-(UICollectionViewCell*) drawCell:(NSIndexPath *)indexPath  collect:(UICollectionView *)collect{
    ApplicationCell* cell = nil;
    static NSString *CellName = @"ApplicationCell";

    [collect registerNib:[UINib nibWithNibName:CellName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier: CellName];

    cell = [collect dequeueReusableCellWithReuseIdentifier:CellName forIndexPath:indexPath];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:indexPath.section==0?myAry[indexPath.row]:allAry[indexPath.row]];
    cell.functionLab.text=dic[@"name"];
    [cell.functionImg setImageWithURL:[NSURL URLWithString:dic[@"app_img_url"]]];
    [cell canEdit:isChange];
    if (isChange==YES) {
        int isadd = [dic[@"is_add"]intValue];
        if (indexPath.section ==0) {
            cell.stateBtnImg.backgroundColor=[UIColor whiteColor];
            [cell.stateBtnImg setBackgroundImage:[UIImage imageNamed:@"guanlidel"] forState:UIControlStateNormal];
        }else{
            if(isadd == 0){
                [cell.stateBtnImg setBackgroundImage:[UIImage imageNamed:@"guanliadd"] forState:UIControlStateNormal];
            }else{
                [cell.stateBtnImg setBackgroundImage:[UIImage imageNamed:@"g_rightduigou"] forState:UIControlStateNormal];
            }
        }
    }
    
    return cell;
}

-(void)createCollectionHeader:(UIView *)view index:(NSIndexPath *)indexPath{
    [UIUtil removeSubView:view];
    UILabel *titleLab = [[UILabel alloc]init];
    UIView *viewLine  = [[UIView alloc]init];
    titleLab.frame = CGRectMake(13,0,150,CELL_TOP_H);
    titleLab.text=sectionAry[indexPath.section];
    titleLab.font=DESC_FONT;
    titleLab.textColor=APP_BTN_COLOR;
    [view addSubview:titleLab];
    viewLine .frame = CGRectMake(0,CELL_TOP_H-1,WIN_WIDTH,1);
    viewLine.backgroundColor=COLOR_LINE;
    [view addSubview:viewLine];
}

-(void)createCollectionFooder:(UIView *)view index:(NSIndexPath *)indexPath{
    [UIUtil removeSubView:view];
    if (indexPath.section==0) {
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);//
    }else{
        view.backgroundColor=[UIColor whiteColor];
        UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(110),M_WIDTH(17),M_WIDTH(16),M_WIDTH(16))];
        [iconImg setImage:[UIImage imageNamed:@"SmilingFace"]];
        [view addSubview:iconImg];

        UILabel *la = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(7),M_WIDTH(20),100,14)];
        la.text = @"更多内容敬请期待";
        la.textColor = [UIColor lightGrayColor];
        la.font = [UIFont systemFontOfSize:12];
        la.textAlignment = NSTextAlignmentLeft;
        [view addSubview:la];         
    }
}
-(CGFloat)setHeaderViewHeight:(NSInteger)indexPath{
    return CELL_TOP_H;
}
-(CGFloat)setFooderViewHeight:(NSInteger)indexPath{
    if (indexPath==0) {
        return M_WIDTH(7);
    }else{
        return M_WIDTH(53);
    }
//    return indexPath==0?M_WIDTH(7):M_WIDTH(53);
}

-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isChange==YES) {
        int typeInt = (int)indexPath.section;
        int index   = (int)indexPath.row;
        
        if (typeInt==0) {
            //删除我的应用中的某一个功能
            int idint = [myAry[index][@"id"]intValue];
            for (int i=0;i<allAry.count;i++) {
                NSDictionary *diction = [[NSDictionary alloc]initWithDictionary:allAry[i]];
                int idint_2 =[diction[@"id"]intValue];
                if (idint_2 == idint) {
                    NSMutableDictionary *diction2 =[[NSMutableDictionary alloc]initWithDictionary:allAry[i]];
                    diction2[@"is_add"]=@"0";
                    allAry[i] = diction2;
                    break;
                }
            }
            [myAry removeObject:myAry[index]];
            [tableView1.collectionView reloadData];
            
        }else{
            //先判断我是否添加了
            int isadd = [allAry[index][@"is_add"]intValue];
            if (isadd==1) {
                return;
            }else{
                
                //更改添加应用中的状态
                NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithDictionary:allAry[index]];
                dic[@"is_add"]=@"1";
                allAry[index]=dic;
                //再往我的应用中添加
                
                NSDictionary *dition = [[NSDictionary alloc]initWithDictionary:allAry[index]];
                [myAry addObject:dition];
                [tableView1.collectionView reloadData];
            }
        }

    }else{
        int  sen = (int)indexPath.row;
        NSDictionary *diction = [[NSDictionary alloc]initWithDictionary:indexPath.section==0?myAry[sen]:allAry[sen]];
        NSString *idStr = [NSString stringWithFormat:@"%@",diction[@"id"]];
        
        //[self popViewC:ceshiDic[idStr] data:diction];
        [self popViewC:idStr data:diction];
        
    }
}


-(void) popViewC:(NSString*)type data:(NSDictionary*)dic{
    NSLog(@"点击了哪type=%@",type);
    if ([type isEqualToString:@"1"]) {
        //找店
//        FindStoreController *fvc=[[FindStoreController alloc]init];
//        fvc.caixiID  = @"0"; //业态id
//        fvc.yetaiStr = @"全部业态";
//        fvc.setInType=@"1";
//        fvc.nvcImgView=@"商户,t_shopping";
//        [self.delegate.navigationController pushViewController:fvc animated:YES];
        UnifiedShopViewC *vc = [[UnifiedShopViewC alloc]init];
        vc.shopType=@"1";
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"2"]) {
        //活动
        ActivityController *aVC=[[ActivityController alloc]init];
        aVC.navigationBarTitleLabel.text=@"活动";
        aVC.buttomH=@"0";
        aVC.isType=@"1";
        [self.delegate.navigationController pushViewController:aVC animated:YES];
        //GoViewController* vc = [[GoViewController alloc] init];
        //[self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"3"]) {
        //美食 w_food
//        FoodViewController *sVC=[[FoodViewController alloc]init];
//        sVC.nvcImgView=@"美食,t_food";
//        sVC.setInType=@"1";
//        [self.delegate.navigationController pushViewController:sVC animated:YES];
        UnifiedShopViewC *vc = [[UnifiedShopViewC alloc]init];
        vc.shopType=@"0";
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"5"]) {
        
    }else if ([type isEqualToString:@"7"]) {
        
        //进入个人中心
        if (_mDelegate &&[_mDelegate respondsToSelector:@selector(myguanliLoadData:)]) {
            [_mDelegate myguanliLoadData:@"popMine"];
            [self.delegate.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }else if ([type isEqualToString:@"8"]) {
        //楼层选择
        IndoorMapController  *vc=[[IndoorMapController alloc]init];

        vc.myBuildString = _building_idStr;
        vc.myFloorId=@"F1";
//        RTMInterfaceController *RTM = [RTMInterfaceController loadController];
//        [self.delegate presentViewController:RTM animated:YES completion:nil];
        
    }else if ([type isEqualToString:@"11"]) {
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = [NSString stringWithFormat:@"%@://m.ascottchina.com",[Global sharedClient].HTTP_S];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"19"]) {
        //注册
        NewRegisterController *rVC=[[NewRegisterController alloc]init];
        [self.delegate.navigationController pushViewController:rVC animated:YES];
        
    }else if ([type isEqualToString:@"20"]) {
        
        //积分商城
        GoodsRootController* vc = [[GoodsRootController alloc] init];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"21"]) {
        //排队领号
        GoViewController* vc = [[GoViewController alloc] init];
        vc.path = [NSString stringWithFormat:@"https://%@/%@/%@",[Global sharedClient].Shopping_Mall,[Global sharedClient].markPrefix,[Util isNil:dic[@"link_url"]]];
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else if ([type isEqualToString:@"22"]) {
        
        //星宝贝
        CreateStarBabyViewController * cSBVC = [[CreateStarBabyViewController alloc] init];
        [self.delegate.navigationController pushViewController:cSBVC animated:YES];
        
    }else if ([type isEqualToString:@"25"]) {
        //点击签到按钮
        [SVProgressHUD showWithStatus:@"正在努力签到中"];
        int  shopID=[[Global sharedClient].markID intValue];
        NSDictionary    *diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@(shopID),@"mall_id",nil];
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"sign" tp:@"conventionalsign"] parameters:diction  target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"签到成功"];
            });
        }failue:^(NSDictionary *dic){
        }];
        
    }else if ([type isEqualToString:@"27"]) {
        //27
        //9
        //停车服务
        ParkingController *cVC=[[ParkingController alloc]init];
        [self.delegate.navigationController pushViewController:cVC animated:YES];
        
    }else if ([type isEqualToString:@"28"]) {
        //28正式的
        //1027 测试的
        //楼层选择
//        IndoorMapController  *vc=[[IndoorMapController alloc]init];
//        vc.myBuildString = _building_idStr;
//        vc.myFloorId=@"F1";
//        [self.delegate.navigationController pushViewController:vc animated:YES];
        RTMInterfaceController * controller = [RTMInterfaceController loadController:[Global sharedClient].building_id];
        [self presentViewController:controller animated:YES completion:nil];
        
        ////快递服务
        //ExpressOrderController *vc=[[ExpressOrderController alloc]init];
        //[self.delegate.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"36"]) {
        //正式 36
        // 测试1030
        //门禁信息
        CompanyVC  *vc=[[CompanyVC alloc]init];
       NSLog(@"menjing%@",type);
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
        ////快递服务
        //ExpressOrderController *vc=[[ExpressOrderController alloc]init];
        //[self.delegate.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:@"39"]) {
        //1032
        //39
        //资讯
        InfoListViewController  *vc=[[InfoListViewController alloc]init];
        
        [self.delegate.navigationController pushViewController:vc animated:YES];
        
    }else{
        GoViewController* vc = [[GoViewController alloc] init];
        if([[Util isNil:dic[@"link_url"]] hasPrefix:@"http"]){
            vc.path=[Util isNil:[dic[@"link_url"] stringByReplacingOccurrencesOfString:@"http" withString:[Global sharedClient].HTTP_S]];
        }else{
            vc.path = [NSString stringWithFormat:@"%@://%@/%@/%@",[Global sharedClient].HTTP_S,[Global sharedClient].Shopping_Mall,[Global sharedClient].markPrefix,[Util isNil:dic[@"link_url"]]];
        }
        [self.delegate.navigationController pushViewController:vc animated:YES];
    }
}

//-(void) devNavDic{
//    ceshiDic= [Util logConfigDicFromPlist:@"appid"];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
