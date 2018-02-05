//
//  CompanyVC.m
//  WXCustomCamera
//
//  Created by macvivi on 17/4/2.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "CompanyVC.h"
#import "ChageCell.h"
#import "CreameVC.h"
//#import "WXCamerasViewViewController.h"
#import "uploadPicViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define APIDOMAIN @"https://ocrm.capitaland.com.cn/api_proxy"

@interface CompanyVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *dataAry;
@end

@implementation CompanyVC{
    @private
    NSMutableArray* valueArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTitleLabel.text = @"门禁信息确认";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _InitView];
    _dataAry = @[@"公司名称",@"姓名",@"手机号",@""];
    valueArr= [[NSMutableArray alloc] init];
    [self loadData];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadToken];
    if([[Global sharedClient].action isEqualToString:ACT_UPDATE_IMG]){
        [_enter_btn setTitle:@"确认" forState:UIControlStateNormal];
    }else{
        [_enter_btn setTitle:@"拍摄" forState:UIControlStateNormal];
    }
    [Global sharedClient].action= nil;
}

-(void) loadData{
    
    int  shopID=[[Global sharedClient].markID intValue];
    NSDictionary    *diction=[[NSDictionary alloc]initWithObjectsAndKeys:[Global sharedClient].member_id,@"member_id",nil];
    [HttpClient requestWithMethod:@"POST" path:[Util makeRequestUrl:@"member" tp:@"getmemberofficeinfo"] parameters:diction  target:self success:^(NSDictionary *dic){
        [valueArr addObject:dic[@"data"][@"companyname"]];
        [valueArr addObject:dic[@"data"][@"username"]];
        [valueArr addObject:dic[@"data"][@"phone"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [SVProgressHUD dismiss];
        });
    }failue:^(NSDictionary *dic){
    }];
}
- (void)loadToken
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"%@/api/v1/token",APIDOMAIN];
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    [manager POST:accessUrlStr parameters:TOKENPARAMS progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString* token = responseObject[@"token"];
        [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"token"] forKey:@"token"];
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"%@/api/v1/staff/mobile/%@",APIDOMAIN,[Global sharedClient].phone];
        //NSString *url = [NSString stringWithFormat:@"http://cnliutao1.chinacloudapp.cn:8080/api/v1/staff/mobile/%@",@"15995876379"];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            NSDictionary *locationdic = responseObject[@"project"];
            NSArray *picdic = responseObject[@"staff"][@"identy_photos"];
            
            
            if (!picdic|!locationdic) {
                
                [SVProgressHUD showErrorWithStatus:@"对不起，您的账号出现异常，请联系4008957957"];
                return;
            }
            if (picdic.count) {
                NSString *imaPath = [NSString stringWithFormat:@"%@/%@",APIDOMAIN,picdic[0][@"path"]];
                [_user_img setImageWithString:imaPath];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
//-(void) loadToken{
//    [SVProgressHUD showWithStatus:@"数据加载中"];
//    NSDictionary * params = @{@"username":@"admin",@"password":@"88888888"};
//    [HttpClient requestWithMethod:@"POST" path:@"http://42.159.125.221:52680/v1/api/token" parameters:params target:self success:^(NSDictionary *dic) {
//        [[NSUserDefaults standardUserDefaults]setObject:dic[@"access_token"] forKey:@"token"];
//        
//        [self loadImgInfo];
//        
//    } failue:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//    } ];
//}

//-(void) loadImgInfo{
//    NSString* path = [@"http://42.159.125.221:52680/v1/api/User/phone/" stringByAppendingString:  [Global sharedClient].phone];
//    [[HttpClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
//
//    NSDictionary * params = @{};
//    [HttpClient requestWithMethod:@"GET" path:path parameters:params target:self success:^(NSDictionary *dic) {
//        NSArray* photos =dic[@"userPhotos"];
//        if([photos count] > 0){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString* imgPath =[@"http://42.159.125.221:52680" stringByAppendingString:photos[0][@"photo"][@"path"]];
//                [_user_img setImageWithString:imgPath];
//
//            });
//        }
//        [SVProgressHUD dismiss];
//        
//    } failue:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//        [SVProgressHUD dismiss];
//    } ];
//}


- (void)_InitView{
    
    _tableView.tableHeaderView = _headerVIew;
    _tableView.tableFooterView = _footVIew;
    _user_img.layer.masksToBounds = YES;
    _user_img.layer.cornerRadius = 57;
    _enter_btn.layer.masksToBounds = YES;
    _enter_btn.layer.cornerRadius = 5;
    [_tableView registerNib:[UINib nibWithNibName:@"ChageCell" bundle:nil] forCellReuseIdentifier:@"ChageCell"];
    
    _user_img.userInteractionEnabled = YES;
    _user_img.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_user_img addGestureRecognizer:tap];
    

}



- (void)tap{

    uploadPicViewController *up = [[uploadPicViewController alloc]init];
    up.back = ^{
        
    };
    [self.navigationController pushViewController:up animated:YES];
//    CreameVC *vc = [[ CreameVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
 /*   AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus==AVAuthorizationStatusRestricted||authStatus ==AVAuthorizationStatusDenied){
        
        //无权限
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }else{
        
        uploadPicViewController *up = [[uploadPicViewController alloc]init];
        up.back = ^{
            
        };
        [self.navigationController pushViewController:up animated:YES];
        
    }*/


}

- (IBAction)next:(id)sender {
    if([_enter_btn.titleLabel.text isEqualToString:@"确认"]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self tap];
/*        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus==AVAuthorizationStatusRestricted||authStatus ==AVAuthorizationStatusDenied){
            
            //无权限
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
        }else{
            
            uploadPicViewController *up = [[uploadPicViewController alloc]init];
            up.back = ^{
                
            };
            [self.navigationController pushViewController:up animated:YES];
            
        }*/
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataAry.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChageCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ChageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title_lab.text = _dataAry[indexPath.row];
    
    if (indexPath.row < _dataAry.count-1) {
        if(valueArr.count > 0){
            cell.textFiled.text = valueArr[indexPath.row];
        }else{
            cell.textFiled.text = @"";
        }
        
    }else{
        cell.textFiled.text = @"";
    }
    
    return cell;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
