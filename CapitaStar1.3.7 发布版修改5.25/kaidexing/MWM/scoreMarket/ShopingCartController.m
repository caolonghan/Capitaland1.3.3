//
//  ShopingCartController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/27.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ShopingCartController.h"
#import "SettleAccountsController.h"

#define cell_head_H     M_WIDTH(64)
#define cell_content_H  M_WIDTH(76)

@interface ShopingCartController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView         *tableView1;

@end

@implementation ShopingCartController
{
    UIButton                   *jiesuanBtn;
    NSMutableDictionary        *dataDiction;
    UIImageView                *quanbuimg;
    BOOL                       _quanxuanBool;
    UILabel                    *hejiLab;
    NSMutableArray             *jiesuanAry;
    UIView                     *nilView1;
    UIView                     *buttomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _quanxuanBool=NO;
    dataDiction=[[NSMutableDictionary alloc]init];
    jiesuanAry=[[NSMutableArray alloc]init];
    self.navigationBarTitleLabel.text=@"购物车";
    self.tableView1.scrollEnabled=YES;
    [self initHeadView];
    [self initButtomView];
    [self loadData];
}

-(UITableView*)tableView1
{
    if (!_tableView1) {
        _tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT+M_WIDTH(40), WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(85)-45) style:UITableViewStylePlain];
        _tableView1.backgroundColor=[UIColor clearColor];
        _tableView1.delegate=self;
        _tableView1.dataSource=self;
        _tableView1.separatorStyle=UITableViewCellSelectionStyleNone;
        [self.view addSubview:_tableView1];
    }
    return _tableView1;
}

//购物车商品列表
-(void)loadData{
    [nilView1 removeFromSuperview];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"getcart"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
            NSMutableArray * dataAry=[[NSMutableArray alloc]init];
            dataAry=dic[@"data"];
            dataDiction=[self chuliAry:dataAry];
            [self.tableView1 reloadData];
            
            if (dataAry.count==0) {
                [self initnilView];
            }
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}

//删除商品
-(void)loadDeleData:(int)idint{
    
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"delcart"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",@(idint),@"ids",nil] target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",dic);
        });
    }failue:^(NSDictionary *dic){
        NSLog(@"%@",dic);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array=[[NSArray alloc]init];
    array=[dataDiction allKeys];
    NSArray *array1=[dataDiction objectForKey:array[indexPath.row]];
    return cell_content_H*(array1.count-1)+cell_head_H;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array=[[NSArray alloc]init];
    array=[dataDiction allKeys];
    return array.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [UIUtil removeSubView:cell];
    UIView *view=[self creatCell_View:indexPath];
    [cell addSubview:view];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}


-(UIView*)creatCell_View:(NSIndexPath*)indexpath
{
    NSArray *array=[[NSArray alloc]init];
    array=[dataDiction allKeys];
    NSArray *array1=[dataDiction objectForKey:array[indexpath.row]];
  
    UIView *rootView=[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,cell_head_H+cell_content_H*(array1.count-1))];
    
    UIImageView     *headimg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(13), M_WIDTH(15), M_WIDTH(15))];
    if ([array1[0]isEqualToString:@"0"]) {
        [headimg setImage:[UIImage imageNamed:@"round"]];
    }else{
        [headimg setImage:[UIImage imageNamed:@"r_round"]];
    }
    
    [rootView addSubview:headimg];
    UIButton *shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,M_WIDTH(43),M_WIDTH(43))];
    shopBtn.tag=indexpath.row;
    [shopBtn addTarget:self action:@selector(shioTouch:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:shopBtn];
    
    UIImageView     *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headimg.frame)+M_WIDTH(11), M_WIDTH(14.5), M_WIDTH(14.5), M_WIDTH(13))];
    [iconImg setImage:[UIImage imageNamed:@"house"]];
    [rootView addSubview:iconImg];
    
    UILabel *shopName=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImg.frame)+M_WIDTH(5),0, WIN_WIDTH-M_WIDTH(100),M_WIDTH(43))];
    shopName.font=DESC_FONT;
    shopName.textAlignment=NSTextAlignmentLeft;
    shopName.text=array[indexpath.row];
    [rootView addSubview:shopName];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(shopName.frame), WIN_WIDTH, 1)];
    lineView.backgroundColor=COLOR_LINE;
    [rootView addSubview:lineView];
    
    for (int i=1; i<array1.count; i++) {
        NSDictionary *dic=array1[i];
        
        UIView *itemView=[[UIView alloc]initWithFrame:CGRectMake(0,(cell_head_H-M_WIDTH(10))+(i-1)*cell_content_H, WIN_WIDTH, cell_content_H)];
        UIImageView     *yuanimg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(23), M_WIDTH(15), M_WIDTH(15))];
        if ([dic[@"isXZ"]isEqualToString:@"0"]) {
            [yuanimg setImage:[UIImage imageNamed:@"round"]];
        }else {
            [yuanimg setImage:[UIImage imageNamed:@"r_round"]];
        }
        [itemView addSubview:yuanimg];
        
        UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(34),0,M_WIDTH(65),M_WIDTH(65))];
        [logoImg setImageWithURL:[NSURL URLWithString:[Util isNil:dic[@"img_url"]]]];
        logoImg.layer.borderColor=COLOR_LINE.CGColor;
        logoImg.layer.borderWidth=1;
        logoImg.contentMode=UIViewContentModeScaleAspectFit;
        [itemView addSubview:logoImg];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,M_WIDTH(34),M_WIDTH(76))];
        btn.tag=i;
        btn.tag=indexpath.row*100+i;
        [btn addTarget:self action:@selector(cell_row_Touch:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:btn];
        
        UILabel  *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10),0, M_WIDTH(170), M_WIDTH(29))];
        titleLab.font=COMMON_FONT;
        titleLab.textAlignment=NSTextAlignmentLeft;
        titleLab.numberOfLines=2;
        titleLab.text=[Util isNil:dic[@"title"]];
        [titleLab sizeToFit];
        [itemView addSubview:titleLab];// 76   21  // 26  27
        
        UIImageView *deleImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(23), 0, M_WIDTH(13), M_WIDTH(13.5))];
        [deleImg setImage:[UIImage imageNamed:@"garbage"]];
        [itemView addSubview:deleImg];
        
        UIButton *deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(40), 0, M_WIDTH(40), M_WIDTH(40))];
        deleteBtn.tag = indexpath.row*100+i;
        [deleteBtn addTarget:self action:@selector(delegateTouch:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:deleteBtn];
        
        UILabel  *jifenLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImg.frame)+M_WIDTH(10), CGRectGetMaxY(logoImg.frame)-M_WIDTH(12), M_WIDTH(100), M_WIDTH(12))];
        int integral=[[Util isNil:dic[@"integral"]]intValue];
        int cartnum=[[Util isNil:dic[@"cartnum"]]intValue];
        jifenLab.text=[NSString stringWithFormat:@"%d%@",integral*cartnum,@"积分"];
        jifenLab.textAlignment=NSTextAlignmentLeft;
        jifenLab.font=INFO_FONT;
        jifenLab.textColor=[UIColor redColor];
        [itemView addSubview:jifenLab];
        
        UIImageView *addImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(86), M_WIDTH(45), M_WIDTH(76), M_WIDTH(21))];
        [addImg setImage:[UIImage imageNamed:@"addandsubtract"]];
        [addImg setUserInteractionEnabled:YES];
        [itemView addSubview:addImg];
        
        UILabel *countLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(25), 0, M_WIDTH(26), M_WIDTH(21))];
        countLab.text=[NSString stringWithFormat:@"%d",cartnum];
        countLab.textAlignment=NSTextAlignmentCenter;
        countLab.font=DESC_FONT;
        [addImg addSubview:countLab];
        
        UIButton *lBtn=[[UIButton alloc]initWithFrame:CGRectMake(-M_WIDTH(10),-M_WIDTH(10),M_WIDTH(35),M_WIDTH(41))];
        lBtn.tag=indexpath.row*100 + i;
        [lBtn addTarget:self action:@selector(jianTouch:) forControlEvents:UIControlEventTouchUpInside];
        [addImg addSubview:lBtn];
        
        UIButton *rBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(51),-M_WIDTH(10),M_WIDTH(35),M_WIDTH(41))];
        rBtn.tag=indexpath.row*100 + i;
        [rBtn addTarget:self action:@selector(addTouch:) forControlEvents:UIControlEventTouchUpInside];
        [addImg addSubview:rBtn];
        [rootView addSubview:itemView];
    }
    UIView *buttomView1=[[UIView alloc]initWithFrame:CGRectMake(0, cell_content_H*(array1.count-1)+cell_head_H-M_WIDTH(10), WIN_WIDTH, M_WIDTH(10))];
    buttomView1.backgroundColor=UIColorFromRGB(0xf4f4f4);
    [rootView addSubview:buttomView1];
    return rootView;
}



-(void)initHeadView
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT,WIN_WIDTH, M_WIDTH(40))];
    headView.backgroundColor=UIColorFromRGB(0xf4f4f4);
    UILabel *titlelab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(10),0,WIN_WIDTH/2,M_WIDTH(40))];
    titlelab.text=@"请选择您要结算的商品";
    titlelab.textAlignment=NSTextAlignmentLeft;
    titlelab.font=COMMON_FONT;
    [headView addSubview:titlelab];
    [self.view addSubview:headView];
}

-(void)initButtomView
{
    buttomView=[[UIView alloc]initWithFrame:CGRectMake(0,WIN_HEIGHT-M_WIDTH(45)-45, WIN_WIDTH, M_WIDTH(45))];
    buttomView.backgroundColor=[UIColor whiteColor];
    
    quanbuimg=[[UIImageView alloc]initWithFrame:CGRectMake(M_WIDTH(10), M_WIDTH(15), M_WIDTH(15), M_WIDTH(15))];
    [quanbuimg setImage:[UIImage imageNamed:@"round"]];
    [buttomView addSubview:quanbuimg];

    UILabel *quanxuanLab=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(quanbuimg.frame)+M_WIDTH(5), 0, M_WIDTH(50), M_WIDTH(45))];
    quanxuanLab.text=@"全选";
    quanxuanLab.textAlignment=NSTextAlignmentLeft;
    quanxuanLab.font=COMMON_FONT;
    [buttomView addSubview:quanxuanLab];
    UIButton *quanxuanBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, M_WIDTH(80), M_WIDTH(45))];
    [quanxuanBtn addTarget:self action:@selector(quanbuTouch:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:quanxuanBtn];
    
    jiesuanBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(86), 0, M_WIDTH(86), M_WIDTH(45))];
    jiesuanBtn.backgroundColor=UIColorFromRGB(0xdf2b2a);
    [jiesuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSString *str=[NSString stringWithFormat:@"%@%@%@",@"结算(",@"0",@")"];
    [jiesuanBtn setTitle:str forState:UIControlStateNormal];
    [jiesuanBtn addTarget:self action:@selector(jiesuanTouch:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:jiesuanBtn];
    
    hejiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(70),M_WIDTH(10),M_WIDTH(155),M_WIDTH(14))];
    NSString *str1=@"合计：";
    NSString *str2=[NSString stringWithFormat:@"%@%@",@"0",@"积分"];
    [self colorLab:hejiLab :str1 :str2];
    hejiLab.textAlignment=NSTextAlignmentRight;
    hejiLab.font=DESC_FONT;
    [buttomView addSubview:hejiLab];
    
    UILabel *yunfeiLab=[[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(70), CGRectGetMaxY(hejiLab.frame), M_WIDTH(155), M_WIDTH(16))];
    yunfeiLab.text=@"(不含运费)";
    yunfeiLab.font=INFO_FONT;
    yunfeiLab.textAlignment=NSTextAlignmentRight;
    [buttomView addSubview:yunfeiLab];
    [self.view addSubview:buttomView];
}

-(void)quanbuTouch:(UIButton*)sender
{
    if (_quanxuanBool==NO) {
        NSArray *array=[[NSArray alloc]init];
        array=[dataDiction allKeys];
        for (int i=0;i<array.count;i++) {
            NSArray *xuazeAry=[dataDiction objectForKey:array[i]];
            [dataDiction objectForKey:array[i]][0]=@"1";
            for (int j=1; j<xuazeAry.count; j++) {
                [dataDiction objectForKey:array[i]][j][@"isXZ"]=@"1";
            }
        }
        _quanxuanBool=YES;
        [quanbuimg setImage:[UIImage imageNamed:@"r_round"]];
    }else {
        NSArray *array=[[NSArray alloc]init];
        array=[dataDiction allKeys];
        for (int i=0;i<array.count;i++) {
            NSArray *xuazeAry=[dataDiction objectForKey:array[i]];
            [dataDiction objectForKey:array[i]][0]=@"0";
            for (int j=1; j<xuazeAry.count; j++) {
                [dataDiction objectForKey:array[i]][j][@"isXZ"]=@"0";
            }
        }
        _quanxuanBool=NO;
        [quanbuimg setImage:[UIImage imageNamed:@"round"]];
    }
    [self jiesuanMoney];
}

//结算按钮
-(void)jiesuanTouch:(UIButton*)sender
{
    NSLog(@"点击结算按钮");
    NSLog(@"%@",jiesuanAry);
    if (jiesuanAry.count==0) {
        [SVProgressHUD showErrorWithStatus:@"没有要结算的商品"];
    }else{
        [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"integralmall" tp:@"saveorder"] parameters:[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jiesuanAry
                                                                                                                                                                                                                                                                            options:NSJSONWritingPrettyPrinted
                                                                                                                                                                                                                                                                              error:nil] encoding:NSUTF8StringEncoding],@"orders",@"10",@"type",nil] target:self success:^(NSDictionary *dic){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",dic);
                SettleAccountsController *svc=[[SettleAccountsController alloc]init];
                [self.delegate.navigationController pushViewController:svc animated:YES];
            });
        }failue:^(NSDictionary *dic){
            NSLog(@"%@",dic);
        }];
    }
}

//选中一个商城
-(void)shioTouch:(UIButton*)sender
{
    NSArray *array=[[NSArray alloc]init];
    array=[dataDiction allKeys];
    NSArray *xuazeAry=[dataDiction objectForKey:array[sender.tag]];
    NSString *str=xuazeAry[0];
    if ([str isEqualToString:@"0"]) {
        str=@"1";
        for (int i=1; i<xuazeAry.count; i++) {
            [dataDiction objectForKey:array[sender.tag]][i][@"isXZ"]=@"1";
        }
    }else {
        str=@"0";
        for (int i=1; i<xuazeAry.count; i++) {
            [dataDiction objectForKey:array[sender.tag]][i][@"isXZ"]=@"0";
        }
    }
    [dataDiction objectForKey:array[sender.tag]][0]=str;
    [self cell_sention];
}

//每个商品的选中事件
-(void)cell_row_Touch:(UIButton*)sender
{
    NSArray *senderary=[self tag_index:(int)sender.tag];
    NSLog(@"选中了第%@商城中的第%@件商品",senderary[0],senderary[1]);
    NSArray *array=[[NSArray alloc]init];
    array=[dataDiction allKeys];
    int index_s=[senderary[0]intValue];
    int index_c=[senderary[1]intValue];
    NSString  *isxuanze=[dataDiction objectForKey:array[index_s]][index_c][@"isXZ"];
    if ([isxuanze isEqualToString:@"0"]) {
        [dataDiction objectForKey:array[index_s]][index_c][@"isXZ"]=@"1";
    }else{
        [dataDiction objectForKey:array[index_s]][index_c][@"isXZ"]=@"0";
    }
    [self cell_sention];

}

//点击每个商品使商城选择按钮是否被选中
-(void)cell_sention
{
    
    NSArray *array=[[NSArray alloc]init];
    array=[dataDiction allKeys];
    for (int i=0; i<array.count; i++) {
        NSArray *itemAry=[dataDiction objectForKey:array[i]];
        bool   isxz=YES;
        for (int j=1; j<itemAry.count; j++) {
            NSDictionary *dic=itemAry[j];
            NSString *isxuanze=dic[@"isXZ"];
            if ([isxuanze isEqualToString:@"1"]) {
            }else{
                isxz=NO;
                break;
            }
        }
        if (isxz==YES) {
            [dataDiction objectForKey:array[i]][0]=@"1";
        }else{
            [dataDiction objectForKey:array[i]][0]=@"0";
        }
    }
    bool shoppingBool=YES;
    for (int z=0; z<array.count; z++) {
        if (![[dataDiction objectForKey:array[z]][0] isEqualToString:@"1"]) {
            shoppingBool=NO;
        }
    }
    if (shoppingBool==YES) {
        _quanxuanBool=YES;
        [quanbuimg setImage:[UIImage imageNamed:@"r_round"]];
    }else{
        _quanxuanBool=NO;
        [quanbuimg setImage:[UIImage imageNamed:@"round"]];
    }
    
    [self jiesuanMoney];
}

-(void)jiesuanMoney
{
    [jiesuanAry removeAllObjects];
    NSArray *array=[[NSArray alloc]init];
    array=[dataDiction allKeys];
    int count=0;
    int jifen=0;
    for (int i=0; i<array.count; i++) {
        NSArray *itemAry=[dataDiction objectForKey:array[i]];
        for (int j=1; j<itemAry.count; j++) {
            NSDictionary *dic=itemAry[j];
            if ([dic[@"isXZ"]isEqualToString:@"1"]) {
                NSMutableDictionary *mDic=[[NSMutableDictionary alloc]init];
                int cartnum  =[dic[@"cartnum"]intValue];
                int integral =[dic[@"integral"]intValue];
                [mDic setObject:dic[@"cartnum"] forKey:@"quantity"];
                [mDic setObject:dic[@"id"] forKey:@"good_id"];
                [jiesuanAry addObject:mDic];
                count=cartnum+count;
                jifen=jifen+integral*cartnum;
            }
        }
    }
    NSString *str=[NSString stringWithFormat:@"%@%d%@",@"结算(",count,@")"];
    [jiesuanBtn setTitle:str forState:UIControlStateNormal];
    NSString *str1=@"合计：";
    NSString *str2=[NSString stringWithFormat:@"%d%@",jifen,@"积分"];
    [self colorLab:hejiLab :str1 :str2];
    [self.tableView1 reloadData];
}

//每个商品的添加数据量
-(void)addTouch:(UIButton*)sender
{
    NSArray *senderary=[self tag_index:(int)sender.tag];
    NSLog(@"添加了第%@商城中的第%@件商品",senderary[0],senderary[1]);
    [self countLab:senderary :@"1"];
}
//每个商品的减少数量
-(void)jianTouch:(UIButton*)sender
{
    NSArray *senderary=[self tag_index:(int)sender.tag];
    NSLog(@"减少了第%@商城中的第%@件商品",senderary[0],senderary[1]);
    [self countLab:senderary :@"0"];
}
/*删除一件商品*/
-(void)delegateTouch:(UIButton*)sender
{
    NSArray *senderary=[self tag_index:(int)sender.tag];
    NSLog(@"删除了了第%@商城中的第%@件商品",senderary[0],senderary[1]);
    NSArray *arraykey=[[NSArray alloc]init];
    arraykey=[dataDiction allKeys];
    int index_s=[senderary[0]intValue];
    int index_c=[senderary[1]intValue];
    NSArray  *countAry=[dataDiction objectForKey:arraykey[index_s]];
    int idstr=[countAry[index_c][@"id"]intValue];
    if (countAry.count==2) {
        [dataDiction removeObjectForKey:arraykey[index_s]];
    }else {
        [[dataDiction objectForKey:arraykey[index_s]] removeObjectAtIndex:index_c];
    }
    [self.tableView1 reloadData];
    [self loadDeleData:idstr];
}

//添加或减少某条商品的数量
-(void)countLab:(NSArray*)array  :(NSString *)type
{
    NSArray *arraykey=[[NSArray alloc]init];
    arraykey=[dataDiction allKeys];
    int index_s=[array[0]intValue];
    int index_c=[array[1]intValue];
    int integral=[[dataDiction objectForKey:arraykey[index_s]][index_c][@"cartnum"]intValue];
    
    if ([type isEqualToString:@"1"]) {
        [dataDiction objectForKey:arraykey[index_s]][index_c][@"cartnum"]=[NSString stringWithFormat:@"%d",integral+1];
    }else if (integral>1) {
        [dataDiction objectForKey:arraykey[index_s]][index_c][@"cartnum"]=[NSString stringWithFormat:@"%d",integral-1];
    }
    [self cell_sention];
}

//处理获取到的数据
-(NSMutableDictionary*)chuliAry:(NSMutableArray*)mAry
{
    NSMutableDictionary *dataDic=[[NSMutableDictionary alloc]init];
    for (NSDictionary *dic in mAry) {
        NSMutableDictionary    *diction=[dic mutableCopy];
        NSString *str1=[Util isNil:dic[@"mall_name"]];
        [diction setObject:@"0" forKey:@"isXZ"];
        NSArray *itemAry=dataDic[str1];
        if (itemAry==nil) {
            NSMutableArray *itemmuAry=[[NSMutableArray alloc]init];
            NSString *isXZ=@"0";
            [itemmuAry addObject:isXZ];
            [itemmuAry addObject:diction];
            [dataDic setObject:itemmuAry forKey:str1];

        }else {
            [dataDic[str1] addObject:diction];
        }
    }
    return dataDic;
}
//处理点击事件的tag
-(NSArray*)tag_index:(int)index_tag
{
    int sention_index    = index_tag/100;
    int cell_index       = index_tag%100;
    NSString *sender_str = [NSString stringWithFormat:@"%d",sention_index];
    NSString *cell_str   = [NSString stringWithFormat:@"%d",cell_index];
    NSArray *senderary   = [[NSArray alloc]initWithObjects:sender_str,cell_str,nil];
    return senderary;
}

-(void)colorLab:(UILabel *)lab :(NSString*)str1 :(NSString *)str2
{
    int  str1_l   =(int)str1.length;
    int  str2_l   =(int)str2.length;
    NSString    *labText =[NSString stringWithFormat:@"%@%@",str1,str2];
    lab.text             =labText;
    lab.attributedText = [Util getAttrColor:lab.text begin:str1_l end:str2_l color:[UIColor redColor]];
}


//没有数据的时候显示的View
-(void)initnilView
{
    nilView1=[[UIView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT)];
    nilView1.backgroundColor=UIColorFromRGB(0xf4f4f4);
    UIImageView *nilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH/2-M_WIDTH(45),M_WIDTH(101), M_WIDTH(90), M_WIDTH(90))];
    [nilImgView setImage:[UIImage imageNamed:@"shopping_cart"]];
    [nilView1 addSubview:nilImgView];
    
    UILabel *lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(nilImgView.frame)+M_WIDTH(14), WIN_WIDTH, M_WIDTH(17))];
    lab1.font=DESC_FONT;
    lab1.textAlignment=NSTextAlignmentCenter;
    lab1.textColor=COLOR_FONT_SECOND;
    lab1.text=@"这里都是空空的";
    [nilView1 addSubview:lab1];
    
    UILabel *lab2=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(lab1.frame),WIN_WIDTH,M_WIDTH(17))];
    lab2.font=DESC_FONT;
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2.textColor=COLOR_FONT_SECOND;
    lab2.text=@"快去挑选合适的商品吧!";
    [nilView1 addSubview:lab2];
    
    UIButton *btn1=[[UIButton alloc]initWithFrame:CGRectMake((WIN_WIDTH-M_WIDTH(87))/2,CGRectGetMaxY(lab2.frame)+M_WIDTH(22),M_WIDTH(87), M_WIDTH(32))];
    [btn1 setTitle:@"去逛逛" forState:UIControlStateNormal];
    [btn1 setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
    btn1.layer.masksToBounds=YES;
    btn1.layer.cornerRadius=5;
    btn1.layer.borderColor=APP_BTN_COLOR.CGColor;
    btn1.layer.borderWidth=2;
    btn1.titleLabel.font=DESC_FONT;
    [btn1 addTarget:self action:@selector(guangguangTouch) forControlEvents:UIControlEventTouchUpInside];
    [nilView1 addSubview:btn1];
    [self.view addSubview:nilView1];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)guangguangTouch
{
    
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
