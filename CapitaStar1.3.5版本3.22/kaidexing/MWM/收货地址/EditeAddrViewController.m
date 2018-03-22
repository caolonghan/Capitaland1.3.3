//
//  EditeAddrViewController.m
//  kaidexing
//
//  Created by dwolf on 2017/6/9.
//  Copyright © 2017年 dwolf. All rights reserved.
//

#import "EditeAddrViewController.h"
#import "UnionSelectActionSheetPicker.h"
#import "AreaVM.h"

@interface EditeAddrViewController ()
@property (retain,nonatomic)UITableView         *tableView;
@end

@implementation EditeAddrViewController{
    AddressVM* addressVM;
    NSArray<NSArray*>* dataArr;
    AreaVM* areaVM;
    NSMutableArray* areaArr;
    UnionSelectActionSheetPicker* pickerView;
    bool isLoad;
    UITextField* preTF;
    NSString* proviceStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    addressVM = [[AddressVM alloc] init];
    areaVM = [[AreaVM alloc] init];
    areaArr = [[NSMutableArray alloc] init];
    [self configVMMsg];
    proviceStr = @"";
    if(_model != nil){
        self.navigationBarTitleLabel.text=@"修改收货地址";
        NSString* prov = [areaVM loadArea:_model.province][@"name"];
        NSString* city = [areaVM loadArea:_model.city][@"name"];
        NSString* area = [areaVM loadArea:_model.area][@"name"];
        proviceStr = [NSString stringWithFormat:@"%@ %@ %@",prov,city,area];
    }else{
       self.navigationBarTitleLabel.text=@"新增收货地址";
        _model = [[AddressModel alloc] init];
    }
    
    dataArr = @[@[@"收货人",@"手机号码",@"省市区",@"详细地址"],@[@"默认地址"]];
    
    
    [self initRightNav];
    [self.tableView reloadData];
}

//导航右侧按钮
-(void) initRightNav{
    MLabel* label = [[MLabel alloc] init];
    label.frame = self.rigthBarItemView.bounds;
    label.text = @"保存";
    label.font = COMMON_FONT;
    label.textColor = APP_BTN_COLOR;
    [self.rigthBarItemView addSubview:label];
    self.rigthBarItemView.hidden = NO;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRightNavTap:)];
    [self.rigthBarItemView addGestureRecognizer:tap];
}

-(void) onRightNavTap:(UITapGestureRecognizer*) tap{
    UIView* view = [tap view];
    view.userInteractionEnabled = NO;
    UITextField* tf = (UITextField*)[_tableView viewWithTag:1000];
    _model.name = tf.text;
    tf = (UITextField*)[_tableView viewWithTag:1001];
    _model.telephone = tf.text;
    tf = (UITextField*)[_tableView viewWithTag:1003];
    _model.address = tf.text;
    if([Util isNull:_model.province] ){
        [self showMsg:@"请选择省市"];
        view.userInteractionEnabled = YES;
        return;
    }
    if([Util isNull:_model.name] ){
        [self showMsg:@"请输入姓名"];
        view.userInteractionEnabled = YES;
        return;
    }
    if([Util isNull:_model.telephone] ){
        [self showMsg:@"请输入联系电话"];
        view.userInteractionEnabled = YES;
        return;
    }
    if([Util isNull:_model.address] ){
        [self showMsg:@"请填写收货详细地址"];
        view.userInteractionEnabled = YES;
        return;
    }
    
    [addressVM addAddress:_model];
}

//设置事件
-(void) configVMMsg{
    
    //更新默认成功
    [[addressVM.successObject filter:^BOOL(id value){
        return [value intValue] == 1;
    }]
     subscribeNext:^(id data) {
         [self showMsg:@"更新成功" afterOK:^{
             [self.navigationController popViewControllerAnimated:YES];
         }];
         
     }];
    
    
    [addressVM.errorObject subscribeNext:^(id x) {
        self.rigthBarItemView.userInteractionEnabled = YES;
        [self showMsg:x];
        [SVProgressHUD dismiss];
    } ];
    
}


-(UITableView*)tableView
{
    if (!_tableView) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,NAV_HEIGHT, WIN_WIDTH, WIN_HEIGHT-NAV_HEIGHT) style:UITableViewStyleGrouped];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.separatorColor = DEFAULT_BG_COLOR;
//        self.tableView.backgroundColor=UIColorFromRGB(0xf4f4f4);
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//         self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 0.1)];
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

-(void)initbuttomView
{
    UIButton *shouhuoBtn=[[UIButton alloc]initWithFrame:CGRectMake(M_WIDTH(10),WIN_HEIGHT-M_WIDTH(45), WIN_WIDTH-M_WIDTH(20),M_WIDTH(35))];
    [shouhuoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shouhuoBtn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    shouhuoBtn.backgroundColor=APP_BTN_COLOR;
    shouhuoBtn.layer.masksToBounds=YES;
    shouhuoBtn.layer.cornerRadius=5;
    [shouhuoBtn addTarget:self action:@selector(addTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shouhuoBtn];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr[section].count;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 7;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray<NSArray*>* placeholders = @[@[@"请输入收货人",@"请输入手机号码",@"选择省市区",@"请填写详细地址"],@[@""]];
    NSArray<NSArray*>* values;
    if(_model != nil){
        values = @[@[_model.name,_model.telephone,proviceStr,_model.address],@[@" "]];
    }else{
        values = @[@[@"",@"",@"",@""],@[@" "]];
    }
    

    static NSString *CellName = @"AddrCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell==nil) {
        //如何让创建的cell加个戳
        //对于加载的xib文件，可以到xib视图的属性选择器中进行设置
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellName];
    }
    UIView* subView = [cell viewWithTag:9999];
    [subView removeFromSuperview];
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, WIN_WIDTH, 49);
    MLabel* label = [[MLabel alloc] init];
    label.frame = CGRectMake(10, 0, 100, CGRectGetHeight(view.frame));
    label.text = dataArr[indexPath.section][indexPath.row];
    label.font = COMMON_FONT;
    label.textColor = COLOR_FONT_SECOND;
    [view addSubview:label];
    
    UITextField* textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(83, 0, WIN_WIDTH - 10 - 83, CGRectGetHeight(view.frame));
    [textField setValue:COLOR_FONT_SECOND
             forKeyPath:@"_placeholderLabel.textColor"];
    textField.font = COMMON_FONT;
    textField.textColor = COLOR_FONT_BLACK;
    textField.delegate = self;
    textField.tag = (indexPath.section+1)*1000 + indexPath.row;
    [view addSubview:textField];
    if([Util isNull:values[indexPath.section][indexPath.row]]){
        textField.placeholder = placeholders[indexPath.section][indexPath.row];
    }else{
        textField.text = values[indexPath.section][indexPath.row];
    }
    
    if(indexPath.section == 0){
        if(indexPath.row == 2){
            UIImageView* imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(WIN_WIDTH- 10 - 11, CGRectGetHeight(view.frame)/2-19/2, 11, 19);
            imgView.image = [UIImage imageNamed:@"more"];
            [view addSubview:imgView];
            textField.frame = CGRectMake(83, 0, CGRectGetMinX(imgView.frame) - 83, CGRectGetHeight(view.frame));
        }
        if(indexPath.row == 1){
            textField.keyboardType = UIKeyboardTypePhonePad;
            [textField.rac_textSignal subscribeNext:^(id x){
                NSString* string = x;
                if(string.length  == 11){
                    _model.telephone = x;
                }else if(string.length > 11){
                    textField.text = [x substringToIndex:11];
                }
            }];
        }
        if(indexPath.row == 0){
            [textField.rac_textSignal subscribeNext:^(id x){
                NSString* string = x;
                _model.name = x;
                if(string.length > 15){
                    textField.text = [x substringToIndex:15];
                }
                
            }];
        }
        if(indexPath.row == 3){
            [textField.rac_textSignal subscribeNext:^(id x){
                NSString* string = x;
                _model.address = x;
                if(string.length > 60){
                    textField.text = [x substringToIndex:60];
                }
            }];
        }
        

    }else if(indexPath.section == 1){
        textField.enabled = NO;
        UIImageView* imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(WIN_WIDTH- 10 - 49, CGRectGetHeight(view.frame)/2-31/2, 49, 31);
        if([Util isNull:_model.isDefault] || [_model.isDefault intValue] == 0){
            imgView.image = [UIImage imageNamed:@"switch_off"];
        }else{
            imgView.image = [UIImage imageNamed:@"switch_on"];
        }
        
        [view addSubview:imgView];
        textField.frame = CGRectMake(83, 0, CGRectGetMinX(imgView.frame) - 83, CGRectGetHeight(view.frame));
    }
    view.tag = 9999;
    [cell addSubview:view];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 0){
        _model.isDefault =  [Util isNull:_model.isDefault] || [_model.isDefault isEqualToString:@"0"]? @"1" :@"0";
        [tableView reloadData];
    }
}

-(void)setAddressView:(id) sender
{
    [self configArrMsg:sender];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField{
    NSLog(@"textFieldShouldBeginEditing");
    int tag = textField.tag;
    if(tag == 1002){
        [self setAddressView:textField];
        [preTF resignFirstResponder];
        return NO;
    }else{
        preTF = textField;
        return YES;
    }
    
}

-(void) configArrMsg:(id) sender{
    
    [areaVM.successObject subscribeNext:^(id x) {
        NSDictionary* dic = x;
        id level = dic[@"level"];
        NSArray<NSDictionary*>* data =  dic[@"data"];
        [areaArr setObject:data atIndexedSubscript:[level intValue] - 1];
        if([level intValue]  < 4){
            [areaVM loadArea:data[0][@"id"] type:[level intValue]+1];
        }else{
            if(pickerView == nil){
                NSArray *initialSelection = @[@"",@"",@""];
                //    NSArray *rows = [self loadUnionData:@{@"ID":@(0)} index:0];
                //pickeCount  联动选择器的滚轮数量；doneBlock 选择完成点击确认后执行的函数
                //cancelBlock 点击取消后触发的块
                //origin 发起的控件，必须填写
                //delegate 联动选择器数据代理类
                NSArray *rows = @[@[@""],@[],@[]];
                pickerView = [[UnionSelectActionSheetPicker alloc] initWithTitle:@"" pickeCount:3 rows:areaArr initialSelection:initialSelection doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                    [areaVM.successObject sendCompleted];
                    pickerView = nil;
//                    if(isLoad){
//                        return ;
//                    }
                    
                    _model.province = selectedValue[0][@"id"];
                    _model.city = selectedValue[1][@"id"];
                    _model.area = selectedValue[2][@"id"];
                    UITextField* textF = (UITextField*) [_tableView viewWithTag:1002];
                    textF.text = [NSString stringWithFormat:@"%@ %@ %@",selectedValue[0][@"name"],selectedValue[1][@"name"],selectedValue[2][@"name"]];
                    proviceStr = textF.text;
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    pickerView = nil;
                    [areaVM.successObject sendCompleted];
                } origin:sender];
                pickerView.delegate = self;
                {
                    UIButton* doneBtn =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
                    [doneBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
                    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
                    doneBtn.titleLabel.font = DESC_FONT;
                    UIBarButtonItem* doneItem =  [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
                    [pickerView setDoneButton:doneItem];
                }
                {
                    UIButton* doneBtn =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
                    [doneBtn setTitleColor:APP_BTN_COLOR forState:UIControlStateNormal];
                    [doneBtn setTitle:@"取消" forState:UIControlStateNormal];
                    doneBtn.titleLabel.font = DESC_FONT;
                    UIBarButtonItem* doneItem =  [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
                    [pickerView setCancelButton:doneItem];
                }
                isLoad = false;
                [pickerView showActionSheetPicker];
                
            }else{
                isLoad = false;
                //发送消息
                [[NSNotificationCenter defaultCenter] postNotificationName:UNION_SELECT_MSG_UPDATE object:@{@"component":@(1),@"data":areaArr} userInfo:nil];
            }
            
        }
    }];
    [areaVM loadArea:@"0" type:1];
    isLoad = true;

}
//必须；当选择某项内容后需要重新加载的数据项（必须从当前页面后面所有数据重新加载）
- (NSArray*)loadUnionData:(NSDictionary *)dic index:(int)index{
    isLoad = true;
    [areaVM loadArea:[dic valueForKey:@"id"] type:index+1];
    return nil;
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
