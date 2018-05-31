//
//  TextSearchController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/26.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "TextSearchController.h"
#import "PullingRefreshTableView.h"
#import "GoViewController.h"
#import "KDSearchBar.h"
@interface TextSearchController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>

@property (strong,nonatomic)KDSearchBar     *homeTextF;

@end

@implementation TextSearchController
{
    @private
    UIView                      *nvcView1;
    NSInteger                   _page;
    NSMutableArray              *dataAry;
    NSMutableArray              *urlAry;
    BOOL noMore;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self initNvc];
}


-(void)initNvc{
    nvcView1=[[UIView alloc]initWithFrame:CGRectMake(40, STATUS_BAR_HEIGHT + 6, WIN_WIDTH-65, 32)];
    nvcView1.backgroundColor=[UIColor clearColor];
    nvcView1.layer.masksToBounds=YES;
    nvcView1.layer.cornerRadius=5;
    
    self.homeTextF=[[KDSearchBar alloc]initWithFrame:nvcView1.bounds];
    self.homeTextF.newFrame = self.homeTextF.frame;
    self.homeTextF.placeholder=@"请输入要搜索的商户";
    self.homeTextF.delegate=self;
    self.homeTextF.searchBarStyle=UISearchBarStyleMinimal;
    self.homeTextF.keyboardType=UIKeyboardAppearanceDefault;
    self.homeTextF.returnKeyType=UIReturnKeySearch;
    
    [nvcView1 addSubview:self.homeTextF];
    [self.navigationBar addSubview:nvcView1];
    
}

-(void)inittableView{
    self.tableView1=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH,_tableview_H) pullingDelegate:self];
    self.tableView1.dataSource=self;
    self.tableView1.delegate  =self;
    self.tableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView1.scrollEnabled=YES;
    [self.view addSubview:self.tableView1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    self.view.backgroundColor=[UIColor whiteColor];
    dataAry=[[NSMutableArray alloc]init];
    urlAry =[[NSMutableArray alloc]init];
    [self inittableView];
    
}



#pragma mark ---请求网络---
-(void)NetWorkRequest:(NSString*)type
{
    NSDictionary*diction;
    [SVProgressHUD showWithStatus:@"正在努力加载中"];
    if(type == nil || [type isEqualToString:REFRESH_METHOD]){
        _page = 1;
    }else{
        _page ++;
    }
//    if ([Util isNull:_textFStr]) {
//    }else{
//        self.homeTextF.text=_textFStr;
//        _textFStr=nil;
//    }
//    NSString  *textStr=self.homeTextF.text;
    NSString  *textStr=_textFStr;
    
    
    NSString  *path;
    if ([_typrStr isEqualToString:@"1"]) {
        
        int zz=[[Global sharedClient].markID intValue];
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"mall_id",@(0),@"Floor",@"0",@"Type",@"0",@"sort",@(_page),@"Page",@"10",@"pageSize",textStr,@"Key", nil];
        path=[Util makeRequestUrl:@"mallshoplist" tp:@"loadshoplist"];
    
    }else {
        int zz;
        NSUserDefaults *cityNSU=[NSUserDefaults standardUserDefaults];
        if ([cityNSU valueForKey:@"city"]==nil) {
            zz=1;
        }else{
            zz=[[cityNSU valueForKey:@"city"] intValue];
        }
        diction=[[NSDictionary alloc]initWithObjectsAndKeys:@(zz),@"city",@"0",@"Type",@"0",@"sort",@(_page),@"Page",@"10",@"pageSize",textStr,@"Key", nil];
        path=[Util makeRequestUrl:@"mallshoplist" tp:@"nomallloadshop"] ;
    }

    [HttpClient requestWithMethod:@"POST" path:path parameters:diction  target:self success:^(NSDictionary *dic){
        dispatch_async(dispatch_get_main_queue(), ^{
            if([dic[@"data"] isKindOfClass:[NSDictionary class]])
            {
                if(type == nil || [type isEqualToString:REFRESH_METHOD]){
                    [dataAry removeAllObjects];
                    [urlAry  removeAllObjects];
                    noMore = NO;
                }
                NSArray  *array=dic[@"data"][@"shoplist"];
                for (NSDictionary *dict in array) {
                    NSString *name=[Util isNil:dict[@"shop_name"]];
                    NSString *urlS=[NSString stringWithFormat:@"%@",[Util isNil:dict[@"shopdetail_url"]]];
                    [dataAry addObject:name];
                    [urlAry  addObject:urlS];
                }
                if(![dic[@"data"][@"isend"] isEqualToString:@"false"]){
                    noMore = true;
                }
                
                [self.tableView1 reloadData];
            }else {
                NSLog(@"%@",dic[@"data"]);
                
            }
            [self.tableView1 tableViewDidFinishedLoading];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
        
    }];
}

-(void)refreshInterface
{
    [self NetWorkRequest:nil];
    
}


#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(NetWorkRequest:) withObject:REFRESH_METHOD afterDelay:0.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [[NSDate alloc] init];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    if (noMore) {
        [tableView tableViewDidFinishedLoading];
        return;
    }
    [self performSelector:@selector(NetWorkRequest:) withObject:MORE_METHOD afterDelay:0.f];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    [self.homeTextF resignFirstResponder];
    [self.tableView1 tableViewDidScroll:vScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
    [self.tableView1 tableViewDidEndDragging:vScrollView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  count;
    if ([Util isNull:dataAry]) {
        count=0;
    }else{
        count=dataAry.count;
    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier=@"cellID3";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    UIView *deleView=[cell viewWithTag:1000];
    [deleView removeFromSuperview];
    
    UILabel *nameLab=[[UILabel alloc]initWithFrame:CGRectMake(14, 13, 280, 17)];
    if ([Util isNull:dataAry]) {
    }else{
    nameLab.text=dataAry[indexPath.row];
    }
    nameLab.textAlignment=NSTextAlignmentLeft;
    nameLab.font=DESC_FONT;
    nameLab.tag=1000;
    
    UIView  *lineVIew=[[UIView alloc]initWithFrame:CGRectMake(14, 41, WIN_WIDTH-14, 1)];
    lineVIew.backgroundColor=COLOR_LINE;
    
    [cell addSubview:nameLab];
    [cell addSubview:lineVIew];
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url=urlAry[indexPath.row];
    if (_textdelegate &&[_textdelegate respondsToSelector:@selector(settexthidden:)]) {
        [_textdelegate settexthidden:url];
    }
}

//输入框点击return
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self.homeTextF resignFirstResponder];
//}
////搜索内容改变的时候，在这个方法里面实现实时显示结果
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [self NetWorkRequest:nil];
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [nvcView1 removeFromSuperview];
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
