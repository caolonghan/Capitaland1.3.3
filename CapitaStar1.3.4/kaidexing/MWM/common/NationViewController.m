//
//  NationViewController.m
//  ShouYi
//
//  Created by Hwang Kunee on 14-1-25.
//  Copyright (c) 2014年 Hwang Kunee. All rights reserved.
//

#import "NationViewController.h"

@interface NationViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MJNIndexViewDataSource>

@end

@implementation NationViewController{
    @private
    NSMutableArray* nations;
    UITableView* tableView;
    MJNIndexView* indexView;
    NSMutableArray* firstLetterList;
    
    NSMutableDictionary* nationsDic;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"选择地址"];
    nationsDic = [[NSMutableDictionary alloc] init];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"address.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray* dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    nations = [[NSMutableArray alloc] init];
    if(self.selectType == 0){ //选择地址
        for(NSDictionary* item in dataArr){
            if([[item valueForKey:@"parentid"] isEqualToString:@"0"]){
                [nations addObject:item];
            }
        }
    }else {
        for(NSDictionary* item in dataArr){
            if([[item valueForKey:@"parentid"] intValue] == self.parentId){
                [nations addObject:item];
            }
        }
    }
    [self drawContent];
    
}

-(void)loadNationsTable{
    
    firstLetterList = [[NSMutableArray alloc] init];

    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height - NAV_HEIGHT)];
    [tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"cell"];
   // [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    
    indexView = [[MJNIndexView alloc]initWithFrame:tableView.frame];
    indexView.dataSource = self;
    [self.view addSubview:indexView];
    
    indexView.getSelectedItemsAfterPanGestureIsFinished = NO;
    indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    indexView.backgroundColor = [UIColor clearColor];
    indexView.curtainColor = nil;
    indexView.curtainFade = 0.0;
    indexView.curtainStays = YES;
    indexView.curtainMoves = YES;
    indexView.curtainMargins = NO;
    indexView.ergonomicHeight = NO;
    indexView.upperMargin = 10.0;
    indexView.lowerMargin = 10.0;
    indexView.rightMargin = 10.0;
    indexView.itemsAligment = NSTextAlignmentCenter;
    indexView.maxItemDeflection = 40.0f;
    indexView.rangeOfDeflection = 5;
    indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    indexView.darkening = NO;
    indexView.fading = YES;
}

-(void)drawContent{
    /*
    UIView* searchView = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_FRAME.size.width, 40)];
    [searchView setBackgroundColor:DEFAULT_ITEM_BG_COLOR];
    [self.view addSubview:searchView];
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:searchView.bounds];
    [searchBar setPlaceholder:@"搜索"];
    [searchView addSubview:searchBar];
    */
    [self loadNationsTable];
    
}


# pragma mark TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont fontWithName:indexView.font.fontName size:20.0];
    
    NSDictionary* itemData = [nations objectAtIndex:indexPath.row];
    cell.textLabel.text = [itemData valueForKey:@"name"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    headerView.tintColor = RGBCOLOR(80.0, 215.0, 250.0);
//    headerView.contentView.backgroundColor = DEFAULT_ITEM_BG_COLOR;
//    headerView.textLabel.textColor = DEFAULT_TEXT_COLOR;
//    headerView.textLabel.font = [UIFont fontWithName:indexView.selectedItemFont.fontName size:headerView.textLabel.font.pointSize];
// //   [[headerView textLabel] setText:[NSString stringWithFormat:@"  %@",[self firstLetter:section]]];
//    return headerView;
//}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return firstLetterList;
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:indexView.getSelectedItemsAfterPanGestureIsFinished];
}


- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * item = [nations objectAtIndex:indexPath.row];
    if(self.selectType == 1){
        
        NationViewController* vc = [[NationViewController alloc] init];
        vc.selectType = 2;
        vc.parentName = [item valueForKey:@"name"];
        vc.parentId = [[item valueForKey:@"code"] intValue];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic addEntriesFromDictionary:_selectDic];
        [dic setObject:@[[item valueForKey:@"name"], [item valueForKey:@"code"]] forKey:@"city"];
        vc.selectDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
        
//        NSDictionary* retObj = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                [NSString stringWithFormat:@"%d", self.parentId ],@"parentId",self.parentName,@"parentName",[item valueForKey:@"name"],@"subName",[item valueForKey:@"code"],@"subCode",nil];
//        [Global sharedClient].syncObj = retObj;
//        [Global sharedClient].action = ACT_SELECT_ADDR;
//        [self popToViewController:2];
        return nil;
    }else if(self.selectType == 2){

        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic addEntriesFromDictionary:_selectDic];
        [dic setObject:@[[item valueForKey:@"name"], [item valueForKey:@"code"]] forKey:@"area"];
        [Global sharedClient].syncObj = dic;
        [Global sharedClient].action = ACT_SELECT_AREA;
        [self popToViewController:3];
        
        return nil;
    }else{
        NationViewController* vc = [[NationViewController alloc] init];
        vc.selectType = 1;
        vc.parentName = [item valueForKey:@"name"];
        vc.parentId = [[item valueForKey:@"code"] intValue];
        vc.selectDic = [[NSDictionary alloc] initWithObjectsAndKeys:@[[item valueForKey:@"name"], [item valueForKey:@"code"]], @"prov", nil];
        [self.navigationController pushViewController:vc animated:YES];

    }
    return nil;
}


-(NSString*)firstLetter:(NSInteger) section{
    return [firstLetterList objectAtIndex:section];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
