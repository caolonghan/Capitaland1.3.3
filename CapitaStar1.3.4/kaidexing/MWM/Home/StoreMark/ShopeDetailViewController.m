//
//  ShopeDetailViewController.m
//  kaidexing
//
//  Created by dwolf on 16/5/19.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ShopeDetailViewController.h"
#import "SaleTableViewCell.h"
#import "DpCollectionViewCell.h"

#define HD_TITLE_HEGIHT 40
#define DP_ITEM_HEGIHT 184

@interface ShopeDetailViewController ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation ShopeDetailViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBarTitleLabel.text= @"商户详情";
    _huoDongTabelView.delegate = self;
    _huoDongTabelView.dataSource = self;
    
    _dpCololectView.delegate = self;
    _dpCololectView.dataSource = self;
    [self.dpCololectView registerClass:[DpCollectionViewCell class] forCellWithReuseIdentifier:@"DpCollectionViewCell"];
    
    [self drawView];
    [self initHeadView];
    
    [self hideShopIntr];
    [self resize];
}

-(void) resize{
     _hdHeightConst.constant = HD_TITLE_HEGIHT + 160 ;
    _dpHeightConst.constant = ceil(7/2.0)*DP_ITEM_HEGIHT;
    [self.view layoutIfNeeded];
}

-(void) hideShopIntr{
    _shopeInrView.hidden = YES;
    _shopIntroHeightConst.constant = 0;
    _webView.hidden = YES;
    _webViewHeightConst.constant = 0;
    _shop2hdConst.constant = 0;
}

-(void) hideDP{
    _dpView.hidden = YES;
    _dpCololectView.hidden = YES;
    _dpHeightConst.constant = 0;
}


-(void) drawView{
    _nameLabel.text = @"LV";
    _tmImg.image = [UIImage imageNamed:@"wellcom-2"];
    _tmImg.clipsToBounds = YES;
    _tmImg.contentMode = UIViewContentModeScaleAspectFill;
    _tmImg.layer.borderWidth = 1;
    _tmImg.layer.borderColor = COLOR_LINE.CGColor;
    
    _phoneLabel.text = @"021-87448888";
    _locLabel.text = @"B2/#B249";
    
    if ([_huoDongTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_huoDongTabelView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_huoDongTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_huoDongTabelView setLayoutMargins:UIEdgeInsetsZero];
        
    }
}


//轮播图
-(void)initHeadView{
    
    ImageScrollView* pageView = [[ImageScrollView alloc] initWithFrame:_advView.bounds];
    pageView.pics=@[@"https://file.companycn.net/webupload/19-1/Merchant/images/201507/201507132005197226.jpg",
                    @"https://file.companycn.net/webupload/19-1/Merchant/images/201507/201507132032026318.JPG"];
    pageView.pageColor=[UIColor whiteColor];
    pageView.pageSelColor=[UIColor grayColor];
    
    [pageView returnIndex:^(NSInteger index){
        
        NSLog(@"点击了第%zi张", index);
        
    }];
    [pageView reloadView];
    [_advView addSubview:pageView];
}


//以下为tableVIEW 需要实现的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return HD_TITLE_HEGIHT;
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"hdTitleCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier]; ;
        
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, HD_TITLE_HEGIHT)];
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_FRAME.size.width - 10, HD_TITLE_HEGIHT)];
            titleLabel.text = @"最新活动";
            titleLabel.font = COMMON_FONT;
            titleLabel.textColor = COLOR_FONT_BLACK;
            [titleView addSubview:titleLabel];
            [cell addSubview:titleView];
        }
        return cell;
    }else{
        static NSString *HDCellName = @"SaleTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDCellName];
        
        if (cell==nil) {
            //如何让创建的cell加个戳
            //对于加载的xib文件，可以到xib视图的属性选择器中进行设置
            cell=[[[NSBundle mainBundle]loadNibNamed:HDCellName owner:nil options:nil]firstObject];
        }
        SaleTableViewCell* saleCell  = (SaleTableViewCell*)cell;
        
        NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"LV满dfgdgdd1万sadfsfsafddfgdgs减1万"];

        if(true){
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];

            // 表情图片
            attch.image = [UIImage imageNamed:@"juan"];
            // 设置图片大小
            attch.bounds = CGRectMake(4, -2, saleCell.nameLabel.frame.size.height - 4 , saleCell.nameLabel.frame.size.height - 4);
            
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri appendAttributedString:string];
        }
        if(true){
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"cu"];
            // 设置图片大小
            attch.bounds = CGRectMake(8, -2, saleCell.nameLabel.frame.size.height - 4 , saleCell.nameLabel.frame.size.height - 4);
            
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:[attri length]];
            //[attri appendAttributedString:string];
        }
        //以下代码为了控制图片显示不全的问题
        {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@""];
            // 设置图片大小
            attch.bounds = CGRectMake(8, -2, saleCell.nameLabel.frame.size.height - 4 , saleCell.nameLabel.frame.size.height - 4);
            
            // 创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:[attri length]];
        }
        
        // 用label的attributedText属性来使用富文本
        saleCell.nameLabel.attributedText = attri;
        [saleCell.nameLabel sizeToFit];
        
        saleCell.timeLabel.text = @"2015.08.01~2016.10.10";
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

//以下是CollectView协议
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"collectView   count");
    return 7;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"DpCollectionViewCell";
    DpCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
   
    cell.imgView.image = [UIImage imageNamed:@"wellcom-1"];
    cell.nameLabel.text = @"img_02";
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(147, 184);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
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
