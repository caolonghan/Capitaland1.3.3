//
//  UnifiedShopViewC.m
//  kaidexing
//
//  Created by 朱巩拓 on 2017/2/11.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "UnifiedShopViewC.h"
#import "SelectionBoxView.h"
#import "ReTableView.h"
#import "MLabel.h"
#import "IndoorMapController.h"
#import "StoreDetailsViewC.h"
#import "RTMInterfaceController.h"
@interface UnifiedShopViewC ()<UISearchBarDelegate,selectionDelegate,ZhuRefreshTableView,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic)SelectionBoxView    *selectionView;//选择框
@property (strong,nonatomic)NSMutableArray      *dataArr;      //保存列表数据

@end

@implementation UnifiedShopViewC{
    UISearchBar     * homeTextF;        //顶部搜索框
    UILabel         * froolLab;         //顶部选择第一个按钮
    UILabel         * centerLab;        //顶部选择中间一个按钮 当按钮总数为两个的时候，这个按钮将被舍去
    UILabel         * sortLab;          //顶部选择排序按钮 当按钮总数为两个的时候，这个按钮将会是第二个按钮
    NSMutableArray  * ShopFloorNameAry; //楼层名字
    NSMutableArray  * ShopFloorIdAry;   //楼层ID
    NSMutableArray  * ShopTypeNameAry;  //业态名字
    NSMutableArray  * ShopTypeIdAry;    //业态ID
    NSMutableArray  * sortNameAry;      //排序名字
    NSMutableArray  * sortIdAry;        //排序ID
    NSString        * floorID;          //保存楼层id
    NSString        * typeID;           //保存业态id
    NSString        * sortID;           //保存排序id
    
    UIView          * curDealView;      //保存选择按钮中的图片tag
    ReTableView     * tableView1;       //
    UIView          * nilView1;         //无数据的时候显示界面
    BOOL              isEnd;            //是否还有数据
    NSInteger         pageNum;          //页数
    NSString        * searchStr;        //搜索的关键字
    int               twoTime;          //搜索延迟2秒
    NSTimer         * relodeTime;       //搜索用的定时器
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTitleLabel.text=[_shopType isEqualToString:@"0"] ? @"美食" : @"商户";
    
    isEnd=YES;
    
    searchStr=@"";
    
    [self typeLoadData];
    
    self.dataArr = [[NSMutableArray alloc]init];
    
    [self createNavView];
    
    [self screenView];
    
    [self createTableview];
    
    [self tableView_refresh:nil];
}

#pragma mark  -----  网络请求  -----

//列表数据
-(void)tableView_refresh:(NSString*)type{
    [homeTextF resignFirstResponder];
    [nilView1 removeFromSuperview];
    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
        isEnd=NO;
        pageNum=1;
    }else if (isEnd==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [tableView1 tableViewDidFinishedLoading];
        [tableView1 noticeNoMoreData];
        return;
    }else {
        pageNum++;
    }
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].markID,@"mall_id",floorID,@"Floor",typeID,@"Type",sortID,@"sort",@(pageNum),@"Page",@"10",@"pageSize",searchStr,@"Key", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadshoplist"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]]){
                if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                    [self.dataArr removeAllObjects];
                }
                NSArray *array=dic[@"data"][@"shoplist"];
                isEnd  =[dic[@"data"][@"isend"]boolValue];
                [self.dataArr addObjectsFromArray:array];
                [tableView1 reloadData];
            }
            if (_dataArr.count==0 ) {
                [self createNilView];
            }
            [tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}


//顶部选择框
-(void)typeLoadData{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].markID,@"mall_id",@"",@"t",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self typeData:dic];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}
//顶部数据处理

-(void)typeData:(NSDictionary*)dic{
    ShopFloorIdAry    =[[NSMutableArray alloc]init];
    ShopFloorNameAry  =[[NSMutableArray alloc]init];
    
    ShopTypeIdAry   =[[NSMutableArray alloc]init];
    ShopTypeNameAry =[[NSMutableArray alloc]init];
    
    sortIdAry    =[[NSMutableArray alloc]init];
    sortNameAry  =[[NSMutableArray alloc]init];
    
    NSArray * shopFloor    = dic[@"data"][@"ShopFloor"];
    NSArray * ShopType     = dic[@"data"][@"ShopType"];
    
    if (shopFloor.count!=0) {
        [ShopFloorNameAry addObject:@"楼层"];
        [ShopFloorIdAry   addObject:@"0"];
        
        for (NSDictionary *dic1 in shopFloor) {
            NSString *nameStr  = [Util isNil:dic1[@"name"]];
            NSString *idStr    = [Util isNil:dic1[@"id"]];
            [ShopFloorNameAry addObject:nameStr];
            [ShopFloorIdAry   addObject:idStr];
        }
    }
    
    if (ShopType.count!=0) {
        [ShopTypeNameAry addObject:@"业态"];
        [ShopTypeIdAry   addObject:@"0"];
        for (NSDictionary *dic2 in ShopType) {
            NSString *idStr    = [Util isNil:dic2[@"id"]];
            NSString *nameStr  = [Util isNil:dic2[@"name"]];
            [ShopTypeNameAry addObject:nameStr];
            [ShopTypeIdAry   addObject:idStr];
        }
    }
    NSArray* paixuID = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    [sortIdAry addObjectsFromArray:paixuID];
    NSArray *paixutitleAry=[[NSArray alloc]initWithObjects:@"默认排序",@"人气最高",@"有团购",@"有促销优惠",@"A-Z字母排序",@"有卡券",@"有报名",@"有排队",@"有订座", nil];
    [sortNameAry addObjectsFromArray:paixutitleAry];
}

#pragma mark  -----  顶部搜索框  -----
-(void)createNavView{
    UIView *headRootView = [[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT,WIN_WIDTH,43)];
    headRootView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    homeTextF=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,43)];
    homeTextF.backgroundImage = [self imageWithColor:[UIColor clearColor] size:homeTextF.bounds.size];
    homeTextF.placeholder=@"搜索商户";
    homeTextF.delegate=self;
    homeTextF.searchBarStyle=UISearchBarStyleDefault;
    homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    homeTextF.returnKeyType=UIReturnKeySearch;
    [headRootView addSubview:homeTextF];
    [self.view addSubview:headRootView];
    
    relodeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//搜索内容改变的时候，在这个方法里面实现实时显示结果
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    twoTime=2;
    searchStr=searchText;
    [relodeTime setFireDate:[NSDate distantPast]];
    
}

-(void)timeFireMethod{
    twoTime--;
    if (twoTime==0) {
        [self tableView_refresh:nil];
        [relodeTime setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark  -----  中间筛选视图 -----

-(void)screenView{
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT+43,WIN_WIDTH,42)];
    btnView.backgroundColor = [UIColor whiteColor];
    
    NSArray* titleAry ;
    if ([_shopType isEqualToString:@"0"]) {
        titleAry = @[@"楼层",@"智能排序"];
    }else{
        titleAry = @[@"楼层",@"业态",@"智能排序"];
    }
    int screenNum = (int)titleAry.count;
    float imgW = 15*2/3;
    float imgH = 8*2/3;
    
    for (int i=0; i<screenNum; i++) {
        UIView *iconView=[[UIView alloc]initWithFrame:CGRectMake((WIN_WIDTH/screenNum)*i,0, WIN_WIDTH/screenNum,41)];
        iconView.backgroundColor=[UIColor whiteColor];
        UIImageView *upImg=[[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH/screenNum), (iconView.frame.size.height - imgH)/2,imgW, imgH)];
        [upImg setImage:[UIImage imageNamed:@"StoreDetailsDown"]];
        upImg.tag = 500;
        if (i==0) {
            froolLab  = [[UILabel alloc]init];
            [self chuliView:iconView lab:froolLab title:titleAry[i] img:upImg];
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = UIColorFromRGB(0xf2f2f2);
            lineView.frame = CGRectMake(WIN_WIDTH/screenNum-1,12,1,17);
            [iconView addSubview:lineView];
            
        }else if(i==1){
            if (screenNum==3) {
                centerLab = [[UILabel alloc]init];
                [self chuliView:iconView lab:centerLab title:titleAry[i] img:upImg];
                UIView *lineView = [[UIView alloc]init];
                lineView.backgroundColor = UIColorFromRGB(0xf2f2f2);
                lineView.frame = CGRectMake(WIN_WIDTH/screenNum-1,12,1,17);
                [iconView addSubview:lineView];
            }else{
                sortLab  = [[UILabel alloc]init];
                [self chuliView:iconView lab:sortLab title:titleAry[i] img:upImg];
            }
        }else if(i==2){
            sortLab  = [[UILabel alloc]init];
            [self chuliView:iconView lab:sortLab title:titleAry[i] img:upImg];
        }

        iconView.tag=100+i;
        UITapGestureRecognizer  * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectTypeTap:)];
        [iconView addGestureRecognizer:tap];
        [btnView addSubview:iconView];
    }
    
    UIView *xlineView = [[UIView alloc]init];
    xlineView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    xlineView.frame = CGRectMake(0,41,WIN_WIDTH,1);
    [btnView addSubview:xlineView];
    
    [self.view addSubview:btnView];
    //顶部选项id默认初始值
    floorID = @"0";
    if([_shopType isEqualToString:@"0"]){
        typeID  = @"2";
    }else{
        typeID  = @"0";
    }
    
    sortID  = @"0";
}

//对顶部的三个按钮做操作
-(void)chuliView:(UIView*)view lab:(UILabel*)lab title:(NSString*)title img:(UIImageView*)img{
    lab.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    lab.text=title;
    lab.font=COMMON_FONT;
    lab.textColor=APP_BTN_COLOR;
    lab.textAlignment=NSTextAlignmentRight;
    [lab sizeToFit];
    CGRect frame = lab.frame;
    frame.origin.x = [self computLabelXForLabelImg:view.frame.size.width imgWidth:img.frame.size.width labelWidth:frame.size.width padding:4];
    frame.size.height = view.frame.size.height;
    lab.frame = frame;
    [view addSubview:lab];
    
    frame = img.frame;
    frame.origin.x = [self computImgXForLabelImg:view.frame.size.width imgWidth:img.frame.size.width labelWidth:lab.frame.size.width padding:4];
    img.frame = frame;
    [view addSubview:img];
}

-(float) computLabelXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
    return (pWidth - (imgWidth+labelWidth+padding))/2;
}
-(float) computImgXForLabelImg:(float)pWidth imgWidth:(float)imgWidth labelWidth:(float)labelWidth padding:(float) padding{
    return (pWidth - (imgWidth+labelWidth+padding))/2 + labelWidth + padding;
}

//点击头部选择按钮弹出view事件
-(void) onSelectTypeTap:(UITapGestureRecognizer*) tap{
    [homeTextF resignFirstResponder];
    if (_selectionView !=nil) {
        [_selectionView removeFromSuperview];
    }
    curDealView = [tap view];
    NSInteger index=[tap view].tag;
    UIImageView* upImgView = [[tap view] viewWithTag:500];
    [upImgView setImage:[UIImage imageNamed:@"StoreDetailsUp"]];

    _selectionView=[[SelectionBoxView alloc]init];
    _selectionView.backgroundColor=[UIColor clearColor];
    _selectionView.frame= CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height);
    _selectionView.xPoint = NAV_HEIGHT + 85;
    _selectionView.selectioDelegate=self;
    
    if ([_shopType isEqualToString:@"0"]) {
        if (index==101) {
            index=index+1;
        }
    }
    
    switch (index) {
        case 100:
            if (ShopTypeIdAry.count>0) {
                _selectionView.dataArray =ShopFloorNameAry;
                _selectionView.idArray   =ShopFloorIdAry;
                _selectionView.type     =@"1";//目的是为了返回的时候知道我传过去的是什么类型
                _selectionView.curSelectId = floorID;
                [self.view addSubview:_selectionView];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"该商场没有此分类"];
            }
            break;
        case 101:
            if (ShopTypeIdAry.count>0) {
                _selectionView.dataArray =ShopTypeNameAry;
                _selectionView.idArray   =ShopTypeIdAry;
                _selectionView.type     =@"2";
                _selectionView.curSelectId = typeID;
                [self.view addSubview:_selectionView];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"该商场没有此分类"];
            }
            break;
        case 102:{
                _selectionView.dataArray=sortNameAry;
                _selectionView.idArray  =sortIdAry;
                _selectionView.type     =@"3";
                _selectionView.curSelectId = sortID;
                [self.view addSubview:_selectionView];
            }
            break;
        default:
            break;
    }
}

//------弹出视图代理事件-------
-(void)cancelSelect{
    UIImageView* upImgView = [curDealView viewWithTag:500];
    [upImgView setImage:[UIImage imageNamed:@"StoreDetailsDown"]];
}

//-----弹出视图选择返回事件-----
-(void)setdelegate:(id)selecDelegate{
    NSString *strType=selecDelegate[0];
    UIImageView* upImg;
    UILabel * curLabel;
    UIView  * btnView;
    
    if ([strType isEqualToString:@"1"]) {
        
        floorID=selecDelegate[1];
        curLabel = froolLab;
    }else if ([strType isEqualToString:@"2"]){
        typeID =selecDelegate[1];
        curLabel = centerLab;
    }else{
        sortID =selecDelegate[1];
        curLabel = sortLab;
    }
    btnView = [curLabel superview];
    upImg = [btnView viewWithTag:500];
    
    curLabel.text=selecDelegate[2];
    [curLabel sizeToFit];
    [upImg setImage:[UIImage imageNamed:@"StoreDetailsDown"]];
    
    CGRect frame = curLabel.frame;
    frame.size.height = btnView.frame.size.height;
    frame.origin.x = [self computLabelXForLabelImg:btnView.frame.size.width imgWidth:upImg.frame.size.width labelWidth:frame.size.width padding:4];
    curLabel.frame = frame;
    frame = upImg.frame;
    frame.origin.x = [self computImgXForLabelImg:btnView.frame.size.width imgWidth:upImg.frame.size.width labelWidth:curLabel.frame.size.width padding:4];
    upImg.frame = frame;
    [self tableView_refresh:nil];
}

#pragma mark  -----  tableView方法 -----

-(void)createTableview{
    tableView1=[[ReTableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT+85, WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-85) style:UITableViewStylePlain];
    tableView1.delegate=self;
    tableView1.dataSource=self;
    tableView1.backgroundColor=[UIColor clearColor];
    tableView1.scrollEnabled=YES;
    tableView1.refreshTVDelegate=self;
    [self.view addSubview:tableView1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return M_WIDTH(150);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [UIUtil removeSubView:cell];
    UIView *view = [self createCellView:indexPath];
    [cell addSubview:view];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleDefault;
    return cell;
}

-(UIView*)createCellView:(NSIndexPath*)indexPath{
    NSDictionary *dic=_dataArr[indexPath.section];
    //美食cell
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(150))];
    rootView.backgroundColor=[UIColor whiteColor];
    UIImageView* bigImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, M_WIDTH(8), M_WIDTH(160), M_WIDTH(106))];
    NSString* logStr = [Util isNil:dic[@"logo_img_url"]];
    [bigImgView setImageWithURL:[NSURL URLWithString:logStr]];
    [rootView addSubview:bigImgView];
    
    //店铺类型
    UILabel *shopTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigImgView.frame)+M_WIDTH(8),M_WIDTH(17),M_WIDTH(140),M_WIDTH(16))];
    shopTypeLab.textColor=UIColorFromRGB(0x999999);
    shopTypeLab.font=DESC_FONT;
    shopTypeLab.text= [Util isNil:dic[@"type_name"]];
    [rootView addSubview:shopTypeLab];
    
    //标题
    MLabel *nameLab=[[MLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bigImgView.frame)+M_WIDTH(9),CGRectGetMaxY(shopTypeLab.frame)+M_WIDTH(3),M_WIDTH(145), M_WIDTH(40))];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.font=COOL_FONT;
    nameLab.text=[Util isNil:dic[@"shop_name"]];
    nameLab.numberOfLines=2;
    nameLab.maxHeight=M_WIDTH(40);
    [nameLab autoSize];
    [rootView addSubview:nameLab];
    
    float     lab_top = M_WIDTH(92);//距上
    CGFloat   lab_H   = M_WIDTH(16);//宽高
    CGFloat   lab_S   = M_WIDTH(7); //间距
    CGFloat   cellLaft= CGRectGetMaxX(bigImgView.frame)+M_WIDTH(9);
    
    int    queue_status       = [[Util isNil:dic[@"queue_status"]]intValue];//排
    int    sale_status        = [[Util isNil:dic[@"sale_status"]]intValue];//促
    int    coupon_status      = [[Util isNil:dic[@"coupon_status"]]intValue];//券
    int    group_buying_status= [[Util isNil:dic[@"group_buying_status"]]intValue];//团
    int    seckill_status     = [[Util isNil:dic[@"seckill_status"]]intValue];//秒
    int    sign_up_status     = [[Util isNil:dic[@"sign_up_status"]]intValue];//报
    int    booked_status      = [[Util isNil:dic[@"booked_status"]]intValue];//订
    
    if (queue_status == 1) {//排
        UILabel* paiLab=[[UILabel alloc]initWithFrame:CGRectMake(cellLaft, lab_top, lab_H, lab_H)];
        [self chuliLab:paiLab title:@"排" color:UIColorFromRGB(0x8581b9)];
        [rootView addSubview:paiLab];
        cellLaft =cellLaft + lab_H + lab_S;
    }
    if (sale_status == 1) {//促
        UILabel*cuLab=[[UILabel alloc]initWithFrame:CGRectMake(cellLaft, lab_top, lab_H, lab_H)];
        [self chuliLab:cuLab title:@"促" color:UIColorFromRGB(0xf0c58c)];
        [rootView addSubview:cuLab];
        cellLaft =cellLaft + lab_H + lab_S;
    }
    if (coupon_status == 1) {//券
        UILabel*juanLab=[[UILabel alloc]initWithFrame:CGRectMake(cellLaft, lab_top, lab_H, lab_H)];
        [self chuliLab:juanLab title:@"券" color:UIColorFromRGB(0x29bbc5)];
        [rootView addSubview:juanLab];
        cellLaft =cellLaft + lab_H + lab_S;
    }
    
    if (group_buying_status == 1) {//团
        UILabel*tuanLab=[[UILabel alloc]initWithFrame:CGRectMake(cellLaft, lab_top, lab_H, lab_H)];
        [self chuliLab:tuanLab title:@"团" color:UIColorFromRGB(0x8581b9)];
        [rootView addSubview:tuanLab];
        cellLaft =cellLaft + lab_H + lab_S;
    }
    
    if (seckill_status == 1) {//秒
        UILabel*miaoLab=[[UILabel alloc]initWithFrame:CGRectMake(cellLaft, lab_top, lab_H, lab_H)];
        [self chuliLab:miaoLab title:@"秒" color:UIColorFromRGB(0xf0c58c)];
        [rootView addSubview:miaoLab];
        cellLaft =cellLaft + lab_H + lab_S;
    }
    
    if (sign_up_status == 1) {//报
        UILabel*baoLab=[[UILabel alloc]initWithFrame:CGRectMake(cellLaft, lab_top, lab_H, lab_H)];
        [self chuliLab:baoLab title:@"报" color:UIColorFromRGB(0x29bbc5)];
        [rootView addSubview:baoLab];
        cellLaft =cellLaft + lab_H + lab_S;
    }
    
    if (booked_status == 1) {//订
        UILabel*bookLab=[[UILabel alloc]initWithFrame:CGRectMake(cellLaft, lab_top, lab_H, lab_H)];
        [self chuliLab:bookLab title:@"订" color:RGBCOLOR(79, 168, 34)];
        [rootView addSubview:bookLab];
    }
    
    //地址图标
    UIImageView *img_Down1=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(48),CGRectGetMaxY(bigImgView.frame)+M_WIDTH(8.5), M_WIDTH(17), M_WIDTH(17))];
    [img_Down1 setImage:[UIImage imageNamed:@"greedMap"]];
    [rootView addSubview:img_Down1];
    
    //店铺地址
    UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_Down1.frame)+M_WIDTH(9),CGRectGetMaxY(bigImgView.frame), M_WIDTH(100), M_WIDTH(33))];
    addressLab.font=INFO_FONT;
    addressLab.textColor=APP_BTN_COLOR;
    addressLab.textAlignment=NSTextAlignmentLeft;
    addressLab.text=[NSString stringWithFormat:@"%@/%@",[Util isNil:dic[@"floor_name"]],[Util isNil:dic[@"house_number"]]];
    [rootView addSubview:addressLab];
    
    //赞的图标
    UIImageView *goodImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(216),CGRectGetMaxY(bigImgView.frame)+M_WIDTH(8.5), M_WIDTH(17), M_WIDTH(17))];
    [goodImg setImage:[UIImage imageNamed:@"shopGood"]];
    [rootView addSubview:goodImg];
    
    //赞的数量
    UILabel *explainLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(goodImg.frame)+M_WIDTH(5), CGRectGetMaxY(bigImgView.frame)+M_WIDTH(13),M_WIDTH(50), M_WIDTH(12))];
    explainLab.textColor=APP_BTN_COLOR;
    explainLab.font=INFO_FONT;
    int linkNum = [[Util isNil:dic[@"link_num"]] intValue];
    explainLab.text=[NSString stringWithFormat:@"%d人",linkNum];
    [rootView addSubview:explainLab];
    
    UIView *buttomLine = [[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(150)-1,WIN_WIDTH,1)];
    buttomLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [rootView addSubview:buttomLine];
    
    UIButton *mapBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(bigImgView.frame),WIN_WIDTH/2,M_WIDTH(33))];
    mapBtn.tag=indexPath.section;
    [mapBtn addTarget:self action:@selector(mapTouch:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:mapBtn];
    
    UIButton *goodBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH/2,CGRectGetMaxY(bigImgView.frame),WIN_WIDTH/2,M_WIDTH(33))];
    goodBtn.tag=indexPath.section;
    [goodBtn addTarget:self action:@selector(goodTouch:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:goodBtn];
    
    return rootView;
}

-(void)chuliLab:(UILabel*)lab title:(NSString*)title color:(UIColor*)color{
    lab.text=title;
    lab.backgroundColor=color;
    lab.font=INFO_FONT;
    lab.layer.masksToBounds=YES;
    lab.layer.cornerRadius=3;
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor=[UIColor whiteColor];
}

//进入到智慧图
-(void)mapTouch:(UIButton*)sender{
    //楼层导航
//    IndoorMapController  *vc=[[IndoorMapController alloc]init];
//    vc.myBuildString = [Global sharedClient].building_id;
//    vc.myFloorId = _dataArr[sender.tag][@"floor_name"];
//    vc.shopName = _dataArr[sender.tag][@"shop_name"];
//    [self.delegate.navigationController pushViewController:vc animated:YES];
    
    [self presentViewController:[RTMInterfaceController loadControllerWithDestinationPOI:@{@"buildingID":[Global sharedClient].building_id,@"floorID":_dataArr[sender.tag][@"floor_name"],@"name":_dataArr[sender.tag][@"shop_name"]}] animated:YES completion:nil];
}
//点击赞事件
-(void)goodTouch:(UIButton*)sender{
    [homeTextF resignFirstResponder];
    NSString *shopId = _dataArr[sender.tag][@"shop_id"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"likeshop"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:shopId,@"shop_id",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            int linkNum = [[Util isNil:_dataArr[sender.tag][@"link_num"]] intValue] +1;
            id  linkStr = [NSString stringWithFormat:@"%d",linkNum];
            NSMutableDictionary *diction = [[NSMutableDictionary alloc]init];
            diction =[_dataArr[sender.tag] mutableCopy];
            [diction setObject:linkStr forKey:@"link_num"];
            _dataArr[sender.tag] = diction;
            [tableView1 reloadData];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [homeTextF resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoreDetailsViewC *vc = [[StoreDetailsViewC alloc]init];
    vc.shopId = _dataArr[indexPath.section][@"shop_id"];
    vc.headTitle = _dataArr[indexPath.section][@"shop_name"];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [homeTextF resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [homeTextF resignFirstResponder];
}

#pragma mark  -----  无数据展示界面 -----
-(void)createNilView{
    //没有数据的时候显示
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT+M_WIDTH(85),WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(85))];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(180), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [nilView1 addSubview:nilImgView];
    [self.view addSubview:nilView1];
}


@end
