//
//  GridViewController.m
//  EAM
//
//  Created by dwolf on 16/9/9.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "CollectionViewController.h"
#define CELL_TOP_H M_WIDTH(38)

// 注意const的位置
static NSString *const cellId = @"ImgValueCollectionViewCell";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";
@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CollectionViewController
@synthesize collectionView, dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewLayout* customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:customLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册cell、sectionHeader、sectionFooter
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    
    self.navigationBar.hidden = YES;
    
    collectionView.backgroundColor = DEFAULT_BG_COLOR;
    
    [collectionView registerNib:[UINib nibWithNibName:cellId bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier: cellId];
    
    [self initConfigData];

    
}


-(void) initConfigData{
    _coloumNum = _coloumNum == 0 ? 3 : _coloumNum;
    _itemSpace = _itemSpace == 0 ? 1 : _itemSpace == -1 ? 0: _itemSpace;
}

#pragma mark ---- 数据源方法实现

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return dataArr.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ((NSArray*)dataArr[section]).count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if([self.collectViewDelegate respondsToSelector:@selector(drawCell:collect:)]){
        return [self.collectViewDelegate drawCell:indexPath collect:collectionView];
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = footerId;
    }else{
        reuseIdentifier = headerId;
    }
    
    UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
    view.backgroundColor=[UIColor whiteColor];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if ([self.collectViewDelegate respondsToSelector:@selector(createCollectionHeader:index:)]) {
            [self.collectViewDelegate createCollectionHeader:view index:indexPath];
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
            if ([self.collectViewDelegate respondsToSelector:@selector(createCollectionFooder:index:)]) {
                [self.collectViewDelegate createCollectionFooder:view index:indexPath];
            }
    }
    return view;
}


// 和UITableView类似，UICollectionView也可设置段头段尾
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
//        if(headerView == nil){
//            headerView = [[UICollectionReusableView alloc] init];
//        }
//
//        return headerView;
//    }
//    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
//    {
//        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
//        if(footerView == nil)
//        {
//            footerView = [[UICollectionReusableView alloc] init];
//        }
//        if ([self.collectViewDelegate respondsToSelector:@selector(createCollectionFooder:index:)]) {
//            [self.collectViewDelegate createCollectionFooder:footerView index:indexPath];
//        }
//        return footerView;
//    }
//    
//    return nil;
//}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}




#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = (WIN_WIDTH-(_coloumNum-1)*_itemSpace - self.edgeInset.left - self.edgeInset.right)/_coloumNum;
    float height = self.itemHeight == 0?(WIN_WIDTH-(_coloumNum-1)*_itemSpace - self.edgeInset.left)/_coloumNum:self.itemHeight;
    return (CGSize){width,height};
}




//四周留出空间
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.edgeInset;
}


//每行的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return _itemSpace;
}

//行内距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return _itemSpace;
}

//头部视图如果不需要可注释

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_collectViewDelegate && [self.collectViewDelegate respondsToSelector:@selector(setHeaderViewHeight:)]) {
        return (CGSize){WIN_WIDTH,[self.collectViewDelegate setHeaderViewHeight:section]};
    }
    return (CGSize){WIN_WIDTH,0};
}

//尾部视图如果不需要可注释
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (_collectViewDelegate && [self.collectViewDelegate respondsToSelector:@selector(setFooderViewHeight:)]) {
        return (CGSize){WIN_WIDTH,[self.collectViewDelegate setFooderViewHeight:section]};
    }
    return (CGSize){WIN_WIDTH,0};
}




#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.collectViewDelegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]){
        [self.collectViewDelegate didSelectItemAtIndexPath:indexPath ];
    }
}


// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    
    return NO;
}

//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
//    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
//    {
//        //        NSLog(@"-------------执行拷贝-------------");
//        [_collectionView performBatchUpdates:^{
//            [_section0Array removeObjectAtIndex:indexPath.row];
//            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//        } completion:nil];
//    }
//    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
//    {
//        NSLog(@"-------------执行粘贴-------------");
//    }
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
