//
//  InfoListViewController.m
//  kaidexing
//
//  Created by dwolf on 2017/5/15.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "InfoListViewController.h"
#import "InfoVM.h"
#import "ReTableView.h"
#import "GoViewController.h"


@interface InfoListViewController ()
@property (nonatomic, strong) ReTableView *tableView;
@end

#define titleHieght M_WIDTH(24)
#define infoView_H M_WIDTH(167)
#define botomHight M_WIDTH(24)

@implementation InfoListViewController{
    InfoVM* infoVm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"白领课堂";
    [self.view addSubview:[self tableView]];
    infoVm = [[InfoVM alloc] init];
    //加载数据
    [SVProgressHUD showWithStatus:@"数据加载中"];
    [infoVm getConsultList:REFRESH_METHOD];
    [infoVm.successObject subscribeNext:^(id data) {
        [SVProgressHUD dismiss];
        [_tableView reloadData];
        [_tableView tableViewDidFinishedLoading];
    }];
    [infoVm.errorObject subscribeNext:^(id x) {
        [_tableView tableViewDidFinishedLoading];
        [SVProgressHUD dismiss];
    } ];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.view.backgroundColor = COLOR_ITEM_BG;
}

//响应刷新
-(void)tableView_refresh:(NSString*)type{
    [infoVm getConsultList:type];
}

//初始化tableview
-(ReTableView*) tableView{
    if(_tableView == nil){
        _tableView = [[ReTableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT - NAV_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshTVDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = COLOR_LINE;

    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [infoVm getInfoModeList].count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return titleHieght+infoView_H+botomHight + 8;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"InfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    [UIUtil removeSubView:cell];
    UIView* view = [self createHuoDongView:[infoVm getInfoModeList][indexPath.row]];
    [cell addSubview:view];
    return cell;
}

//对每个模块的顶部文字作处理@"积分商品"
-(void)chulititleLab:(UILabel*)lab text:(NSString*)text{
    lab.text=text;
    [lab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.textColor=APP_BTN_COLOR;
}

//创建活动单元视图
-(UIView*) createHuoDongView:(InfoModel*) model{
    
    UIView* infoView =  [[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,titleHieght+infoView_H+botomHight + 8)];
    infoView.backgroundColor=[UIColor clearColor];
    
    UIView* containView =[[UIView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,titleHieght+infoView_H+botomHight )];
    containView.backgroundColor=[UIColor whiteColor];
    
    
    UILabel *titleLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),0,WIN_WIDTH/2,titleHieght)];
    [self chulititleLab:titleLab text:model.sub_title];
    titleLab.font = DESC_FONT;
    [containView addSubview:titleLab];
    
    @try {
        UILabel *timeLabel= [[UILabel alloc]initWithFrame:CGRectMake(WIN_WIDTH/2,0,WIN_WIDTH/2 - M_WIDTH(11),titleHieght)];
        NSDate* time = [DateUtil dateFromstring:model.create_time format:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        [self chulititleLab:timeLabel text:[DateUtil compareCurrentTime: time]];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = SMALL_FONT;
        [containView addSubview:timeLabel];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.frame = CGRectMake(0, titleHieght, WIN_WIDTH, infoView_H);
    [imgView setImageWithString:model.img_url];
    
    [containView addSubview:imgView];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    imgView.clipsToBounds = YES;
    UILabel *bottomLab= [[UILabel alloc]initWithFrame:CGRectMake(M_WIDTH(14),CGRectGetMaxY(imgView.frame),WIN_WIDTH,botomHight)];
    bottomLab.text = model.title;
    bottomLab.font = INFO_FONT;
    bottomLab.textColor = COLOR_FONT_BLACK;
    [containView addSubview:bottomLab];
    
    [infoView addSubview:containView];
    return infoView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoViewController * vc = [[GoViewController alloc] init];
    vc.path = [infoVm getInfoModeList][indexPath.row].link_url;
    [self.navigationController pushViewController:vc animated:YES];
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
