//
//  AddressListViewController.m
//  kaidexing
//
//  Created by dwolf on 2017/6/8.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "AddressListViewController.h"
#import "ReTableView.h"
#import "AddrListCell.h"
#import "AddressVM.h"
#import "EditeAddrViewController.h"
#import "UnionSelectActionSheetPicker.h"

@interface AddressListViewController ()
@property (strong,nonatomic)ReTableView         *tableView;
@end

@implementation AddressListViewController{
    AddressVM* addressVM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    addressVM = [[AddressVM alloc] init];
    //加载数据
    [SVProgressHUD showWithStatus:@"数据加载中"];
    
    [self configVMMsg];
        self.navigationBarTitleLabel.text=@"管理收货地址";
    self.tableView.scrollEnabled=YES;
    [self initbuttomView];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [addressVM loadData];
    if ([self.delegate.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.delegate.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

//设置事件
-(void) configVMMsg{
    [[addressVM.successObject filter:^BOOL(id value){
        return [value intValue] == 0;
    }]
     subscribeNext:^(id data) {
         [SVProgressHUD dismiss];
         [_tableView reloadData];
         [_tableView tableViewDidFinishedLoading];
     }];
    
    //更新默认成功
    [[addressVM.successObject filter:^BOOL(id value){
        return [value intValue] == 1;
    }]
     subscribeNext:^(id data) {
         [addressVM loadData];
     }];
    
    //删除成功
    [[addressVM.successObject filter:^BOOL(id value){
        return [value intValue] == 3;
    }]
     subscribeNext:^(id data) {
//         [self showMsg:@"地址删除成功" afterOK:^{
//             [addressVM loadData];
//         }];
         [addressVM loadData];
         
     }];
    
    [addressVM.errorObject subscribeNext:^(id x) {
        [self showMsg:x];
        [_tableView tableViewDidFinishedLoading];
        [SVProgressHUD dismiss];
    } ];

}


-(void)tableView_refresh:(NSString *)type{
    if([type isEqualToString:MORE_METHOD]){
        [addressVM loadMore];
    }else{
        [addressVM loadData];
    }
    
}


-(UITableView*)tableView
{
    if (!_tableView) {
        self.tableView=[[ReTableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT-M_WIDTH(55)) style:UITableViewStylePlain];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.refreshTVDelegate=self;
        self.tableView.backgroundColor=UIColorFromRGB(0xf4f4f4);
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

-(void)initbuttomView
{
    UIButton *shouhuoBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(10),WIN_HEIGHT-M_WIDTH(45), WIN_WIDTH-M_WIDTH(20),M_WIDTH(35))];
    [shouhuoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shouhuoBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    shouhuoBtn.backgroundColor=APP_BTN_COLOR;
    shouhuoBtn.layer.masksToBounds=YES;
    shouhuoBtn.layer.cornerRadius=5;
    [shouhuoBtn addTarget:self action:@selector(addTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shouhuoBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [addressVM tableRowCount];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [addressVM tableSection];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellName = @"AddrListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell==nil) {
        //如何让创建的cell加个戳
        //对于加载的xib文件，可以到xib视图的属性选择器中进行设置
        cell=[[[NSBundle mainBundle]loadNibNamed:CellName owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AddressModel* model = addressVM.tableData[indexPath.row];
    AddrListCell* addressCell = (AddrListCell*) cell;
    addressCell.nameLabel.text = model.name;
    addressCell.phoneLabel.text = model.telephone;
    addressCell.addrLabel.text = model.address;
    if([model.isDefault intValue] == 1){
        addressCell.noDefaultImgView.hidden = YES;
        addressCell.defaultImgView.hidden = NO;
        addressCell.defaultLabel.hidden = NO;
        addressCell.nameLeadConst.constant = 44;
    }else{
        addressCell.noDefaultImgView.hidden = NO;
        addressCell.defaultImgView.hidden = YES;
        addressCell.defaultLabel.hidden = YES;
        addressCell.nameLeadConst.constant = 10;
    }
    
    //事件绑定
    {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUpdateDefault:)];
        [addressCell.defaultImgView addGestureRecognizer:tap] ;
        addressCell.defaultImgView.tag = indexPath.row;
    }
    {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUpdateDefault:)];
        [addressCell.noDefaultImgView addGestureRecognizer:tap] ;
        addressCell.noDefaultImgView.tag = indexPath.row;
    }
    {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEditTap:)];
        [addressCell.editImgView addGestureRecognizer:tap] ;
        addressCell.editImgView.tag = indexPath.row;
    }
    {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDeleteTap:)];
        [addressCell.delImgView addGestureRecognizer:tap] ;
        addressCell.delImgView.tag = indexPath.row;
    }
    
    return cell;
}

//设置为默认事件
-(void) onUpdateDefault:(UITapGestureRecognizer*) tap{
    int tag = [tap view].tag;
    AddressModel* model = addressVM.tableData[tag];
    model.isDefault = [model.isDefault intValue] == 0 ? @"1" :@"0";
    [addressVM updateAddress:tag];
}

//编辑事件
-(void) onEditTap:(UITapGestureRecognizer*) tap{
    int tag = [tap view].tag;
    AddressModel* model = addressVM.tableData[tag];
    EditeAddrViewController* vc = [[EditeAddrViewController alloc] init];
    vc.model = model;
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

//删除事件
-(void) onDeleteTap:(UITapGestureRecognizer*) tap{
    [self confirm:@"确定删除？" okBtnTitle:@"确定" afterOK:^{
        int tag = [tap view].tag;
        AddressModel* model = addressVM.tableData[tag];
        [addressVM deleteAddress:model];
    }afterCancel:^{
        
    }];
   
}

//新增地址
-(void)addTouch{
    EditeAddrViewController* vc = [[EditeAddrViewController alloc] init];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
