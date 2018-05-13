//
//  RTMFloorPickerView.m
//  Rtlbs3DMapDemo
//

//  Copyright © 2017年 wang jinchang. All rights reserved.
//

#import "RTMFloorPickerView.h"

#import "UIColor+RTM.h"

@interface RTMFloorPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, assign) NSInteger preSelectedRow;
@property (nonatomic, weak) IBOutlet UIPickerView * floorPickerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * bottomMargin;
@property (weak, nonatomic) IBOutlet UIButton *comfireButton;
@end

@implementation RTMFloorPickerView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.preSelectedRow = 0;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    
    self.floorPickerView.showsSelectionIndicator = YES;
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    self.hidden = YES;
}
#pragma mark - 公共方法
//加载
+ (id)loadFloorPickerView{
    return [[NSBundle mainBundle] loadNibNamed:@"RTMFloorPickerView" owner:nil options:nil].lastObject;
}
- (void)reloadData{
    [self.floorPickerView reloadAllComponents];
}
- (void)scrollToRow:(NSInteger)row{
    if (row < [self.floorPickerView numberOfRowsInComponent:0]) {
        self.preSelectedRow = row;
        [self.floorPickerView selectRow:row inComponent:0 animated:NO];
    }
}
- (void)show{
    self.hidden = NO;
    self.bottomMargin.constant = 0;
    [UIView animateWithDuration:0.24 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)hide{
    self.bottomMargin.constant = -CGRectGetHeight(self.floorPickerView.frame);
    [UIView animateWithDuration:0.24 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer *)sender{
    NSInteger rows = [self.floorPickerView numberOfRowsInComponent:0];
    if (self.preSelectedRow < rows) {
        [self.floorPickerView selectRow:self.preSelectedRow inComponent:0 animated:YES];
    }
    [self hide];
}

- (IBAction)comfireButtonAction:(UIButton *)sender {
    [self hide];
    self.preSelectedRow = [self.floorPickerView selectedRowInComponent:0];
    
    if ([self.delegate respondsToSelector:@selector(floorPickerView:didSelectRow:)]) {
        [self.delegate floorPickerView:self didSelectRow:self.preSelectedRow];
    }
}
#pragma mark - floorPickerView data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.dataSource numberOfRowsInFloorPickerView:self];;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    NSDictionary * floorInfo = [self.dataSource floorPickerView:self floorInfoForRow:row];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(pickerView.frame), 40)];
    
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame)/2.f-2, 40)];
    leftLabel.font = [UIFont systemFontOfSize:26];
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.textColor = [UIColor colorFor333333];
    leftLabel.text = floorInfo[@"floor"];
    
    UILabel * rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.frame)/2.f+2, 0, CGRectGetWidth(view.frame)/2.f-2, 40)];
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.textColor = [UIColor colorFor333333];
    rightLabel.text = floorInfo[@"floor_subject"]?:@"";
    
    [view addSubview:leftLabel];
    [view addSubview:rightLabel];
    return view;
}
#pragma mark - floorPickerView delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
@end
