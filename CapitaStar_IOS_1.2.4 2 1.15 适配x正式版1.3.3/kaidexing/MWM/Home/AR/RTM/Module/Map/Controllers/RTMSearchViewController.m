//
//  RTMSearchViewController.m
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import "RTMSearchViewController.h"

#import "RTLbs3DWebService.h"
#import "RTMPoiSectionHeaderView.h"
#import "RTMPoiCell.h"
#import "RTMPoiGroupCell.h"
#import "RTMSearchClassifyCell.h"
#import "RTMSearchClassifyTypeCell.h"
#import "RTMHistoryClearCell.h"
#import "RTMPoiHistoryCell.h"
#import "RTLbs3DPOIMessageClass.h"
#import "RTMARRequest.h"
#import "UIColor+RTM.h"

typedef NS_ENUM(NSUInteger, RTMSearchResultDisplayType) {
    RTMSearchResultDisplayTypeNone,
    RTMSearchResultDisplayTypePlain,
    RTMSearchResultDisplayTypeGroup,
};

@interface RTMSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RTLbs3DWebServiceDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchBar;
@property (nonatomic, weak) IBOutlet UITableView * resultTableView;
@property (weak, nonatomic) IBOutlet UITableView *resultGroupTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *classifyCollectionView;
@property (weak, nonatomic) IBOutlet UIView *navigationToolsView;
@property (nonatomic, weak) IBOutlet UITextField * searchTextField;
@property (nonatomic, strong) NSArray * resultsArr;
@property (nonatomic, strong) NSDictionary * resultsGroupDict;
@property (nonatomic, strong) NSArray * floorIndexs;

//地图信息查询服务
@property (nonatomic, strong) RTLbs3DWebService * mapService;
@property (nonatomic, strong) NSMutableArray * classifyArr;
@property (nonatomic, assign) RTMSearchResultDisplayType searchResultDisplayType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultTableViewTopConstraint;
@end

@implementation RTMSearchViewController
#pragma mark - 重写属性getter方法，成员变量初始化放入getter方法中
- (RTLbs3DWebService *)mapService{
    if (!_mapService) {
        _mapService = [[RTLbs3DWebService alloc] init];
        _mapService.delegate = self;
        _mapService.serverUrl = @"http://lbsapi.rtmap.com";
    }
    return _mapService;
}
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchResultDisplayType = RTMSearchResultDisplayTypePlain;
    if (self.changeStartOrEndPoi) {
        self.navigationToolsView.hidden = NO;
        self.resultGroupTableView.hidden = YES;
        self.resultTableView.hidden = NO;
        self.classifyCollectionView.hidden = YES;
        
        [NSLayoutConstraint deactivateConstraints:@[self.resultTableViewTopConstraint]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.resultTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navigationToolsView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }else{
        [self requestClassify];
        
        self.navigationToolsView.hidden = YES;
        self.resultGroupTableView.hidden = YES;
        self.classifyCollectionView.hidden = NO;
        UICollectionViewFlowLayout * collectionViewLayout = (UICollectionViewFlowLayout *)self.classifyCollectionView.collectionViewLayout;
        
        CGFloat classifyCellWidth = (CGRectGetWidth(self.classifyCollectionView.frame) - 20)/5.f;
        collectionViewLayout.itemSize = CGSizeMake(classifyCellWidth, classifyCellWidth*8/7.f);
    }
    
    self.searchBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchBar.layer.shadowOpacity = 1.f;
    self.searchBar.layer.shadowRadius = 3;
    self.searchBar.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), 1)] CGPath];
}

#pragma mark - action
- (IBAction)cancelButtonAction:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)mapSelectPoiAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)locationAction:(UIButton *)sender {
    if (self.handler) {
        self.handler(nil, 1);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationAction:(UIButton *) sender{
    NSInteger section = sender.tag / 100000;
    NSInteger row = sender.tag % 100000;
    NSArray * result = nil;
    
    if (self.searchResultDisplayType == RTMSearchResultDisplayTypePlain) {
        result = @[self.resultsArr[row]];
    }else if (self.searchResultDisplayType == RTMSearchResultDisplayTypeGroup){
        result = @[self.resultsGroupDict[self.floorIndexs[section]][row]];
    }
    
    if (self.changeStartOrEndPoi == RTMPoiSearchTypeNormal && result.count == 1) {
        RTLbs3DPOIMessageClass * poi = result.firstObject;
        [self saveSearchRecord:poi.POI_Name];
        [self sendAppSearchPoiRequest:poi];
    }
    
    if (self.handler) {
        self.handler(result, RTMPoiUsingModeNavigation);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clearHistoryRecordsAction:(UIButton *) sender{
    if (self.classifyArr.count == 3) {
        [self.classifyArr replaceObjectAtIndex:2 withObject:[self clearHistory]];
        [self.classifyCollectionView reloadData];
    }
}
#pragma mark -
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
#pragma mark - 数据请求 处理
- (void)requestClassify{

    NSDictionary * param = @{@"key":@"JYRhO8qotr",@"buildid":self.buildingID};
    [RTMARRequest POSTWithParameters:param AndRequestPolicy:RequestBasicclassification AndBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(result){
            self.classifyArr = [NSMutableArray arrayWithArray:[self sortClassifies:result[@"classification"]]];
            [self.classifyArr addObject:[self getHistory]];
            [self.classifyCollectionView reloadData];
            }
        });
    }];
}
- (void)requestClassifyPOIs:(NSDictionary *) classify{

    NSDictionary * param =@{@"buildid":self.buildingID,
                            @"key":@"JYRhO8qotr",
                            @"pagesize":@"999",
                            @"pageindex":@"1",
                            @"classid":classify[@"id"],
                            @"tag":classify[@"name"]};
    [RTMARRequest POSTWithParameters:param AndRequestPolicy:RequestClassification AndBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          
            if (result) {
                self.resultsGroupDict = [self sortGroupClassify:result[@"poilist"]];
                self.floorIndexs = [self sortFloors:self.resultsGroupDict.allKeys];
                [self.resultGroupTableView reloadData];
            }
        });
    }];
}
- (NSArray *)sortClassifies:(NSArray *) classifies{
    NSMutableArray * common = [NSMutableArray array];
    NSMutableArray * hot = [NSMutableArray array];
    
    for (NSDictionary * classify in classifies) {
        NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:classify];
        NSArray * ids = [tempDict[@"id"] componentsSeparatedByString:@","];
        [tempDict setValue:ids forKey:@"id"];
        NSNumber * type = tempDict[@"type"];
        if ([type isEqualToNumber:@0]) {
            [common addObject:tempDict];
        }else{
            [hot addObject:tempDict];
        }
    }
    
    return @[@{@"公共设施":common},@{@"热点推荐":hot}];
}

- (NSDictionary *)sortGroupClassify:(NSArray *) pois{
    NSMutableDictionary * sortedDict = [NSMutableDictionary dictionary];
    
    for (NSDictionary * poi in pois) {
        NSArray * group = [NSArray arrayWithArray:[sortedDict valueForKey:poi[@"floor"]]];
        RTLbs3DPOIMessageClass * poiObjc = [[RTLbs3DPOIMessageClass alloc] init];
        poiObjc.POI_ID = poi[@"poi_no"];
        poiObjc.POI_Name = poi[@"name"];
        poiObjc.POI_ClassId = poi[@"classid"];
        poiObjc.POI_Floor = poi[@"floor"];
        poiObjc.POI_point = CGPointMake([poi[@"x"] floatValue], [poi[@"y"] floatValue]);
        group = [group arrayByAddingObject:poiObjc];
        [sortedDict setValue:group forKey:poiObjc.POI_Floor];
    }
    
    return sortedDict;
}

- (NSArray *) sortFloors:(NSArray *) floors{
    return [floors sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull floor1, NSString *  _Nonnull floor2) {
        NSString * floor1Prefix = [floor1 substringToIndex:1];
        NSString * floor2Prefix = [floor2 substringToIndex:1];
        if ([floor1Prefix isEqualToString:floor2Prefix]) {
            if ([floor1Prefix isEqualToString:@"F"]) {
                return [floor1 compare:floor2];
            }else{
                return [floor1 compare:floor2];
            }
        }else{
            return -[floor1 compare:floor2];
        }
    }];
}

- (NSDictionary *)saveSearchRecord:(NSString *) recordString{
    NSArray * records = [[NSUserDefaults standardUserDefaults] arrayForKey:@"rtm_records"]?:@[];
    for (NSDictionary * record in records) {
        if ([record[@"name"] isEqualToString:recordString]) {
            return @{@"历史搜索记录":records};
        }
    }
    
    records = [records arrayByAddingObject:@{@"name":recordString}];

    [[NSUserDefaults standardUserDefaults] setObject:records forKey:@"rtm_records"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return @{@"历史搜索记录":records};
}

- (NSDictionary *)getHistory{
    NSArray * records = [[NSUserDefaults standardUserDefaults] arrayForKey:@"rtm_records"];
    if (records.count) {
        return @{@"历史搜索记录":records};
    }
    return @{@"暂无搜索记录":@[]};
}
- (NSDictionary *)clearHistory{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"rtm_records"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return @{@"暂无搜索记录":@[]};
}

- (NSString *)getCurrentTime{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:[NSDate date]];
}
- (NSString *)getIdfv{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (void)sendAppSearchPoiRequest:(RTLbs3DPOIMessageClass *) poi{
    NSDictionary * param = @{
                             @"userid":[self getIdfv],
                             @"burying_Point_key":@"app_search_poi",
                             @"build_id":self.buildingID,
                             @"time":[self getCurrentTime],
                             @"floor":poi.POI_Floor,
                             @"poi_name":poi.POI_Name?:@""
                             };
    NSData * data = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    [self postData:data];
}

- (void)sendAppSearchTagRequest:(NSDictionary *) tag{
    NSDictionary * param = @{
                             @"userid":[self getIdfv],
                             @"burying_Point_key":@"app_search_tag",
                             @"build_id":self.buildingID,
                             @"time":[self getCurrentTime],
                             @"tag":tag[@"name"]
                             };
    NSData * data = [NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    [self postData:data];
}

- (void)postData:(NSData *) data{
    [RTMARRequest POSTWithData:data AndRequestPolicy:RequestBuryingPoint AndBlock:^(id result, NSError *error) {
        
    }];
}
#pragma mark - 搜索结果展示 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.resultGroupTableView) {
        return self.floorIndexs.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.resultGroupTableView) {
        NSArray * rows = self.resultsGroupDict[self.floorIndexs[section]];
        return rows.count;
    }
    return self.resultsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.resultGroupTableView) {
        RTMPoiGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RTMPoiGroupCell"];
        NSArray * group = self.resultsGroupDict[self.floorIndexs[indexPath.section]];
        NSInteger tag = indexPath.row+indexPath.section*100000;
        [cell setPOIInfo:group[indexPath.row] target:self action:@selector(navigationAction:) tag:tag];
        
        return cell;
    }else{
        RTMPoiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RTMPoiCell"];
        NSInteger style = self.changeStartOrEndPoi;
        NSInteger tag = indexPath.row+indexPath.section*100000;

        [cell setPOIInfo:self.resultsArr[indexPath.row] target:self action:@selector(navigationAction:) tag:tag keyword:self.searchTextField.text style:style];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RTLbs3DPOIMessageClass * poi = nil;

    if (tableView == self.resultGroupTableView) {
        poi = self.resultsGroupDict[self.floorIndexs[indexPath.section]][indexPath.row];
    }else if (tableView == self.resultTableView){
        poi = self.resultsArr[indexPath.row];
    }
    
    [self sendAppSearchPoiRequest:poi];
    [self saveSearchRecord:poi.POI_Name];
    
    if (self.handler) {
        self.handler(@[poi],0);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.resultTableView) {
        return 0;
    } 
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.resultGroupTableView) {
        RTMPoiSectionHeaderView * view = [RTMPoiSectionHeaderView loadView];
        NSString * floor = self.floorIndexs[section];
        [view setFloor:floor];
        view.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 30);
        return view;
    }
    return nil;
}

#pragma mark - 分类搜索 类型代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.classifyArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[[self.classifyArr[section] allValues] firstObject] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        RTMPoiHistoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RTMPoiHistoryCell" forIndexPath:indexPath];
        NSDictionary * data = [self.classifyArr[indexPath.section] allValues].firstObject[indexPath.row];
        [cell setTitle:data[@"name"]];
        return cell;
    }else{
        RTMSearchClassifyCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RTMSearchClassifyCell" forIndexPath:indexPath];
        NSArray * datas = [self.classifyArr[indexPath.section] allValues].firstObject;
        [cell setClassifyInfo:datas[indexPath.row]];
            return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:@"UICollectionElementKindSectionFooter"]) {
        RTMHistoryClearCell * cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RTMHistoryClearCell" forIndexPath:indexPath];
        [cell bindTarget:self action:@selector(clearHistoryRecordsAction:)];
        return cell;
    }
    RTMSearchClassifyTypeCell * cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"RTMSearchClassifyTypeCell" forIndexPath:indexPath];
    NSString * type = [self.classifyArr[indexPath.section] allKeys].firstObject;
    
    [cell setTypeTitle:type addLine:indexPath.section != 2 || [[self.classifyArr[indexPath.section] allValues].firstObject count]];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 2) {
        NSInteger count = [[[self.classifyArr[section] allValues] firstObject] count];
        
        if (count) {
            return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 42);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 2) {
        UICollectionViewFlowLayout * collectionViewLayout = (UICollectionViewFlowLayout *)self.classifyCollectionView.collectionViewLayout;
        return collectionViewLayout.itemSize;
    }else{
        NSDictionary * data = [self.classifyArr[indexPath.section] allValues].firstObject[indexPath.row];
        NSString * title = data[@"name"];
        CGSize titleSize = [self sizeWithText:title font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(CGFLOAT_MAX, 30)];
        return CGSizeMake(titleSize.width+28,30);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return UIEdgeInsetsMake(15, 10, 0, 10);
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * data = [self.classifyArr[indexPath.section] allValues].firstObject[indexPath.row];
    if (indexPath.section == 0) {
        self.searchResultDisplayType = RTMSearchResultDisplayTypeNone;
        [self.mapService getClassifySearchWithBuildId:self.buildingID Floor:self.floorID ClassIds:data[@"id"] pageindex:1 pagesize:200];
        [self sendAppSearchTagRequest:data];
    }else if(indexPath.section == 1){
        self.floorIndexs = nil;
        self.resultsGroupDict = nil;
        [self.resultGroupTableView reloadData];
        self.resultGroupTableView.hidden = NO;
        self.searchResultDisplayType = RTMSearchResultDisplayTypeGroup;
        [self.searchTextField becomeFirstResponder];
        self.searchTextField.text = data[@"name"];
        [self requestClassifyPOIs:data];
        [self sendAppSearchTagRequest:data];
    }else if(indexPath.section == 2){
        self.searchResultDisplayType = RTMSearchResultDisplayTypePlain;
        self.resultsArr = nil;
        [self.resultTableView reloadData];
        [self.searchTextField becomeFirstResponder];
        self.searchTextField.text = data[@"name"];
        [self.mapService getKeywordSearch:data[@"name"] buildID:self.buildingID Floor:nil];
    }
}
#pragma mark - 搜索框 代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.searchResultDisplayType == RTMSearchResultDisplayTypeGroup) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (self.searchResultDisplayType == RTMSearchResultDisplayTypeGroup) {
        self.searchResultDisplayType = RTMSearchResultDisplayTypePlain;
        self.resultGroupTableView.hidden = YES;
        textField.text = @"";
        [textField endEditing:YES];
        return NO;
    }else if(self.searchResultDisplayType == RTMSearchResultDisplayTypePlain){
        
        self.resultsArr = nil;
        [self.resultTableView reloadData];
    }
    return YES;
}

//RTMSearchResultDisplayTypeGroup 模式下走以下代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.resultTableView.hidden = NO;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.searchResultDisplayType == RTMSearchResultDisplayTypePlain) {
        if (self.changeStartOrEndPoi == RTMPoiSearchTypeNormal) {
            if (!self.resultsArr.count) {
                self.resultTableView.hidden = YES;
            }
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.searchResultDisplayType == RTMSearchResultDisplayTypePlain) {
        NSString * text = textField.text?:@"";
        text = [text stringByReplacingCharactersInRange:range withString:string];
        if (text.length) {
            [self.mapService getKeywordSearch:text buildID:self.buildingID Floor:nil];
        }else{
            self.resultsArr = nil;
            [self.resultTableView reloadData];
        }
    }
    return YES;
}

#pragma mark - 搜索请求回调
- (void) searchRequestFinish:(NSArray *)poiMessageArray{
    self.resultsArr = poiMessageArray;
    [self.resultTableView reloadData];
}

- (void) searchRequestFail:(NSString*)error{
    self.resultsArr = nil;
    [self.resultTableView reloadData];
}

-(void)getBuildClassifyFinish:(NSArray *)classTypeList{
    if (self.searchResultDisplayType == RTMSearchResultDisplayTypeNone){
        if (self.handler) {
            self.handler(classTypeList,RTMPoiUsingModeNormal);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)getBuildClassifyFail:(NSString *)error{
    
}
@end
