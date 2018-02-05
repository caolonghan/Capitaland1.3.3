//
//  MyOrdersViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/14.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "PullingRefreshTableView.h"
#import "OrderDetailsController.h"
#import "SinceController.h"
#import "ReTableView.h"

#define cell_Head       M_WIDTH(93)//93
#define cell_view_H     M_WIDTH(85)
#define cell_kuaidi     M_WIDTH(40)

@interface MyOrdersViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>
@property(strong,nonatomic) UIButton *selectBtn;//点击选中
@property(strong,nonatomic) NSMutableArray  *dataAry;
@property(strong,nonatomic) ReTableView* tableView1;
@end

@implementation MyOrdersViewController{
    @private
    UIView* tabView;
    
    int type;
    UIView *_buttonDownView;//按钮下划线
    NSInteger   tag;
    NSInteger   page;
    BOOL        isEnd;
    NSString    *order_type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    order_type=@"1";
    isEnd=NO;
    self.navigationBarTitleLabel.text=@"我的订单";
    self.dataAry=[[NSMutableArray alloc]init];
    type = 0;
    [self createTabView];
    [self createTableView];
    [self loadData2:nil];
    
}

-(void) createTabView{
    tag=200;
    tabView = [[UIView alloc] init];
    tabView.backgroundColor=[UIColor whiteColor];
    tabView.frame = CGRectMake(0,NAV_HEIGHT, SCREEN_FRAME.size.width,45);
    NSArray* titleArr = @[@"已支付",@"已完成",@"全部",];
    for(int i = 0; i < titleArr.count; i++){
        float width = i*SCREEN_FRAME.size.width/3;
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake(width,0,SCREEN_FRAME.size.width/3,43);
        [headBtn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        headBtn.titleLabel.font=COMMON_FONT;
        [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headBtn setTitleColor:APP_BTN_COLOR  forState:UIControlStateSelected];
        headBtn.tag = 200+i;
        if (i==0) {
            headBtn.selected = YES;//默认第一个的时候是选中状态
            self.selectBtn = headBtn;
        }
       
        [headBtn addTarget:self action:@selector(headTouch:) forControlEvents:UIControlEventTouchUpInside];
        [tabView addSubview:headBtn];
    }
    _buttonDownView =[[UIView alloc]initWithFrame:CGRectMake(0,43,SCREEN_FRAME.size.width/3, 2)];
    _buttonDownView.backgroundColor=APP_BTN_COLOR;
    [tabView addSubview:_buttonDownView];
    [self.view addSubview:tabView];
}

-(void) createTableView{
    _tableView1 = [[ReTableView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT+45,WIN_WIDTH,WIN_HEIGHT-NAV_HEIGHT-45) style:UITableViewStylePlain];
    _tableView1.backgroundColor = [UIColor whiteColor];
    [_tableView1 setSeparatorColor:[UIColor clearColor]];
    _tableView1.dataSource = self;
    _tableView1.delegate = self;
    _tableView1.scrollEnabled=YES;
    _tableView1.refreshTVDelegate=self;
    [self.view addSubview:_tableView1];

}
-(void)tableView_refresh:(NSString *)type1{
    [self loadData2:type1];
}

-(void)loadData2:(NSString*)typestr{
    
    if (typestr == nil || [typestr isEqualToString:REFRESH_METHOD]) {
        page = 1;
        isEnd=NO;
        [self.dataAry removeAllObjects];
    }else if (isEnd==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [_tableView1 tableViewDidFinishedLoading];
        [_tableView1 noticeNoMoreData];
        return;
    }else {
        page++;
    }
    if (typestr == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getuserorder"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",order_type,@"order_status",@"5",@"page",@"3",@"pageSize",@"",@"order_no",nil ] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
           
            [self.dataAry addObjectsFromArray:dic[@"data"][@"order_list"] ];
             isEnd=[dic[@"data"][@"isEnd"]boolValue];
            [_tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
            [_tableView1 reloadData];
        });
    }failue:^(NSDictionary *dic){
        [_tableView1 tableViewDidFinishedLoading];
        NSLog(@"%@",dic);
    }];
}

#pragma mark - PullingRefreshTableViewDelegate
//- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(loadData2:) withObject:REFRESH_METHOD afterDelay:0.f];
//}
//
//- (NSDate *)pullingTableViewRefreshingFinishedDate{
//    return [[NSDate alloc] init];
//}
//
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(loadData2:) withObject:MORE_METHOD afterDelay:0.f];
//    
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [_tableView1 tableViewDidEndDragging:vScrollView];
//}
//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    [_tableView1 tableViewDidScroll:vScrollView];
//}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  cell_H;
    NSDictionary *dict=self.dataAry[indexPath.section];
    int  extract_type = [[Util isNil:dict[@"extract_type"]]intValue];
    NSArray  *goodAry= dict[@"good_list"];
    if (extract_type==0  || extract_type==2) {
        cell_H=cell_Head+(goodAry.count)*cell_view_H;
    }else if (extract_type==1){
        cell_H=cell_Head+(goodAry.count)*cell_view_H+cell_kuaidi;
    }
    return cell_H;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//处理每行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier =@"Cell0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reuseIdentifier];
    }
    [UIUtil removeSubView:cell];
    UIView *view=[self createRow:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailsController *oVC=[[OrderDetailsController alloc]init];
    NSDictionary *dic=self.dataAry[indexPath.section];
    oVC.orderID=dic[@"order_no"];
    oVC.orderNO=dic[@"logistics_address_id"];
    oVC.orderType=dic[@"extract_type"];
    [self.delegate.navigationController pushViewController:oVC animated:YES];
}

//头部按钮的点击事件
-(void)headTouch:(UIButton*)sender
{
    if(self.selectBtn != nil){
        self.selectBtn.selected=NO;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [_buttonDownView setFrame:CGRectMake((sender.tag-200)*(WIN_WIDTH/3),43, WIN_WIDTH/3,2)];
    }];
    sender.selected=YES;
    self.selectBtn=sender;
    switch (sender.tag) {
        case 200:
            if (tag !=200) {
                tag=200;
                page=1;
                isEnd=NO;
                order_type=@"1";
                [self loadData2:nil];
            }
            break;
        case 201:
            if (tag !=201) {
                tag=201;
                page=1;
                isEnd=NO;
                order_type=@"3";
                [self loadData2:nil];
            }
            break;
        case 202:
            if (tag !=202) {
                tag=202;
                page=1;
                isEnd=NO;
                order_type=@"0";
                [self loadData2:nil];
            }
            break;
        default:
            break;
    }
}

-(UIView*)createRow:(NSIndexPath*)indexPath
{
    NSDictionary *dic=self.dataAry[indexPath.section];
    UIView *cellView=[[UIView alloc]init];
    int  money=0;
    int  shopCount=0;
    //表示商城的图标
    UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(15),M_WIDTH(14.5),M_WIDTH(13))];
    [iconImg setImage:[UIImage imageNamed:@"house"]];
    [cellView addSubview:iconImg];
    //商城的名字
    UILabel  *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(5),(M_WIDTH(42)-M_WIDTH(14))/2, M_WIDTH(20), M_WIDTH(14))];
    nameLab.font=[UIFont systemFontOfSize:M_WIDTH(14)];
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.text=[Util isNil:dic[@"mall_name"]];
    [nameLab sizeToFit];
    [cellView addSubview:nameLab];
    
    //商城后面的箭头
    CGFloat img_H=M_WIDTH(13);
    
    UIImageView *rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame)+M_WIDTH(7), (M_WIDTH(44)-img_H)/2, M_WIDTH(8),img_H)];
    [rightImg setImage:[UIImage imageNamed:@"right_2"]];
    [cellView addSubview:rightImg];
    
    UILabel *orderStatusLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(110),0,M_WIDTH(100), M_WIDTH(42))];
    orderStatusLab.textColor=[UIColor redColor];
    orderStatusLab.textAlignment=NSTextAlignmentRight;
    orderStatusLab.font=DESC_FONT;
    int  extract_type = [[Util isNil:dic[@"extract_type"]]intValue];
    NSString *extract_typeStr;
    if (extract_type==0) {
        extract_typeStr=@"自提";
    }else if (extract_type==1){
        extract_typeStr=@"快递";
    }else if (extract_type==2){
        extract_typeStr=@"电子券";
    }
    orderStatusLab.text=extract_typeStr;
    [cellView addSubview:orderStatusLab];
    
    //中间第一条分割线
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(42), WIN_WIDTH,1)];
    line1.backgroundColor=COLOR_LINE;
    [cellView addSubview:line1];
    NSArray *itemArray=dic[@"good_list"];
    UIView *shopView;
    for (int i=0;i<itemArray.count;i++) {
        NSDictionary *diction=itemArray[i];
        NSLog(@"%@",diction);
        shopView=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(53)+cell_view_H*i, WIN_WIDTH, cell_view_H)];
        
        //购买的商品的Logo
        UIImageView  *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(0), M_WIDTH(73), M_WIDTH(73))];
        logoImg.contentMode=UIViewContentModeScaleAspectFit;
        logoImg.layer.borderColor=[COLOR_LINE CGColor];
        logoImg.layer.borderWidth=1;
        [logoImg setImageWithURL:[NSURL URLWithString:[Util isNil:diction[@"img_url"]]]];
        [shopView addSubview:logoImg];
        
        //商品的名字
        UILabel  *commodityNameLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10),0, M_WIDTH(220), M_WIDTH(20))];
        commodityNameLab.textAlignment=NSTextAlignmentLeft;
        commodityNameLab.text=[Util isNil:diction[@"title"]];
        commodityNameLab.numberOfLines=0;
        commodityNameLab.font=COMMON_FONT;
        CGRect rect2=[commodityNameLab.text boundingRectWithSize:CGSizeMake(M_WIDTH(220),M_WIDTH(36)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:commodityNameLab.font} context:nil];
        commodityNameLab.frame=CGRectMake(commodityNameLab.frame.origin.x, commodityNameLab.frame.origin.y, rect2.size.width, rect2.size.height);
        [shopView addSubview:commodityNameLab];
        
        //商品描述
        UILabel  *describeLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10), CGRectGetMaxY(commodityNameLab.frame)+M_WIDTH(2), M_WIDTH(220), M_WIDTH(12))];
        describeLab.textColor=COLOR_FONT_SECOND;
        describeLab.font=INFO_FONT;
        describeLab.textAlignment=NSTextAlignmentLeft;
        describeLab.text=[Util isNil:diction[@"good_name"]];
        [shopView addSubview:describeLab];
        
        //价格
        UILabel  *unitPriceLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10), CGRectGetMaxY(logoImg.frame)-M_WIDTH(15), M_WIDTH(150), M_WIDTH(12))];
        int integtal=[[Util isNil:diction[@"integral"]]intValue];
        money=money+integtal;
        unitPriceLab.text=[NSString stringWithFormat:@"%d %@",integtal,@"积分"];
        unitPriceLab.textAlignment=NSTextAlignmentLeft;
        unitPriceLab.font=DESC_FONT;
        unitPriceLab.textColor=COLOR_FONT_SECOND;
        [shopView addSubview:unitPriceLab];
        
        //相同商品数量
        UILabel  *numberLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(60), CGRectGetMaxY(logoImg.frame)-M_WIDTH(16), M_WIDTH(50), M_WIDTH(12))];
        numberLab.textAlignment=NSTextAlignmentRight;
        numberLab.font=DESC_FONT;
        int count=[[Util isNil:diction[@"qty"]]intValue];
        shopCount=shopCount+count;
        numberLab.text=[NSString stringWithFormat:@"%@%d",@"x",count];
        [shopView addSubview:numberLab];

        [cellView addSubview:shopView];
    }
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(shopView.frame)-1, WIN_WIDTH-M_WIDTH(10), 1)];
    line2.backgroundColor=COLOR_LINE;
    [cellView addSubview:line2];
    
    UILabel  *freightLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(shopView.frame),WIN_WIDTH-M_WIDTH(20), M_WIDTH(40))];
    freightLab.font=DESC_FONT;
    freightLab.textAlignment=NSTextAlignmentRight;
    int total_integral=[[Util isNil:dic[@"total_integral"]]intValue];
    int yunfei=total_integral-money;
    freightLab.text=[NSString stringWithFormat:@"%@%d%@%d%@%d%@",@"共",shopCount,@"件商品 实付:",total_integral,@" 积分(含运费：",yunfei,@")"];
    
    [cellView addSubview:freightLab];
    
    if (extract_type==1) {
        UIView *kuaidiView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shopView.frame)+M_WIDTH(41), WIN_WIDTH, M_WIDTH(40))];
        kuaidiView.backgroundColor=UIColorFromRGB(0xfefcea);//000000
        //配送信息
        UILabel *peisongLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(12.5), M_WIDTH(70), M_WIDTH(15))];
        peisongLab.text=@"配送信息";
        peisongLab.font=COMMON_FONT;
        peisongLab.textAlignment=NSTextAlignmentLeft;
        peisongLab.font=[UIFont systemFontOfSize:15];
        [kuaidiView addSubview:peisongLab];
        
        //快递小箭头
        UIImageView *jiantou2=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(23),M_WIDTH(13.5), M_WIDTH(8), M_WIDTH(13))];
        [jiantou2 setImage:[UIImage imageNamed:@"right_2"]];
        [kuaidiView addSubview:jiantou2];
        
        //快递单号
        UILabel  *kuaidiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(80),M_WIDTH(13),WIN_WIDTH-M_WIDTH(110), M_WIDTH(14))];
        kuaidiLab.textAlignment=NSTextAlignmentRight;
        kuaidiLab.font=DESC_FONT;
        kuaidiLab.textColor=UIColorFromRGB(0xf3484b);
        NSString *kuaidiStr=[NSString stringWithFormat:@"%@%@%@",@"哪家快递",@":",[Util isNil:dic[@"logistics_order_no"]]];
        kuaidiLab.text=kuaidiStr;
        [kuaidiView addSubview:kuaidiLab];
        [cellView addSubview:kuaidiView];
        cellView.frame=CGRectMake(0, 0, WIN_WIDTH, cell_Head+(cell_view_H*itemArray.count)+cell_kuaidi);
    }else{
        cellView.frame=CGRectMake(0, 0, WIN_WIDTH, cell_Head+(cell_view_H*itemArray.count));
    }

    
   
    
    
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
//    cellView.tag=index;
//    [cellView addGestureRecognizer:tapGesture];
    
    
//    if (extract_type==0 || extract_type==2) {
    
//    }
    
    return cellView;
}
//- (void)event:(UITapGestureRecognizer *)gesture
//{   
//    OrderDetailsController *oVC=[[OrderDetailsController alloc]init];
//    [self.delegate.navigationController pushViewController:oVC animated:YES];
//}


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
