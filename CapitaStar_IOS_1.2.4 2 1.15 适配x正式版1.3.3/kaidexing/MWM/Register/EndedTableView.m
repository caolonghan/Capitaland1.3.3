//
//  EndedTableView.m
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/5.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "EndedTableView.h"

#import "ActivityViewController.h"
#import "EndedTVCell.h"
#import "GoViewController.h"

static NSString * identifier = @"EndedTVCell";

@implementation EndedTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.refreshTVDelegate=self;
        UINib * nib = [UINib nibWithNibName:@"EndedTVCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identifier];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.refreshTVDelegate=self;
        UINib * nib = [UINib nibWithNibName:@"EndedTVCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identifier];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EndedTVCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.dataDic = _dataArr[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1)];
    
    UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, CGRectGetWidth(view.bounds) - 11 - 6, 1)];
    grayView.backgroundColor = COLOR_LINE;
    
    if (section != 5) {
        
        [view addSubview:grayView];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=_dataArr[indexPath.row];
    NSString   *str=dic[@"active_url"];
    GoViewController *gvc=[[GoViewController alloc]init];
    gvc.path=str;
    [self.viewController.delegate.navigationController pushViewController:gvc animated:YES];
}

//-(void) loadData:(NSString*) type{
//    [_parent loadData:type];
//}
//-(void)tableView_refresh:(NSString *)type{
//    [self performSelector:@selector(loadData:) withObject:type afterDelay:0.f]
//}
#pragma mark - PullingRefreshTableViewDelegate
//- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(loadData:) withObject:REFRESH_METHOD afterDelay:0.f];
//}
//
//- (NSDate *)pullingTableViewRefreshingFinishedDate{
//    return [[NSDate alloc] init];
//}
//
//- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
//    [self performSelector:@selector(loadData:) withObject:MORE_METHOD afterDelay:0.f];
//    
//}


//- (void)scrollViewDidScroll:(UIScrollView *)vScrollView{
//    
//    [self tableViewDidScroll:vScrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)vScrollView willDecelerate:(BOOL)decelerate{
//    [self tableViewDidEndDragging:vScrollView];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
