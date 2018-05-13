//
//  RecentBillsController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/12.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "RecentBillsController.h"
#import "MyCollectionTableViewCell.h"

@interface RecentBillsController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * dataArr;
}
@property (strong,nonatomic)UITableView         *tableView1;
@property (strong,nonatomic)UIView              *xiaopiaoView;//点击记录弹出的视图


@end

@implementation RecentBillsController
{
    UIButton *xiaoBtn;
    BOOL     touchBool;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTitleLabel.text=@"最近的20笔星积分";
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    touchBool=YES;
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(10, NAV_HEIGHT, 150,14)];
    titleLab.text=@"最近的20笔星积分";
    titleLab.textAlignment=NSTextAlignmentLeft;
    titleLab.font=COMMON_FONT;
    [self.view addSubview:titleLab];
    
    [self NetWorkRequest];
   
}

#pragma mark   ------请求网络-----

-(void)NetWorkRequest
{
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"receiptsrecord"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@"1000",@"source",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            dataArr = dic[@"data"];
            [self initHeadView];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
#pragma mark   ------视图加载-----
-(void)initHeadView
{
    
    
    self.tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, 108, WIN_WIDTH, self.view.frame.size.height-108) style:UITableViewStylePlain];
    self.tableView1.delegate=self;
    self.tableView1.dataSource=self;
    self.tableView1.backgroundColor=[UIColor whiteColor];
    self.tableView1.scrollEnabled=YES;
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView1];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *reuseIdentifier=@"cellID2";
    
    MyCollectionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[MyCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.dataDic = dataArr[indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-------点击了cell--------");
    if (touchBool==YES) {
         touchBool=NO;
        NSDictionary * dic = dataArr[indexPath.row];
        if ([Util isNull:dic[@"ImageName"]]) {
            
        }else {
            [self NetWorkRequest2:dic[@"ImageName"]];
        }
    }
}


-(void)xiaopiaoView:(UIImage *)img
{
    
        _xiaopiaoView=[[UIView alloc]initWithFrame:self.view.bounds];
        _xiaopiaoView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        UIView *xiaoView=[[UIView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2 -124.5,WIN_HEIGHT*0.38,249,180)];
        xiaoView.backgroundColor=[UIColor whiteColor];
        xiaoView.layer.masksToBounds=YES;
        xiaoView.layer.cornerRadius=8;
        
        //小票预览文字
        UILabel *xiaoLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, 249, 22)];
        xiaoLab.text=@"小票预览";
        xiaoLab.textAlignment=NSTextAlignmentCenter;
        xiaoLab.font=COMMON_FONT;
        
        UIImageView *xiaoImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(xiaoLab.frame), 229, 103)];
        xiaoImg.contentMode=UIViewContentModeScaleAspectFit;
        [xiaoImg setImage:img];
    
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(xiaoImg.frame), 249, 0.5)];
        lineView.backgroundColor=COLOR_LINE;
        
        xiaoBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lineView.frame), 239, 43)];
        xiaoBtn.titleLabel.font=COMMON_FONT;
        [xiaoBtn setTitle:@"确定" forState:UIControlStateNormal];
        [xiaoBtn setTitleColor:UIColorFromRGB(0x2d8eff) forState:UIControlStateNormal];
        [xiaoBtn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [xiaoView addSubview:xiaoLab];
        [xiaoView addSubview:xiaoImg];
        [xiaoView addSubview:lineView];
        [xiaoView addSubview:xiaoBtn];
        [_xiaopiaoView addSubview:xiaoView];
        [self.view addSubview:_xiaopiaoView];
  
}
-(void)NetWorkRequest2:(NSString *)imgStr
{
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"usercenter" tp:@"getreceiptimg"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:imgStr,@"ImageName",nil ]  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
       
            NSData      *decodedImageData   = [[NSData alloc]initWithBase64Encoding:dic[@"data"]];
            UIImage     *decodedImage       = [UIImage imageWithData:decodedImageData];
            [self xiaopiaoView:decodedImage];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
    }];
}

- (UIImage *) dataURL2Image: (NSString *) imgSrc
{
    NSURL *url = [NSURL URLWithString: imgSrc];
    NSData *data = [NSData dataWithContentsOfURL: url];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}

-(void)btnTouch:(UIButton*)sender
{
    touchBool=YES;
    xiaoBtn.enabled=NO;
    self.xiaopiaoView.hidden=YES;
    [self.xiaopiaoView removeFromSuperview];
    
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
