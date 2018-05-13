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

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Const.h"
#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"

enum {
    XMLParameterEncoding = 10
};

typedef NS_ENUM(NSInteger, NetType) {
    NONet,
    WiFiNet,
    OtherNet,
};

static NSString* XML_PARAM = @"XML_PARAM";
@interface HttpClient : AFHTTPSessionManager

@property(nonatomic, assign) NSInteger netType;

@property(nonatomic, strong) NSString *netTypeString;

+ (HttpClient *)sharedClient;


+ (GDataXMLElement *) parseXml:(NSData *) data;

+ (void)requestPostWithPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary *dic))successFunc failue:(void(^)(NSDictionary *))failueFunc;
+ (void)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
                                    target:(id)target
                                   success:(void (^)(NSDictionary* dic)) successFunc
                                   failue:(void (^)(NSDictionary* dic)) failueFunc;

+ (void)requestWithMethodXML:(NSString *)method
                     path:(NSString *)path
               parameters:(NSDictionary *)parameters
                   target:(id)target
                  success:(void (^)(GDataXMLElement* dic)) successFunc
                   failue:(void (^)(GDataXMLElement* dic)) failueFunc;

+ (void)requestByAbsoluteUrl:url
                  parameters:(NSDictionary *)parameters
                      target:(id)target
                     success:(void (^)(NSData* data)) successFunc
                      failue:(void (^)(NSData* data)) failueFunc;


- (void)startMonitoring;

- (RACSignal *)startMonitoringNet;

+ (RACSignal *)racPOSTWthURL:(NSString *)url params:(NSDictionary *)params;

+ (RACSignal *)racPOSTWithURL:(NSString *)url params:(NSDictionary *)params class:(Class)clazz;

+ (RACSignal *)racGETUNJSONWthURL:(NSString *)url;

+ (RACSignal *)racGETWthURL:(NSString *)url;

+ (RACSignal *)racGETWithURL:(NSString *)url class:(Class)clazz;
@end
