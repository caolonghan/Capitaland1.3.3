//
//  MaleView.h
//  sgSalerReport
//
//  Created by YaoHuiQiu on 16/5/6.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaleView : UIView

@property(nonatomic, strong)UIView * bigView;
@property(nonatomic, strong)UIView * smallView;
@property(nonatomic, strong)UILabel * maleLab;
@property BOOL  isSelect;
@property(nonatomic, strong)NSString * group;
@end
