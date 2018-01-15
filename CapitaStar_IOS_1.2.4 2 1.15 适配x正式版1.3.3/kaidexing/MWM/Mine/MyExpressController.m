//
//  MyExpressController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/24.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "MyExpressController.h"
#import "PullingRefreshTableView.h"
#import "GoViewController.h"
#import "ReTableView.h"

@interface MyExpressController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ZhuRefreshTableView>

@property (strong,nonatomic)UIButton        *selectBtn;
@property (strong,nonatomic)NSMutableArray  *dataAry;

@end

@implementation MyExpressController
{
    UIView* tabView;
    ReTableView  *tableView1;
    int type;
    UIView *_buttonDownView;//按钮下划线
    NSInteger   tag;
    NSInteger   page;
    BOOL        isend;
    NSString    *status;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isend=NO;
    status=@"-1";
    self.dataAry=[[NSMutableArray alloc]init];
    self.navigationBarTitleLabel.text=@"快递订单";
    [self createTabView];
    [self createTableView];
    [self loadData2:nil];
}


-(void) createTabView{
    tag=200;
    tabView = [[UIView alloc] init];
    tabView.backgroundColor=[UIColor whiteColor];
    tabView.frame = CGRectMake(0,NAV_HEIGHT, SCREEN_FRAME.size.width,45);
    NSArray* titleArr = @[@"全部",@"已使用",@"未使用",];
    for(int i = 0; i < titleArr.count; i++){
        float width = i*SCREEN_FRAME.size.width/3;
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake(width,0,SCREEN_FRAME.size.width/3,43);
        [headBtn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        headBtn.titleLabel.font=COMMON_FONT;
        [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headBtn setTitleColor:APP_BTN_COLOR   forState:UIControlStateSelected];
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
                isend=NO;
                status=@"-1";
                [self loadData2:nil];
            }
            break;
        case 201:
            if (tag !=201) {
                tag=201;
                isend=NO;
                status=@"1";
                [self loadData2:nil];
            }
            break;
        case 202:
            if (tag !=202) {
                tag=202;
                isend=NO;
                status=@"0";
                [self loadData2:nil];
            }
            break;
        default:
            break;
    }
}

-(void)tableView_refresh:(NSString *)type1{
    [self loadData2:type1];
}

-(void)loadData2:(NSString*)typestr{
    
    if (typestr == nil || [typestr isEqualToString:REFRESH_METHOD]) {
        page = 1;
        isend=NO;
    }else if (isend==YES) {
        [SVProgressHUD showErrorWithStatus:@"没有更多数据"];
        [tableView1 tableViewDidFinishedLoading];
        return;
    }else {
        page++;
    }
    
    if (typestr == nil ) {
        [SVProgressHUD showWithStatus:@"正在努力加载中"];
    }

    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"getexpresslist"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"10",@"pageSize",@(page),@"page",status,@"status",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            if (typestr == nil || [typestr isEqualToString:REFRESH_METHOD]) {
                [self.dataAry removeAllObjects];
            }
            [self.dataAry addObjectsFromArray:dic[@"data"][@"expresslist"]];
            isend=[dic[@"data"][@"isEnd"]boolValue];
            [tableView1 reloadData];
            [tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
           
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}


-(void) createTableView{
    tableView1 = [[ReTableView alloc] initWithFrame:CGRectMake(0,NAV_HEIGHT+45, SCREEN_FRAME.size.width, WIN_HEIGHT -NAV_HEIGHT-45) style:UITableViewStylePlain];
    tableView1.backgroundColor = [UIColor whiteColor];
    [tableView1 setSeparatorColor:[UIColor clearColor]];
    tableView1.scrollEnabled=YES;
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.refreshTVDelegate=self;
    [self.view addSubview:tableView1];
}

//#pragma mark - PullingRefreshTableViewDelegate
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

//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [tableView1 tableViewDidEndDragging:vScrollView];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    [tableView1 tableViewDidScroll:vScrollView];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return M_WIDTH(238);
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
    UIView *view=[self createCellView :indexPath];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    [cell addSubview:view];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoViewController *gvc=[[GoViewController alloc]init];
    NSDictionary *dic=_dataAry[indexPath.row];
    gvc.path=dic[@"link_url"];
    [self.delegate.navigationController pushViewController:gvc animated:YES];
}

-(UIView*)createCellView:(NSIndexPath*)index
{
    
    NSDictionary *dic=_dataAry[index.row];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(238))];
    view.backgroundColor=[UIColor whiteColor];
    
    UIView *colorView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, M_WIDTH(11))];
    colorView.backgroundColor=UIColorFromRGB(0xf4f4f4);
    [view addSubview:colorView];
    
    UIView    *mineView=[[UIView alloc]initWithFrame:CGRectMake(0, M_WIDTH(11), WIN_WIDTH, 227)];
    UIImageView  *headImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(11),M_WIDTH(14),M_WIDTH(14), M_WIDTH(14))];
    [headImg setImage:[UIImage imageNamed:@"geren"]];
    [mineView addSubview:headImg];
    
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(28), 0,M_WIDTH(150), M_WIDTH(43))];
    NSString *sda=[Util isNil:dic[@"collect_name"]];
    titleLab.text=[NSString stringWithFormat:@"%@%@",@"收件人: ",sda];
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.font=DESC_FONT;
    [mineView addSubview:titleLab];
    
    UILabel *typeLab=[[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(200),0,M_WIDTH(185),M_WIDTH(43))];
    int typeint=[dic[@"verification_status"]intValue];
    if (typeint==0) {
        typeLab.text=@"未使用";
    }else {
        typeLab.text=@"已使用";
    }
    typeLab.textAlignment=NSTextAlignmentRight;
    typeLab.textColor=[UIColor redColor];
    typeLab.font=DESC_FONT;
    [mineView addSubview:typeLab];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,M_WIDTH(42), WIN_WIDTH, 1)];
    lineView1.backgroundColor=COLOR_LINE;
    [mineView addSubview:lineView1];
    
    UILabel *cityLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),CGRectGetMaxY(lineView1.frame)+M_WIDTH(15), WIN_WIDTH-M_WIDTH(20), M_WIDTH(23))];
    cityLab.textAlignment=NSTextAlignmentLeft;
    cityLab.font=COOL_FONT;
    [mineView addSubview:cityLab];
    
    UILabel *addressLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(cityLab.frame), WIN_WIDTH-M_WIDTH(70), M_WIDTH(18))];
    NSArray *ary=dic[@"collect_address"];
    if (ary.count==4) {
        NSString *addressstr=[NSString stringWithFormat:@"%@  %@  %@",[Util isNil:ary[0]],[Util isNil:ary[1]],[Util isNil:ary[2]]];
        cityLab.text=addressstr;
        addressLab.text=[Util isNil:ary[3]];
    }
    addressLab.numberOfLines=2;
    addressLab.textColor=COLOR_FONT_SECOND;
    addressLab.textAlignment=NSTextAlignmentLeft;
    addressLab.font=DESC_FONT;
    CGRect rect4=[addressLab.text boundingRectWithSize:CGSizeMake(WIN_WIDTH-M_WIDTH(60),M_WIDTH(35)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:addressLab.font} context:nil];
    addressLab.frame=CGRectMake(addressLab.frame.origin.x, addressLab.frame.origin.y, rect4.size.width, rect4.size.height);
    [mineView addSubview:addressLab];
    
    float   phone_top;
    if (addressLab.numberOfLines==1) {
        phone_top=M_WIDTH(12);
    }else{
        phone_top=M_WIDTH(5);
    }

    UILabel *phoneLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(addressLab.frame)+phone_top, WIN_WIDTH-M_WIDTH(30), M_WIDTH(15))];
    phoneLab.textAlignment=NSTextAlignmentLeft;
    phoneLab.font=DESC_FONT;
    NSString *phoneStr=[Util isNil:dic[@"collect_phone"]];
    phoneLab.text=phoneStr;
    [mineView addSubview:phoneLab];
    
    UIImageView *rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(18),CGRectGetMaxY(lineView1.frame)+M_WIDTH(41), M_WIDTH(7), M_WIDTH(12))];
    [rightImg setImage:[UIImage imageNamed:@"right_2"]];
    [mineView addSubview:rightImg];
    
    UIView *lingView2=[[UIView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(142)-1,WIN_WIDTH-M_WIDTH(10), 1)];
    lingView2.backgroundColor=COLOR_LINE;
    [mineView addSubview:lingView2];
    
    UILabel *shifuLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10), CGRectGetMaxY(lingView2.frame), WIN_WIDTH-M_WIDTH(22), M_WIDTH(42))];
    int  shifuStr=[[Util isNil:dic[@"cost"]]intValue];
    shifuLab.text=[NSString stringWithFormat:@"%@%d%@",@"实付：",shifuStr,@"积分"];
    shifuLab.textAlignment=NSTextAlignmentRight;
    shifuLab.font=COMMON_FONT;
    [mineView addSubview:shifuLab];
    
    
    UIView *kuaidiView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shifuLab.frame), WIN_WIDTH, M_WIDTH(43))];
    kuaidiView.backgroundColor=UIColorFromRGB(0xfefcea);
    //配送信息
    UILabel *peisongLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),M_WIDTH(12.5), M_WIDTH(70), M_WIDTH(15))];
    peisongLab.text=@"配送信息";
    peisongLab.font=COMMON_FONT;
    peisongLab.textAlignment=NSTextAlignmentLeft;
    peisongLab.font=[UIFont systemFontOfSize:15];
    [kuaidiView addSubview:peisongLab];
    
    //快递小箭头
    UIImageView *jiantou2=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(21),M_WIDTH(15), M_WIDTH(8), M_WIDTH(13))];
    [jiantou2 setImage:[UIImage imageNamed:@"right_2"]];
    [kuaidiView addSubview:jiantou2];
    
    //快递单号
    UILabel  *kuaidiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(80),M_WIDTH(13),WIN_WIDTH-M_WIDTH(103), M_WIDTH(14))];
    kuaidiLab.textAlignment=NSTextAlignmentRight;
    kuaidiLab.font=DESC_FONT;
    kuaidiLab.textColor=UIColorFromRGB(0xf3484b);
    NSString *kuaidiStr=[NSString stringWithFormat:@"%@%@%@",[Util isNil:dic[@"logistics_order_remark"]],@":",[Util isNil:dic[@"logistics_order_no"]]];
    kuaidiLab.text=kuaidiStr;
    [kuaidiView addSubview:kuaidiLab];
    [mineView addSubview:kuaidiView];
    
    [view addSubview:mineView];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
