//
//  ShopViewController.m
//  kaidexing
//
//  Created by companycn on 2018/5/18.
//  Copyright © 2018年 dwolf. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopCollectionViewCell.h"
#import "MJRefresh.h"
#import "StoreDetailsViewC.h"

@interface ShopViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UISearchBar *homeTextF;
@property (nonatomic,assign)NSTimer *relodeTime;
@property (nonatomic,strong)NSMutableArray *shopListArr;
@property (nonatomic,strong)NSArray *choiceArr;
@property (nonatomic,strong)UICollectionView *shopCollectionView;
@property (nonatomic,strong)UIScrollView *choiceScrollView;
@property (nonatomic,strong)UIView *tip;
@property (nonatomic,assign)BOOL isEnd;
@property (nonatomic,assign)NSInteger pageNum;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)NSInteger twoTime;
@property (nonatomic,strong)NSString *searchStr;
@property (strong,nonatomic)NSMutableArray *idleImages;
@property (strong,nonatomic)NSMutableArray *refreshingImages;
@property (nonatomic,strong)UIView *nilView1;
@property (nonatomic,strong)NSDictionary *cellIdentifierDic;
@end

@implementation ShopViewController
- (NSDictionary *)cellIdentifierDic
{
    if (!_cellIdentifierDic) {
        _cellIdentifierDic = [NSDictionary dictionary];
    }
    return _cellIdentifierDic;
}
- (NSArray *)choiceArr
{
    if (!_choiceArr) {
        _choiceArr = [NSArray array];
    }
    return _choiceArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 40, 44 )];
    [self.leftBarItemView addSubview:backLabel];
    self.navigationBarLine.hidden = YES;
    backLabel.text = @"首页";
    backLabel.textColor = [UIColor redColor];
    backLabel.font = [UIFont systemFontOfSize:15];
    [self createSearchBar];
    _shopListArr = [NSMutableArray array];
    
}
- (void)redefineBackBtn{
     [self redefineBackBtn:[UIImage imageNamed:@"shopback"] :CGRectMake(0, 0, 44,44)];
}
- (void)createSearchBar
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, NAV_HEIGHT, 200, 43)];
    [self.view addSubview:titleLabel];
    titleLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(36.0)];
    titleLabel.text = @"店铺导购";
    
    UIView *headRootView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame),WIN_WIDTH,43)];
    headRootView.backgroundColor=UIColorFromRGB(0xf2f2f2);
    _homeTextF=[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,43)];
    _homeTextF.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_homeTextF.bounds.size];
    _homeTextF.placeholder=@"搜索商户";
    _homeTextF.delegate=self;
    _homeTextF.searchBarStyle=UISearchBarStyleDefault;
    _homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    _homeTextF.returnKeyType=UIReturnKeySearch;
    [headRootView addSubview:_homeTextF];
    [self.view addSubview:headRootView];
    [self loadChoiceData];
    
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
- (void)loadChoiceData{
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadfloor"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].markID,@"mall_id",@"",@"t",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            _choiceArr = dic[@"data"][@"ShopType"];
            [self createChoiceBanner];
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
    }];
}
- (void)createChoiceBanner
{
    _choiceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+86, WIN_WIDTH, 42)];
    [self.view addSubview:_choiceScrollView];
    _choiceScrollView.showsHorizontalScrollIndicator = NO;
    _choiceScrollView.bounces = NO;
    _choiceScrollView.contentSize = CGSizeMake(WIN_WIDTH/5*_choiceArr.count, 42);
    
    for (NSInteger i=0; i<_choiceArr.count; i++) {
        UIButton *choiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*WIN_WIDTH/5, 0, WIN_WIDTH/5, 41)];
        [_choiceScrollView addSubview:choiceBtn];
        [choiceBtn setTitle:_choiceArr[i][@"name"] forState:UIControlStateNormal];
        choiceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        choiceBtn.tag = i+1000;
        [choiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [choiceBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateSelected];
        [choiceBtn addTarget:self action:@selector(clickChoiceShop:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            choiceBtn.selected = YES;
        }
    }
    
    _tip = [[UIView alloc]initWithFrame:CGRectMake(8, _choiceScrollView.height-1, WIN_WIDTH/5-16, 1)];
    [_choiceScrollView addSubview:_tip];
    _tip.backgroundColor = APP_BTN_COLOR;
    _index =0;
    _pageNum = 1;
    [self loadShopData:_index searchStr:nil];
    [self createShopCollectionView];
    _relodeTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
}
- (void)clickChoiceShop:(UIButton *)sender{
    for (UIView *view in _choiceScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    _index = sender.tag-1000;
     [_shopListArr removeAllObjects];
    [self loadShopData:_index searchStr:nil];
    [UIView animateWithDuration:0.2 animations:^{
        _tip.frame = CGRectMake((sender.tag-1000)*WIN_WIDTH/5+8, _choiceScrollView.height-1, WIN_WIDTH/5-16, 1);
    }];
}
- (void)createShopCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _shopCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_choiceScrollView.frame), WIN_WIDTH, WIN_HEIGHT-CGRectGetMaxY(_choiceScrollView.frame)) collectionViewLayout:flowLayout];
    _shopCollectionView.backgroundColor = [UIColor whiteColor];
    _shopCollectionView.delegate = self;        //实现代理
    _shopCollectionView.dataSource = self;      //实现数据源方法
   
    [self.view addSubview:_shopCollectionView];
    
//    _shopCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [_shopListArr removeAllObjects];
//        _pageNum = 1;
//        [self loadShopData:_index searchStr:_searchStr];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.shopCollectionView.mj_header endRefreshing];
//        });
//    }];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [_shopListArr removeAllObjects];
                _pageNum = 1;
                [self loadShopData:_index searchStr:_searchStr];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.shopCollectionView.mj_header endRefreshing];
                });
    }];
    [header setImages:self.idleImages forState:MJRefreshStateIdle];//设置普通状态的动画图片
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:self.refreshingImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:self.refreshingImages forState:MJRefreshStateRefreshing];
    header.lastUpdatedTimeLabel.hidden = YES;// 隐藏时间
    header.stateLabel.hidden = YES;//
   
    _shopCollectionView.mj_header = header;
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (_isEnd) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.shopCollectionView.mj_footer endRefreshingWithNoMoreData];
                self.shopCollectionView.mj_footer.hidden = YES;
                [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
            });
        }else{
            _pageNum++;
            [self loadShopData:_index searchStr:_searchStr];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.shopCollectionView.mj_footer endRefreshing];
            });
            
        }
    }];
    _shopCollectionView.mj_footer = footer;
    [footer setMj_h:44];
    [footer setTitle:@"正在加载更多数据" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    //footer.automaticallyHidden = YES;
    
    
}
- (void)loadShopData:(NSInteger)index searchStr:(NSString *)searchStr{
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    [_nilView1 removeFromSuperview];
    NSDictionary*diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].markID,@"mall_id",@"0",@"Floor",_choiceArr[index][@"id"],@"Type",@"",@"sort",@(_pageNum),@"Page",@"10",@"pageSize",searchStr,@"Key", nil];
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"loadshoplist"] parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSArray *array=dic[@"data"][@"shoplist"];
            _isEnd  =[dic[@"data"][@"isend"]boolValue];
            [_shopListArr addObjectsFromArray:array];
            [_shopCollectionView reloadData];
            [_homeTextF resignFirstResponder];
            if (_shopListArr.count ==0) {
                [self createNilView];
            }
            
        });
    }failue:^(NSDictionary *dic){
        [SVProgressHUD dismiss];
    }];
}
//搜索内容改变的时候，在这个方法里面实现实时显示结果
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _twoTime=2;
    _searchStr=searchText;
    [_relodeTime setFireDate:[NSDate distantPast]];
    
}
//定时器开启
- (void)timeFireMethod{
    _twoTime--;
    if (_twoTime==0) {
        [self loadShopData:_index searchStr:_searchStr];
        [_relodeTime setFireDate:[NSDate distantFuture]];
    }
}
#pragma mark ---collectionView代理---
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _shopListArr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((WIN_WIDTH-50)/2, 188);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 20, 5, 20);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UINib *nib = [UINib nibWithNibName:@"ShopCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"ShopCollectionViewCell"];


    ShopCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier: @"ShopCollectionViewCell" forIndexPath:indexPath];
    __block ShopCollectionViewCell *cellBlock = cell;
    
    cell.returnValueBlock = ^(void) {
        int linkNum = [[Util isNil:cellBlock.countLabel.text] intValue] +1;
        NSString  *linkStr = [NSString stringWithFormat:@"%d",linkNum];
    
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"mallshoplist" tp:@"likeshop"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_shopListArr[indexPath.row][@"shop_id"]],@"shop_id",nil] target:self success:^(NSDictionary *dic){
          
            NSMutableDictionary *diction = [[NSMutableDictionary alloc]init];
            diction =[_shopListArr[indexPath.row] mutableCopy];
            [diction setObject:linkStr forKey:@"link_num"];
            _shopListArr[indexPath.row] = diction;
             [self.shopCollectionView reloadData ];
        }failue:^(NSDictionary *dic){
            
        }];
      
    };
    [cell.shopImageView setImageWithString:_shopListArr[indexPath.row][@"logo_img_url"]];
    cell.typeLabel.text =[NSString stringWithFormat:@"%@",_shopListArr[indexPath.row][@"type_name"]] ;
    cell.nameLabel.text = _shopListArr[indexPath.row][@"shop_name"];
    cell.countLabel.text =[NSString stringWithFormat:@"%@",_shopListArr[indexPath.row][@"link_num"]] ;
    cell.shopId = [NSString stringWithFormat:@"%@",_shopListArr[indexPath.row][@"shop_id"]] ;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreDetailsViewC *vc = [[StoreDetailsViewC alloc]init];
    vc.shopId = _shopListArr[indexPath.section][@"shop_id"];
    vc.headTitle = _shopListArr[indexPath.section][@"shop_name"];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
//下拉刷新图片
-(NSMutableArray*)idleImages{
    if (!_idleImages) {
        // 设置普通状态的动画图片
        _idleImages = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"smallLogo"]];
        [_idleImages addObject:image];
    }
    return _idleImages;
}

-(NSMutableArray*)refreshingImages{
    if (!_refreshingImages) {
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        _refreshingImages = [NSMutableArray array];
        for (int i = 1; i<=32; i++) {
            UIImage *image = [UIImage imageNamed:@"smallLogo"];
            [_refreshingImages addObject:image];
        }
    }
    return _refreshingImages;
}
#pragma mark  -----  无数据展示界面 -----
-(void)createNilView{
    //没有数据的时候显示
    _nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_choiceScrollView.frame),WIN_WIDTH, WIN_HEIGHT-CGRectGetMaxY(_choiceScrollView.frame))];
    _nilView1.backgroundColor = [UIColor whiteColor];
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-50, WIN_HEIGHT/2-M_WIDTH(180), 100, 100)];
    [nilImgView setImage:[UIImage imageNamed:@"iconfont-shibai1"]];
    [_nilView1 addSubview:nilImgView];
    [self.view addSubview:_nilView1];
}

@end
