//
//  YQNetworking.m
//  YQNetworking
//
//  Created by yingqiu huang on 2017/2/10.
//  Copyright © 2017年 yingqiu huang. All rights reserved.
//

#import "YQNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YQNetworking+RequestManager.h"
#import "YQCacheManager.h"
#import "YQNetworkingCodeCheck.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+AFNetworking.h"
#import "MacroDefinition.h"
#import "MBProgressHUD.h"

#define YQ_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define YQ_ERROR [NSError errorWithDomain:@"com.hyq.YQNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:YQ_ERROR_IMFORMATION}]

static NSMutableArray   *requestTasksPool;

static NSDictionary     *headers;

static YQNetworkStatus  networkStatus;

static NSTimeInterval   requestTimeout = 20.f;

@interface YQNetworking()

@end

@implementation YQNetworking

#pragma mark - manager
+ (AFHTTPSessionManager *)manager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@""]];
    
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    /// 单例中添加安全策略,及允许无效证书访问
    //    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //    AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    [security setValidatesDomainName:NO];
    //    security.allowInvalidCertificates = YES;
    //    manager.securityPolicy = security;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            //将token封装入请求头
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    
    //设置安全政策
    [manager setSecurityPolicy:[self customSecurityPolicy]];
//
//    //校验证书=验证证书；
    [self checkCredential:manager];
    
    
    [self checkNetworkStatus];
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[YQCacheManager shareManager] setCacheTime: diskCapacity:]设置
    [[YQCacheManager shareManager] clearLRUCache];
    
    return manager;
}

#pragma mark - HTTPS校验
//校验服务器-证书;
+ (AFSecurityPolicy*)customSecurityPolicy
{
    AFSecurityPolicy*securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];//AFSSLPinningModeCertificate－校验证书的方式；
    /**AFSSLPinningModeCertificate=除了公钥外，其他内容也要一致才能通过验证---必须有服务器的证书才可以通过认证
     **AFSSLPinningModePublicKey=只验证公钥部分，只要公钥部分一致就验证通过---必须有服务器的证书才可以通过认证；也就是即使服务器证书有所变动，只要公钥不变，就能通过认证。
     **AFSSLPinningModeNone=不做任何验证，只要服务器返回了证书就通过-，也就是你不必将认证证书跟你的APP一起打包；
     */
    //tomcat1(1)－服务器的证书
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"chargerserver" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSSet  *dataSet = [NSSet setWithArray:@[certData]];
    //是否信任服务器无效或过期的SSL证书。默认为“不”---这个参数是校验证书过期+是否是CA认证有效的()
    //经测试：设置为“NO”自签名的证书认证失败，百度等第三方的证书认证成功！-系统在验证到根证书时，发现它是自签名、不可信的。
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setPinnedCertificates:dataSet];
    //是否验证域名证书的CN字段。默认为“是”
    [securityPolicy setValidatesDomainName:NO];
    return securityPolicy;
}
//校验证书=验证证书；
+ (void)checkCredential:(AFURLSessionManager *)manager
{
    [manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
//        NSLog(@"setSessionDidBecomeInvalidBlock");
    }];
    __weak typeof(manager)weakManager = manager;
    
    // 该方法的作用就是处理服务器返回的证书, 需要在该方法中告诉系统是否需要安装服务器返回的证书
    // NSURLAuthenticationChallenge : 授权质问
    //+ 受保护空间
    //+ 服务器返回的证书类型
    //验证证书
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        //第一个参数：challenge 代表如何处理证书
        //第二个参数: NSURLCredential 代表需要处理哪个证书
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
//        NSLog(@"authenticationMethod=%@",challenge.protectionSpace.authenticationMethod);
        //判断是核验客户端证书还是服务器证书--------//判断服务器返回的证书是否是服务器信任的
        // 1.从服务器返回的受保护空间中拿到证书的类型
        // 2.判断服务器返回的证书是否是服务器信任的
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {//--客户端验证方法服务器信任
            
            // 基于客户端的安全策略来决定是否信任该服务器，不信任的话，也就没必要响应
            // AFNewworking判断服务器证书是否有效
            if([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
//                NSLog(@"是服务器信任的证书");
                // 创建挑战证书（注：挑战方式为UseCredential和PerformDefaultHandling都需要新建挑战证书）
                NSLog(@"serverTrust=%@",challenge.protectionSpace.serverTrust);
                //创建质询证书-------//创建证书---------
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                // 确定挑战的方式－－－//确认质询方式
                if (credential) {
                    //证书挑战  设计policy,none，则跑到这里
                    disposition = NSURLSessionAuthChallengeUseCredential;//使用指定的凭据,这可能是零
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;//默认处理挑战——如果没有这个委托实施;凭证参数被忽略
                }
            } else {
//                NSLog(@"不是服务器信任的证书 整个请求将被取消,凭证参数被忽略");
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;//整个请求将被取消,凭证参数被忽略
            }
        }
        else {
            // client authentication-客户端身份验证
            SecIdentityRef identity = NULL;//p12数据中提取identity和trustobjects（可信任对象），并评估其可信度。
            SecTrustRef trust = NULL;//评估证书。这里的信任对象（trustobject），包括信任策略和其他用于判断证书是否可信的信息，都已经含在了PKCS数据中。要单独评估一个证书是否可信
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:p12])
            {
                NSLog(@"client.p12:not exist");
            }
            else
            {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                if ([self extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
                {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity,&certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition =NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        *_credential = credential;
        
        return disposition;
    }];
}

//读取p12文件中的密码
+ (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    //构造包含了密码的dictionary，用于传递给SecPKCS12Import函数。注意这里使用的是core foundation中的CFDictionaryRef，与NSDictionary完全等价
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"NrV0aSiY2zCewHJ0"
                                       
                                                                  forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwitherror code %d",(int)securityError);
        
        return NO;
    }
    return YES;
}

#pragma mark - 检查网络
+ (void)checkNetworkStatus {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                networkStatus = YQNetworkStatusNotReachable;
                [self showNetWorkErrorAlert];
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
            {
                networkStatus = YQNetworkStatusUnknown;
                [self showNetWorkErrorAlert];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                networkStatus = YQNetworkStatusReachableViaWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                networkStatus = YQNetworkStatusReachableViaWiFi;
            }
                break;
            default:
                networkStatus = YQNetworkStatusUnknown;
                break;
        }
        
    }];
}

/// 全局展示网络错误遮罩
+ (void)showNetWorkErrorAlert
{
//    HUDMAKE(NSLocalizedString(@"网络异常，请检查网络连接", nil));
}

+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasksPool == nil) requestTasksPool = [NSMutableArray array];
    });
    
    return requestTasksPool;
}

#pragma mark - get
+ (YQURLSessionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary *)params
                   progressBlock:(YQGetProgress)progressBlock
                    successBlock:(YQResponseSuccessBlock)successBlock
                       failBlock:(YQResponseFailBlock)failBlock {
    //将session拷贝到堆中，block内部才可以获取得到session
    __block YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR, nil);
        return session;
    }
    
    id responseObj = [[YQCacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj);
    }
    
    session = [manager GET:url
                parameters:params
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount,
                                                       downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      
                      if (cache) [[YQCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
                      
                      [[self allTasks] removeObject:session];
                      
                      /// 添加code码判断
                      if ([YQNetworkingCodeCheck checkCodeResponseObject:responseObject]) {
                          if (successBlock) successBlock(responseObject);
                      } else {
                          failBlock(nil, responseObject);
                      }
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      //取消网络请求
                      if (error.code == -999) {
                          return ;
                      }
                      
                      if (error.code != -999) {
                          /// 连接错误提示
//                          [[UIApplication sharedApplication].keyWindow makeToast:NSLocalizedString(@"无法连接到服务器，请稍后重试", nil)];
                      }
                      
                      if (failBlock) failBlock(error, nil);

                      [[self allTasks] removeObject:session];
                      
                  }];
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        //取消新请求
        [session cancel];
        return session;
    }else {
        //无论是否有旧请求，先执行取消旧请求，反正都需要刷新请求
        YQURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

#pragma mark - post
+ (YQURLSessionTask *)postWithUrl:(NSString *)url
                   refreshRequest:(BOOL)refresh
                            cache:(BOOL)cache
                           params:(NSDictionary *)params
                    progressBlock:(YQPostProgress)progressBlock
                     successBlock:(YQResponseSuccessBlock)successBlock
                        failBlock:(YQResponseFailBlock)failBlock {
    __block YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR, nil);
        return session;
    }
    
    id responseObj = [[YQCacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:params];
    
    if (responseObj && cache) {
        if (successBlock) successBlock(responseObj);
    }
    
    session = [manager POST:url
                 parameters:params
                   progress:^(NSProgress * _Nonnull uploadProgress) {
                       if (progressBlock) progressBlock(uploadProgress.completedUnitCount,
                                                        uploadProgress.totalUnitCount);
                       
                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                       /// 添加code码判断
                       if ([YQNetworkingCodeCheck checkCodeResponseObject:responseObject]) {
                           if (successBlock) successBlock(responseObject);
                       } else {
                           failBlock(nil, responseObject);
                       }
                       
                       if (cache) [[YQCacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:params];
                       
                       if ([[self allTasks] containsObject:session]) {
                           [[self allTasks] removeObject:session];
                       }
                       
                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       
                       //取消网络请求
                       if (error.code == -999) {
                           return ;
                       }
                       if (error.code != -999) {
                           /// 连接错误提示
//                           [[UIApplication sharedApplication].keyWindow makeToast:NSLocalizedString(@"无法连接到服务器，请稍后重试", nil)];
                       }
                       if (failBlock) failBlock(error, nil);

                       
                       [[self allTasks] removeObject:session];
                       
                   }];
    
    
    if ([self haveSameRequestInTasksPool:session] && !refresh) {
        [session cancel];
        return session;
    }else {
        YQURLSessionTask *oldTask = [self cancleSameRequestInTasksPool:session];
        if (oldTask) [[self allTasks] removeObject:oldTask];
        if (session) [[self allTasks] addObject:session];
        [session resume];
        return session;
    }
}

+ (YQURLSessionTask *)postWithActionURL:(NSString *)actionURL
                                 params:(NSDictionary *)params
                           successBlock:(YQResponseSuccessBlock)successBlock
                              failBlock:(YQResponseFailBlock)failBlock
{
    return [self postWithUrl:actionURL refreshRequest:NO cache:NO params:params progressBlock:nil successBlock:successBlock failBlock:failBlock];
}

#pragma mark - 文件上传
+ (YQURLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileData:(NSData *)data
                                   type:(NSString *)type
                                   name:(NSString *)name
                               mimeType:(NSString *)mimeType
                          progressBlock:(YQUploadProgressBlock)progressBlock
                           successBlock:(YQResponseSuccessBlock)successBlock
                              failBlock:(YQResponseFailBlock)failBlock {
    __block YQURLSessionTask *session = nil;
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) failBlock(YQ_ERROR, nil);
        return session;
    }
    
    session = [manager POST:url
                 parameters:nil
  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      NSString *fileName = nil;
      
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = @"yyyyMMddHHmmss";
      
      NSString *day = [formatter stringFromDate:[NSDate date]];
      
      fileName = [NSString stringWithFormat:@"%@.%@",day,type];
      
      [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
      
  } progress:^(NSProgress * _Nonnull uploadProgress) {
      if (progressBlock) progressBlock (uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
      
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      
      if (successBlock) successBlock(responseObject);
      [[self allTasks] removeObject:session];
      
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      if (failBlock) failBlock(error, nil);
      [[self allTasks] removeObject:session];
      
  }];
    
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
}

#pragma mark - 多文件上传
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                     progressBlock:(YQUploadProgressBlock)progressBlock
                      successBlock:(YQMultUploadSuccessBlock)successBlock
                         failBlock:(YQMultUploadFailBlock)failBlock {
    
    [self checkNetworkStatus];
    
    if (networkStatus == YQNetworkStatusNotReachable) {
        if (failBlock) failBlock(@[YQ_ERROR]);
        return nil;
    }
    
    __block NSMutableArray *sessions = [NSMutableArray array];
    __block NSMutableArray *responses = [NSMutableArray array];
    __block NSMutableArray *failResponse = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    NSInteger count = datas.count;
    for (int i = 0; i < count; i++) {
        __block YQURLSessionTask *session = nil;
        
        dispatch_group_enter(uploadGroup);
        
        session = [self uploadFileWithUrl:url
                                 fileData:datas[i]
                                     type:type name:name
                                 mimeType:mimeTypes
                            progressBlock:^(int64_t bytesWritten, int64_t totalBytes) {
                                if (progressBlock) progressBlock(bytesWritten,
                                                                 totalBytes);
                                
                            } successBlock:^(id response) {
                                [responses addObject:response];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                                
                            } failBlock:^(NSError *error, id response) {
                                NSError *Error = [NSError errorWithDomain:url code:-999 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"第%d次上传失败",i]}];
                                
                                [failResponse addObject:Error];
                                
                                dispatch_group_leave(uploadGroup);
                                
                                [sessions removeObject:session];
                            }];
        
        [session resume];
        
        if (session) [sessions addObject:session];
    }
    
    [[self allTasks] addObjectsFromArray:sessions];
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (responses.count > 0) {
            if (successBlock) {
                successBlock([responses copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
        if (failResponse.count > 0) {
            if (failBlock) {
                failBlock([failResponse copy]);
                if (sessions.count > 0) {
                    [[self allTasks] removeObjectsInArray:sessions];
                }
            }
        }
        
    });
    
    return [sessions copy];
}

#pragma mark - 下载
+ (YQURLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(YQDownloadProgress)progressBlock
                         successBlock:(YQDownloadSuccessBlock)successBlock
                            failBlock:(YQDownloadFailBlock)failBlock {
    NSString *type = nil;
    NSArray *subStringArr = nil;
    __block YQURLSessionTask *session = nil;
    
    NSURL *fileUrl = [[YQCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
    
    if (fileUrl) {
        if (successBlock) successBlock(fileUrl);
        return nil;
    }
    
    if (url) {
        subStringArr = [url componentsSeparatedByString:@"."];
        if (subStringArr.count > 0) {
            type = subStringArr[subStringArr.count - 1];
        }
    }
    
    AFHTTPSessionManager *manager = [self manager];
    //响应内容序列化为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session = [manager GET:url
                parameters:nil
                  progress:^(NSProgress * _Nonnull downloadProgress) {
                      if (progressBlock) progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (successBlock) {
                          NSData *dataObj = (NSData *)responseObject;
                          
                          [[YQCacheManager shareManager] storeDownloadData:dataObj requestUrl:url];
                          
                          NSURL *downFileUrl = [[YQCacheManager shareManager] getDownloadDataFromCacheWithRequestUrl:url];
                          
                          successBlock(downFileUrl);
                      }
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failBlock) {
                          failBlock (error, nil);
                      }
                  }];
    
    [session resume];
    
    if (session) [[self allTasks] addObject:session];
    
    return session;
    
}

#pragma mark - other method
+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(YQURLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YQURLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(YQURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[YQURLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}

+ (NSArray *)currentRunningTasks {
    return [[self allTasks] copy];
}

@end

@implementation YQNetworking (cache)
+ (NSUInteger)totalCacheSize {
    return [[YQCacheManager shareManager] totalCacheSize];
}

+ (NSUInteger)totalDownloadDataSize {
    return [[YQCacheManager shareManager] totalDownloadDataSize];
}

+ (void)clearDownloadData {
    [[YQCacheManager shareManager] clearDownloadData];
}

+ (NSString *)getDownDirectoryPath {
    return [[YQCacheManager shareManager] getDownDirectoryPath];
}

+ (NSString *)getCacheDiretoryPath {
    
    return [[YQCacheManager shareManager] getCacheDiretoryPath];
}

+ (void)clearTotalCache {
    [[YQCacheManager shareManager] clearTotalCache];
}



@end
