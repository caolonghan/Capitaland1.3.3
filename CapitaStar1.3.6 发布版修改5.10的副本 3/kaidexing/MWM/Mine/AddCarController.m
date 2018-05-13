//
//  AddCarController.m
//  kaidexing
//
//  Created by 朱巩拓 on 16/5/13.
//  Copyright © 2016年 dwolf. All rights reserved.
//

#import "AddCarController.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789学➋➌➍➎➏➐➑➒"

@interface AddCarController ()<UITextFieldDelegate>
{
    UIView * alphaView;
}
@property (strong,nonatomic)UILabel         *cityLab;
@property (strong,nonatomic)UITextField     *cityTextF;
@property (strong,nonatomic)NSArray         *cityArray;

@end

@implementation AddCarController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarTitleLabel.text= @"绑定车牌号";
    
    self.view.backgroundColor=UIColorFromRGB(0xf5f5f5);
    self.cityArray=[[NSArray alloc]initWithObjects:@"京",@"津",@"冀",@"晋",@"蒙",@"辽",@"吉",
                                                    @"黑",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",
                                                    @"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",
                                                    @"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",
                                                    @"青",@"宁",@"新",@"港",@"澳",@"台", nil];
    [self initHeadView];
}

-(void)initHeadView
{
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0,84, WIN_WIDTH, 40)];
    headview.backgroundColor=[UIColor whiteColor];
    
    self.cityLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0,31, headview.frame.size.height)];
    self.cityLab.text=@"";
    self.cityLab.textAlignment=NSTextAlignmentCenter;
    self.cityLab.font=COMMON_FONT;
    
    UIImageView *downImg=[[UIImageView alloc]initWithFrame:CGRectMake(41, 17, 14, 7)];
    [downImg setImage:[UIImage imageNamed:@"down"]];
    
    UIButton *cityBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,50, 40)];
    [cityBtn addTarget:self action:@selector(city1Touch:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(downImg.frame)+6, 10, 1, headview.frame.size.height - 10*2)];
    lineView.backgroundColor=COLOR_LINE;
    
    self.cityTextF=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame)+4, 0,
                                                                SCREEN_FRAME.size.width - 10 - CGRectGetMaxX(lineView.frame)- 4,headview.frame.size.height)];
    self.cityTextF.delegate=self;
    self.cityTextF.autocorrectionType = UITextAutocorrectionTypeNo;
    self.cityTextF.keyboardType=UIKeyboardTypeTwitter;
    self.cityTextF.placeholder=@"请输入车牌号";
    self.cityTextF.font=COMMON_FONT;
    
    
    [headview addSubview:self.cityLab];
    [headview addSubview:downImg];
    [headview addSubview:cityBtn];
    [headview addSubview:lineView];
    [headview addSubview:self.cityTextF];
    [self.view addSubview:headview];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addBtn.frame = CGRectMake(10, CGRectGetMaxY(headview.frame) + 20, WIN_WIDTH - 10 * 2, 38);
    addBtn.backgroundColor = APP_BTN_COLOR;
    addBtn.layer.cornerRadius = DEFAULT_BUTTON_RADIUS;
    addBtn.layer.masksToBounds = YES;
    addBtn.titleLabel.font = COMMON_FONT;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitle:@"新增车牌号" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addBtn];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    else{
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        BOOL canChange = [string isEqualToString:filtered];

            UITextRange *selectedRange = [textField markedTextRange];
            NSString * newText = [textField textInRange:selectedRange];
            if(newText.length>0){
                return textField.text.length>9?NO: canChange;
            }
            else
            {
                return textField.text.length>6?NO: canChange;

    }
//    if (textField == self.cityTextF) {
//        if (textField.text.length >5){
//            self.cityTextF.text=[textField.text substringToIndex:5];
//       }
//    }
//    return YES;

    }
}
//点击了选择 省缩写
-(void)city1Touch:(UIButton*)sender
{
    [self.cityTextF resignFirstResponder];
    alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    alphaView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    alphaView.userInteractionEnabled  =YES;
    
    [self.view addSubview:alphaView];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelect:)];
    
    [alphaView addGestureRecognizer:tap];
    
    
    
    
    int row = 6;    //行
    int column = 6; //列
    
    UIView * lightGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, WIN_HEIGHT - (6*50+10), WIN_WIDTH, (6*50+10))];
    lightGrayView.backgroundColor = COLOR_LINE;
    
    [alphaView addSubview:lightGrayView];
    
    CGFloat width = (WIN_WIDTH - (column + 1) * 10) / row;
    CGFloat height = 40;
    
    for (int r = 0; r < row; r++) {
        
        for (int c = 0; c < column; c++) {
            
            if (c + r * column >= _cityArray.count) {
                
                return;
            }
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame = CGRectMake(10 + c * (width + 10), 10 + r * (height + 10), width, height);
            btn.backgroundColor = [UIColor whiteColor];
            btn.titleLabel.font = DESC_FONT;
            [btn setTitleColor:COLOR_FONT_BLACK forState:UIControlStateNormal];
            [btn setTitle:_cityArray[c + r * column] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [lightGrayView addSubview:btn];
        }
    }
}

- (void)cancelSelect:(UITapGestureRecognizer *)tap {
    
    [alphaView removeFromSuperview];
}


- (void)selectedAction:(UIButton *)sender {
    
    _cityLab.text = sender.titleLabel.text;
    
    [alphaView removeFromSuperview];
}

/*
 *  判断用户输入的车牌是否符合规范，符合规范的密码要求：
 1. 数字或者字母
 */
+(BOOL)judgeCarNum:(NSString *)pass{
    BOOL result = false;
    
    if (pass.length ==6) {
        NSString * regex = @"[A-Z_a-z]{1}[A-Z_a-z_0-9]{4}[A-Z_a-z_0-9挂学警港澳]{1}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return  result = [pred evaluateWithObject:pass];
    }else if (pass.length==7)
    {
        NSString * regex =@"[A-Z_a-z]{1}[A-Z_a-z_0-9]{6}";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return  result = [pred evaluateWithObject:pass];
    }
    return NO;
}


- (void)addAction:(UIButton *)sender {
    sender.enabled = NO;
    NSString* carNum = _cityTextF.text;
    if([Util isNull:carNum]){
        [SVProgressHUD showErrorWithStatus:@"请输入车牌号码"];
        sender.enabled = YES;
        return;
    }
    if([Util isNull:_cityLab.text]){
        [SVProgressHUD showErrorWithStatus:@"请选择省份"];
        sender.enabled = YES;
        return;
    }
    if(![AddCarController judgeCarNum:carNum]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的车牌号"];
        sender.enabled = YES;
        return;
    }
    NSString * path = [Util makeRequestUrl:@"usercenter" tp:@"addcarno"];
    NSString * carno = [NSString stringWithFormat:@"%@%@%@", _cityLab.text,@"_",_cityTextF.text];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:[Global sharedClient].member_id, @"member_id", carno, @"car_no", @"1000", @"source", nil];
    
    [SVProgressHUD showWithStatus:@"车牌添加中"];
    [HttpClient requestWithMethod:@"POST" path:path parameters:params target:self success:^(NSDictionary *dic) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
             [SVProgressHUD dismiss];
            [self.delegate.navigationController popViewControllerAnimated:YES];
            sender.enabled = YES;
        });
        
    } failue:^(NSDictionary *dic) {
        NSLog(@"请求失败=%@",dic[@"msg"]);
        sender.enabled = YES;
    }];
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
