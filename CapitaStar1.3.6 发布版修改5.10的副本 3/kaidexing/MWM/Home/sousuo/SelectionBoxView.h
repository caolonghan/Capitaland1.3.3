//
//  SelectionBoxView.h
//  sgSalerReport
//
//  Created by 朱巩拓 on 16/5/7.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol selectionDelegate <NSObject>

-(void)setdelegate:(id)selecDelegate;
-(void)cancelSelect;

@end

@interface SelectionBoxView : UIView

@property (strong,nonatomic)NSArray     *dataArray;//接收数据用的数组
@property (strong,nonatomic)NSArray     *idArray;//用于接手之后返回的字段
@property (strong,nonatomic)NSString    *type;    //为了标示进来的是什么类型  1 表示楼层  2 表示生态
@property (nonatomic)float  xPoint;    //起始X坐标
@property (strong,nonatomic)NSString   *curSelectId; //当前选中的ID


@property (nonatomic,assign)id<selectionDelegate>selectioDelegate;

@property NSInteger _tag;
@end
