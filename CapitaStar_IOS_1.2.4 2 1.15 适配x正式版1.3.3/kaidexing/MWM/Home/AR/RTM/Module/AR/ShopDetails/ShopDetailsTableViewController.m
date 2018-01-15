//
//  ShopDetailsTableViewController.m
//  CapitaLand
//
//  Created by wang jinchang on 2017/10/17.
//  Copyright © 2017年 北京智慧图科技有限责任公司. All rights reserved.
//

#import "ShopDetailsTableViewController.h"
#import "UtilityStyle.h"
#import "ADScroll.h"
#import "MCTopAligningLabel.h"
#import "UIImageView+WebCache.h"
#import "RTMARRequest.h"

@interface ShopDetailsTableViewController ()<UITableViewDelegate,UITableViewDataSource,ADScrollDataSource,ADScrollDelegate>
{
    NSMutableArray *_scaleArray;
}
@property (weak, nonatomic) IBOutlet ADScroll *showShopDetailsView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet MCTopAligningLabel *shopDetailsLable;
@property (weak, nonatomic) IBOutlet UILabel *shopLocationLable;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLable;

@property (nonatomic,strong) NSMutableDictionary *poiDetailsDic;
@property (nonatomic,strong) NSArray *imagesArray;

@end

@implementation ShopDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //修改返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    _scaleArray = [NSMutableArray arrayWithArray:@[[NSMutableArray arrayWithArray:@[@0,@0,@0,@0,@0,@0]]]];
    [self getPoiDetails];
}
- (void)backButtonAction:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getPoiDetails {

    NSDictionary * param = @{@"key":@"JYRhO8qotr",@"buildid":self.poi.buildingID,@"floor":self.poi.floorID,@"poi_no":_poi.pid};
    [RTMARRequest POSTWithParameters:param AndRequestPolicy:RequestShopDetails AndBlock:^(id result, NSError *error) {
        if([[[result objectForKey:@"result"] objectForKey:@"error_code"] integerValue]==0){
            NSLog(@"%@",result);
            self.poiDetailsDic = [result objectForKey:@"poiinfo"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self shopDetailFillData];
            });
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该店铺详情暂未收录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}


- (void) shopDetailFillData {
    self.shopDetailsLable.text = [self.poiDetailsDic objectForKey:@"poi_descript"];
    self.iphoneLable.text = [self.poiDetailsDic objectForKey:@"phone_number"];
    self.shopLocationLable.text = [self.poiDetailsDic objectForKey:@"poi_address"];
    
    
    
// 需要使用SDWebImageView加载图片
    [self.logoImageView setImageWithURL:[NSURL URLWithString:self.poiDetailsDic[@"poi_logo"]] placeholderImage:[UIImage imageNamed:@"normal"]];
    
    
    
    self.imagesArray = [self.poiDetailsDic[@"poi_image"] componentsSeparatedByString:@";"];
   
    self.showShopDetailsView.delegate = self;
    self.showShopDetailsView.dateSource = self;
    
    if(self.poiDetailsDic.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该店铺详情暂未收录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(UIView *)ADScroll:(ADScroll *)scrollView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        CGRect frame = scrollView.bounds;
        view = [[UIImageView alloc] initWithFrame:frame];
    }
    
    UIImageView * imageView = (UIImageView *) view;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imageString;
    if(self.imagesArray.count==0){
        imageString = @"";
    }else {
        imageString = self.imagesArray[index];
    }
    
    
    
// 需要使用SDWebImageView加载图片
    [imageView setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"normal"]];
    
    return view;
}

-(NSInteger)numberOfItemsInADScroll:(ADScroll *)scrollView
{
    return [self.imagesArray count]==0?1:[self.imagesArray count];
}

-(void)adScroll:(ADScroll *)scrollView selectedIndex:(NSInteger)index
{
    //NSLog(@"选择的是第%@张图片",@(index));
}


- (NSMutableDictionary*) poiDetailsDic {
    if(!_poiDetailsDic){
        _poiDetailsDic = [[NSMutableDictionary alloc] init];
    }
    return _poiDetailsDic;
}

- (NSArray*) imagesArray {
    if(!_imagesArray){
        _imagesArray = [[NSArray alloc] init];
    }
    return _imagesArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

// 用户点击了去这里按钮
- (IBAction)touchGoHereBtn:(id)sender {
    if([self.delegate respondsToSelector:@selector(userTouchGoHere:)]){
        [self.delegate userTouchGoHere:self.poi];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//用户点击了拨打电话按钮
- (IBAction)touchIphoneBtn:(id)sender {
    if(self.iphoneLable.text.length){
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.iphoneLable.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该店铺详情暂未收录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([_scaleArray[indexPath.section][indexPath.row] integerValue] == 0) {
        for (UIView * view in cell.contentView.subviews)
        {
            [UtilityStyle scaleUIView:view FromDesignModel:@"iPhone6"];
            for (UIView * subView in view.subviews)
            {
                [UtilityStyle scaleUIView:subView FromDesignModel:@"iPhone6"];
            }
        }
        [_scaleArray[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:@1];
    }
}



- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.showShopDetailsView.delegate = nil;
    self.showShopDetailsView.dateSource = nil;
}

@end
