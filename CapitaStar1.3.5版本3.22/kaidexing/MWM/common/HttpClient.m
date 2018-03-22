// AFTwitterAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "HttpClient.h"
#import "Util.h"
#import "BaseViewController.h"



@implementation HttpClient

+ (HttpClient *)sharedClient {
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* webHost = [Global sharedClient ].api_host;
        _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:webHost]];
        
    });
    return _sharedClient;
}

+ (GDataXMLElement *) parseXml:(NSData *) data{
    __autoreleasing GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    //NSLog(@"xmlDoc:%@",xmlDoc);
    if([[[xmlDoc rootElement] name] isEqualToString:@"soap:Envelope"]){
        NSArray* nodes = [xmlDoc nodesForXPath:@"/soap:Envelope/soap:Body" error:nil];
        if([nodes count] > 0){
            NSString* respBody = [[nodes objectAtIndex:0] stringValue];
            //NSLog(@"respBody:%@",respBody);
            NSError * error;
            __autoreleasing GDataXMLDocument* bodyDoc =  [[GDataXMLDocument alloc] initWithXMLString:respBody options:0 error:&error];
            if(error != nil){
                NSLog(@"parseXml error:%@",error);
            }
            return [bodyDoc rootElement];
        }
    }else{
        return [xmlDoc rootElement];
    }
    return nil;
}
+ (void)requestPostWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *dic))successFunc failue:(void(^)(NSDictionary *))failueFunc
{
    HttpClient *client = [HttpClient sharedClient];
    [client POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString* msg = responseObject[@"msg"];
        NSNumber* result = responseObject[@"result"];
        id data = responseObject[@"data"];
        if([path rangeOfString:@"pingplusplus/CreateOrders"].location != NSNotFound){
            successFunc(responseObject);
            return;
        }
        if([result intValue] == API_RESULT_OK){
            successFunc(responseObject);
        }else{
            
            //[SVProgressHUD showErrorWithStatus:msg duration:2];
            failueFunc(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [client handErroMsg:error  path:path failue:failueFunc];

    }];
}
+ (void)requestWithMethod:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
                   target:(id)target
                  success:(void (^)(id dic)) successFunc
                   failue:(void (^)(id dic)) failueFunc
{
    
    HttpClient* client = [HttpClient sharedClient];
    NSLog(@"基础地址:%@",client.baseURL);
    NSLog(@"请求方式:%@,请求地址：%@,请求参数:%@",method,path,parameters);
//    if([method isEqualToString:@"PUT"]){
//        
//        client.requestSerializer = [AFJSONRequestSerializer serializer];
//        
//        [client.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
//        [client PUT:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [client handSuccessMsg:responseObject path:path success:successFunc failue:failueFunc];
//            client.requestSerializer = [AFHTTPRequestSerializer serializer];
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [client handErroMsg:error  path:path failue:failueFunc];
//            client.requestSerializer = [AFHTTPRequestSerializer serializer];
//        }];
//        return;
//        
//    }
    
    NSMutableURLRequest* request;
    
    if ([path isEqualToString:@"http://42.159.125.221:52680/v1/api/photo/identify"]) {
        NSLog(@"jkl=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
        [client.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
        [client POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            UIImage *image = (UIImage *)parameters[@"imageFiles"];
            NSData  * feedbackImg =UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:feedbackImg name:@"imageFiles"  fileName:@"imageFiles" mimeType:@"image/jpeg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [client handSuccessMsg:responseObject path:path success:successFunc failue:failueFunc];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [client handErroMsg:error  path:path failue:failueFunc];
        }];
        return;

        
    } else {
    
//         request = [client requestWithMethod:method path:path
//                                                      parameters:parameters];
        if([@"POST" isEqualToString:[method uppercaseString]]){
            
           
            client.responseSerializer = [AFJSONResponseSerializer serializer];
            [client.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            //        [client.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]] forHTTPHeaderField:@"Authorization"];
            [client POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [client handSuccessMsg:responseObject path:path success:successFunc failue:failueFunc];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               [client handErroMsg:error  path:path failue:failueFunc];
                
            }];
        }else if([@"GET" isEqualToString:[method uppercaseString]]){
            [client GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
               // [client handSuccessMsg:responseObject];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [client handSuccessMsg:responseObject path:path success:successFunc failue:failueFunc];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [client handErroMsg:error path:path failue:failueFunc];
            }];
        }
        return;

    }
  
    [NSURLConnection sendAsynchronousRequest:request queue:[client operationQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        
        
        
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString* errorMsg = nil;
        
        NSString* respCode = API_RESP_SYS_ERROR;
        
        //隐藏加载框
        if (!error && responseCode == 200)
        {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"后台返回数据---%@", dic);
        
            if([API_RESP_OK isEqualToString:[[dic valueForKey:@"result"] stringValue]]
               || [path rangeOfString:@"http://42.159.125.221:52680"].location != NSNotFound){
                successFunc(dic);
                return;
            }else{
                if([path rangeOfString:@"http://42.159.125.221:52680"].location != NSNotFound){
                    
                }else{
                    if ([dic[@"msg"] isEqualToString:@"请登录"]) {
                        return;
                    }
                    [SVProgressHUD showErrorWithStatus:dic[@"msg"] duration:2];
                }
                
                failueFunc(dic);
                return;
            }
        }
        else
        {
            errorMsg = [NSString stringWithFormat:@"%@",error];
        }
       
        if (errorMsg != nil)
        {
            NSDictionary* resultDic;
            
            if ([path isEqualToString:@"http://42.159.125.221:52680/v1/api/photo/identify"]) {
             
                resultDic = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableLeaves error:&error];
                
                
                
            } else {
            
                resultDic = [NSDictionary dictionaryWithObjectsAndKeys:respCode,@"code",errorMsg,@"msg", nil];
                
                
                if([target respondsToSelector:@selector(showMsg:)] ){
                    if ([resultDic[@"msg"] isEqualToString:@"请登录"]) {
                        return;
                    }
                    [target showMsg:resultDic[@"msg"]];
                    
                }
            }
            
            
//            if([target respondsToSelector:@selector(showMsg:)] ){
//                [target showMsg:resultDic[@"msg"]];
//                
//            }
            
            if(failueFunc){
                
                failueFunc(resultDic);
            }
        }
    }];
}

-(void) handSuccessMsg:(id) responseObject path:(NSString*) path success:(void (^)(id responseData)) successFunc failue:(void (^)(NSDictionary* dic)) failueFunc{
    
   // NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"后端返回数据:%@",responseObject);
    NSString* msg = responseObject[@"msg"];
    NSNumber* result = responseObject[@"result"];
    id data = responseObject[@"data"];
    if([path rangeOfString:@"pingplusplus/CreateOrders"].location != NSNotFound){
        successFunc(responseObject);
        return;
    }
    if([result intValue] == API_RESULT_OK){
        successFunc(responseObject);
    }else{
        //处理非标准的情况网络（第三方平台）
        if([self handOtherCondition:path responseData:responseObject]){
            successFunc(responseObject);
            return;
        }
        if(msg){
//            if (![msg isEqualToString:@"未查询到广告信息"]&&![msg isEqualToString:@"请登录"]) {
//                [SVProgressHUD showErrorWithStatus:msg duration:2];
//            }
           
        }
        
        failueFunc(responseObject);
    }
}
//处理非标准情况网络
-(bool) handOtherCondition:(NSString*) path responseData:(id) responseData{
    if([path isEqualToString:@"http://42.159.125.221:52680/v1/api/token"]
       || [path isEqualToString:@"http://42.159.125.221:52680/v1/api/photo/identify"]
       || [path isEqualToString:@"http://42.159.125.221:52680/v1/api/User"]
       || [path rangeOfString:@"http://42.159.125.221:52680/v1/api/User/phone/"].location != NSNotFound){
        return true;
    }
    return false;
}

-(void) handErroMsg:(NSError*) error path:(NSString*)path failue:(void (^)(NSDictionary* dic)) failueFunc{
    NSString* errorMsg = [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"]  encoding:NSUTF8StringEncoding];
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    id body = nil;
    if(data != nil){
        @try {
            body = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        } @finally {
            
        }
        
    }
    errorMsg = error.userInfo[@"NSLocalizedDescription"];
    if( [path isEqualToString:@"http://42.159.125.221:52680/v1/api/photo/identify"]){
        failueFunc(body);
        return;
    }
    if (errorMsg == nil){
        
    }else{
        if ([errorMsg isEqualToString:@"请登录"]) {
            return;
        }
        [SVProgressHUD showErrorWithStatus:errorMsg duration:2];
    }
    if(failueFunc){
        failueFunc(body);
    }
}



- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    
//    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
//    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
//    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
//    [params setValue:versionNum forKey:@"version"];
//    if([Global sharedClient].userId != nil){
//        [params setValue:[Global sharedClient].userId forKey:@"user"];
//    }
//    
//    if(DEBUG){
//        NSLog(@"params:%@",params);
//        NSMutableString* ms = [[NSMutableString alloc] init];
//        for(NSString* key in params.allKeys){
//            [ms appendFormat:@"%@=%@&",key,[params valueForKey:key]];
//        }
//        NSLog(@"%@%@?%@",API_HOST,path,ms);
//    }
//    
//    return [super requestWithMethod:method path:path parameters:params];
    return nil;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
//    
//    [self registerHTTPOperationClass:[AFXMLRequestOperation class]];
//    
//    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
//    [self setDefaultHeader:@"Accept" value:@"application/json"];
//    [self setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    return self;
    
}

-(void)setUp {
    self.netType = WiFiNet;
    self.netTypeString = @"WIFI";
}

/**
 *  转换成响应式请求 可重用
 *
 *  @param url   请求地址
 *  @param params 请求参数
 *
 *  @return 带请求结果（字典）的信号
 */
+ (RACSignal *)racPOSTWthURL:(NSString *)url params:(NSDictionary *)params {
//    if ([HttpClient sharedClient].netType == NONet) {
//        return [self getNoNetSignal];
//    }
    NSLog(@"<%@: %p> -post2racWthURL: %@, params: %@", self.class, self, url, params);
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        
        AFHTTPSessionManager *manager = [HttpClient sharedClient];
        NSURLSessionDataTask *operation = [manager POST:url parameters:params success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSDictionary* dic =  responseObject;
            if([dic[@"result"] intValue] != 1){
                [subscriber sendError:dic[@"msg"]];
            }else{
                [self handleResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation responseObject:responseObject];
            }
            
        }                                         failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self handleErrorResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation error:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }] setNameWithFormat:@"<%@: %p> -post2racWthURL: %@, params: %@", self.class, self, url, params];
}


+ (RACSignal *)racGETWthURL:(NSString *)url {
    return [[self racGETWthURL:url isJSON:YES] setNameWithFormat:@"<%@: %p> -get2racWthURL: %@", self.class, self, url];
}

+ (RACSignal *)racGETUNJSONWthURL:(NSString *)url {
    return [[self racGETWthURL:url isJSON:NO] setNameWithFormat:@"<%@: %p> -get2racUNJSONWthURL: %@", self.class, self, url];
}

+ (RACSignal *)racGETWthURL:(NSString *)url isJSON:(BOOL)isJSON {
    if ([HttpClient sharedClient].netType == NONet) {
        return [self getNoNetSignal];
    }
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPSessionManager *manager = [HttpClient sharedClient];
        if (!isJSON) {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        NSURLSessionDataTask *operation = [manager GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            if (!isJSON) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                return;
            }
            [self handleResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation responseObject:responseObject];
        }                                        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            if (!isJSON) {
                [subscriber sendNext:error];
                return;
            }
            [self handleErrorResultWithSubscriber:(id <RACSubscriber>) subscriber operation:operation error:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

/**
 *  响应式post请求 返回处理后的结果 对象类型 可重用
 *
 *  @param url   请求地址
 *  @param params 请求参数
 *  @param clazz  字典对应的对象
 *
 *  @return 带请求结果（对象）的信号
 */
+ (RACSignal *)racPOSTWithURL:(NSString *)url params:(NSDictionary *)params class:(Class)clazz {
    if ([HttpClient sharedClient].netType == NONet) {
        return [self getNoNetSignal];
    }
    //有网络
    return [[[[self racPOSTWthURL:url params:params] map:^id(id responseObject) {
//        if ([responseObject isKindOfClass:[NSArray class]]) {
//            return [clazz objectArrayWithKeyValuesArray:responseObject];
//        } else {
//            return [clazz objectWithKeyValues:responseObject];
//        }
        return responseObject;
    }] replayLazily] setNameWithFormat:@"<%@: %p> -racPOSTWithURL: %@, params: %@ class: %@", self.class, self, url, params, NSStringFromClass(clazz)];
}


+ (RACSignal *)racGETWithURL:(NSString *)url class:(Class)clazz {
    if ([HttpClient sharedClient].netType == NONet) {
        return [self getNoNetSignal];
    }
    //有网络
    return [[[[self racGETWthURL:url] map:^id(id responseObject) {
//        if ([responseObject isKindOfClass:[NSArray class]]) {
//            return [clazz objectArrayWithKeyValuesArray:responseObject];
//        } else {
//            return [clazz objectWithKeyValues:responseObject];
//        }
        return responseObject;
    }] replayLazily] setNameWithFormat:@"<%@: %p> -racGETWithURL: %@,class: %@", self.class, self, url, NSStringFromClass(clazz)];
}

+ (RACSignal *)getNoNetSignal {
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        'TODO';
//        /[subscriber sendError:[NSErrorHelper createErrorWithDomain:netWorkUtilsDomain code:kCFURLErrorNotConnectedToInternet]];
        return nil;
    }] setNameWithFormat:@"<%@: %p> -getNoNetSignal", self.class, self];
}

+ (void)handleErrorResultWithSubscriber:(id <RACSubscriber>)subscriber operation:(NSURLSessionDataTask *)operation error:(NSError *)error {
    NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
   // userInfo[operationInfoKey] = operation;
    'TODO';
//    /userInfo[customErrorInfoKey] = [NSErrorHelper handleErrorMessage:error];
//    [subscriber sendError:[NSErrorHelper createErrorWithUserInfo:userInfo domain:netWorkUtilsDomain]];
    [subscriber sendError:nil];
}

+ (void)handleResultWithSubscriber:(id <RACSubscriber>)subscriber operation:(NSURLSessionDataTask *)operation responseObject:(id)responseObject {
    //在此根据自己应用的接口进行统一处理
    NSLog(@"后端返回数据:%@",responseObject);
    NSString* msg = responseObject[@"msg"];
    NSNumber* result = responseObject[@"result"];
    id data = responseObject[@"data"];
    if([result intValue] == API_RESULT_OK){
        [subscriber sendNext:data];
        [subscriber sendCompleted];
        return;
    }else{

    }
    
    //示例(测试接口)
    NSInteger count = [[responseObject objectForKey:@"count"] integerValue];
    
    if (!count) {
        
    }
    
    
    //统一格式接口
    NSString * status = [responseObject objectForKey:@"status"];
    if ([status isEqualToString:@"ok"]) {
        //  [subscriber sendNext:RACTuplePack(operation,responseObject)];
        [subscriber sendNext:responseObject];
        [subscriber sendCompleted];
    } else {//正确返回，带有错误信息
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//        userInfo[operationInfoKey] = operation;
        BOOL isError = [status isEqualToString:@"error"];
        'TODO';
//        NSString * errorInfo = isError ? [responseObject objectForKey:@"error"] : @"请求没有得到处理";
//        userInfo[customErrorInfoKey] = errorInfo;
//        NSError * error = [NSErrorHelper createErrorWithUserInfo:userInfo domain:netWorkUtilsDomain];
//        [subscriber sendError:error];
        [subscriber sendError:nil];

    }
}



@end
