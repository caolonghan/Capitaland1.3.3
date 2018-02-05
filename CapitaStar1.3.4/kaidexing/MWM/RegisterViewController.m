//
//  RegisterViewController.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/3.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "RegisterViewController.h"

#import "RegisterTHView.h"

@interface RegisterViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView * registerTV;
    
    BOOL isSelected[2];
    
    CGFloat rowHeight;
    RegisterTHView * tableHView;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarTitleLabel.text= @"注册";
    if (IS_IOS_7) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    registerTV = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
    registerTV.dataSource = self;
    registerTV.delegate = self;
    registerTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableHView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterTHView" owner:nil options:nil] lastObject];
    tableHView.typestr=_types;
    tableHView.viewController = self;
    
    //registerTV.tableHeaderView = tableHView;
    
    [self.view addSubview:registerTV];
    
    self.keyboardContainer = registerTV;
}

-(void) viewWillAppear:(BOOL)animated{
    registerTV.frame = CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT);
    [super viewWillAppear:animated];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section  == 0){
        return 346;
    }else{
       return 40;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return tableHView;
    }
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 40)];
    view.backgroundColor = UIColorFromRGB(0xf3f4f6);
    
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, (40-20)/2, 20, 20)];
    
    [view addSubview:imgV];
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, 120, 40)];
    label.font = DESC_FONT;
    label.textColor = COLOR_FONT_SECOND;
    if (section == 1) {
        
        label.text = @"什么是凯德星?";
        imgV.image =[UIImage imageNamed:@"wk"];
    } else {
        label.text = @"会员权益";
        imgV.image =[UIImage imageNamed:@"hyqy"];
    }
    
    [view addSubview:label];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(WIN_WIDTH-16-15, (40-15)/2, 15, 15);
    if(isSelected[section]){
        [button setImage:[UIImage imageNamed:@"down_zc"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    }

    
    [view addSubview:button];
    
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(48, 39, WIN_WIDTH - 48 - 16, 1)];
    view1.backgroundColor = UIColorFromRGB(0xdadada);
    
    [view addSubview:view1];
    
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail:)];
    view.tag = section + 100;
    [view addGestureRecognizer:tap];
    return view;
}

- (void)showDetail:(UITapGestureRecognizer *)tap {
    UIView* view = tap.view;
        isSelected[view.tag-100] = !isSelected[view.tag-100];
    
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:view.tag-100];
    
    [registerTV reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 0;
    }
    if (isSelected[section]) {
        
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return 80;
    }
    return 133;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"RegisterTVCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = DESC_FONT;
        cell.textLabel.textColor = COLOR_FONT_SECOND;
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = UIColorFromRGB(0xf3f4f6);
    }
    cell.imageView.image = [UIImage imageNamed:@""];
    
    if (indexPath.section == 1) {
        
        cell.textLabel.text = @"凯德购物星是凯德集团所推出的无卡式消费积分奖励计划，一旦您在凯德星中注册成为会员在凯德星集团旗下商场、服务公寓、或指定合作方消费，不仅可以享有商场店家提供的各项优惠，还有累积积分。";
    } else {
        cell.textLabel.text = @"消费换取积分，成为凯德星会员，即享有凯德星积分。您可以在全国各地凯德商场，服务公寓轻松累积并使用凯德积分。\n积分兑换好礼：使用积分兑换成现金(指定商场)、精美赠品或服务公寓住宿券等。\n优先优惠权利：消费者加入会员制后可以享有优先消费，以及一定的商业促销优惠和消费折扣等价格优惠及我们不定期推出的活动特权！";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [tableHView.phoneNumTF resignFirstResponder];
    [tableHView.msgVCTF resignFirstResponder];
    [tableHView.setPswdTF resignFirstResponder];
    [tableHView.confirmPwTF resignFirstResponder];
    
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
