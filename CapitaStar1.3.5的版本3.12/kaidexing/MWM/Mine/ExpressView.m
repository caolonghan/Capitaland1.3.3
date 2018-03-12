//
//  ExpressView.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/6/22.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "ExpressView.h"
#import "Const.h"
@implementation ExpressView
{
    NSString *dataStr;
    NSString *idStr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.01];
        
        self.pickerView1=[[UIPickerView alloc]initWithFrame:CGRectMake(0,0,WIN_WIDTH,M_WIDTH(150))];
        self.pickerView1.backgroundColor=UIColorFromRGB(0xf6f6f6);
        self.pickerView1.delegate=self;
        self.pickerView1.dataSource=self;
        [self addSubview:self.pickerView1];
        [self.pickerView1 reloadAllComponents];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-M_WIDTH(75), M_WIDTH(10), M_WIDTH(50), M_WIDTH(20))];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font=COMMON_FONT;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
#pragma mark pickerview function

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataAry.count;
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return M_WIDTH(20);
}
//返回指定列的宽度
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return WIN_WIDTH;
}

// 自定义指定列的每行的视图，即指定列的每行的视图行为一致
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text =[[UILabel alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,M_WIDTH(20))];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = [_dataAry objectAtIndex:row];
    [view addSubview:text];
    
    return view;
}
//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _titleStr;
}
//显示的标题字体、颜色等属性
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str = [_dataAry objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}

//被选择的行
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"HANG%@",[_dataAry objectAtIndex:row]);
    dataStr=[_dataAry objectAtIndex:row];
    idStr  =[_idArray objectAtIndex:row];
}

-(void)btn:(UIButton*)sender
{
    self.hidden=YES;
    if ([Util isNull:dataStr]) {
        dataStr=_dataAry[0];
        idStr  =_idArray[0];
    }
    NSArray *array=[[NSArray alloc]initWithObjects:_typeStr,dataStr,idStr,nil];
    if (_exDelegate &&[_exDelegate respondsToSelector:@selector(setTouch:)]) {
        [_exDelegate setTouch:array];
    }
    
}



@end
