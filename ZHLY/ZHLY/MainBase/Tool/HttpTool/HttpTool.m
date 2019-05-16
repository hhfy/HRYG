 //
//  HttpTool.m
//
//  Created by LTWL on 2017/1/31.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import "HttpTool.h"
#import "LoginVC.h"

#define NetworkActivity     [UIApplication sharedApplication].networkActivityIndicatorVisible
#define NetworkUnavailable  [SVProgressHUD showError:@"网络异常"];
#define NetworkLoadding     [SVProgressHUD showMessage:@"加载中……"];
#define NetworkLoaded       [SVProgressHUD dismiss];

@implementation HttpTool

static AFHTTPSessionManager *_mgr;
static NSURLSessionDownloadTask *_downloadTask;
static NSURLSessionDataTask *_getDataTask;
static NSURLSessionDataTask *_postDataTask;

+ (AFHTTPSessionManager *)mgr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mgr = [AFHTTPSessionManager manager];
        [_mgr.requestSerializer setTimeoutInterval:30];
        _mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                               @"text/html",
                                                                               @"text/json",
                                                                               @"text/javascript",
                                                                               @"text/plain", nil];
    });
    return _mgr;
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params isHiddeHUD:(BOOL)isHiddeHUD success:(void (^)(id json))success otherCase:(void (^)(NSInteger code))otherCase failure:(void (^)(NSError *error))failure
{
    NetworkActivity = YES;
    if (!isHiddeHUD) NetworkLoadding
    _postDataTask = [self.mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NetworkLoaded
        NetworkActivity = NO;
        Log(@"%@", responseObject);
        
        if ([[NSString stringWithFormat:@"%@", responseObject[Code]]  isEqualToString:Code200] || [[responseObject[Code] description] isEqualToString:Code300]) {
            if (success) success(responseObject);
        } else if ([[responseObject[Code] description] isEqualToString:Code401]) {
            OutlineHandel
            if (otherCase) otherCase([responseObject[Code] integerValue]);
        }
//            else if ([[responseObject[Code] description] isEqualToString:Code300]) { //无数据
//            //            OutlineHandel
//            if (otherCase) otherCase([responseObject[Code] integerValue]);
//        }
        else {
            if (otherCase) otherCase([responseObject[Code] integerValue]);
            [SVProgressHUD showError:responseObject[Message]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NetworkLoaded
            NetworkActivity = NO;
            NetworkUnavailable
//            if([error code] == NSURLErrorCancelled) {
//                return;
//            }
            failure(error);
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) Log(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
}


+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params progress:(void (^)(double uploadFileProgress))uploadFileProgress formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success otherCase:(void (^)(NSInteger code))otherCase failure:(void (^)(NSError *error))failure
{
    NetworkActivity = YES;
    [SVProgressHUD show];
    _postDataTask = [self.mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (FormData *data in formDataArray) {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double progress = (double)uploadProgress.completedUnitCount /uploadProgress.totalUnitCount;
            [SVProgressHUD showProgress:progress loaddingMsg:nil doneMsg:nil];
            if (uploadFileProgress) uploadFileProgress(progress);
        });
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NetworkActivity = NO;
        NetworkLoaded
        if ([[responseObject[Code] description] isEqualToString:Code200] || [[responseObject[Code] description] isEqualToString:Code300]) {
            if (success) success(responseObject);
        } else if ([[responseObject[Code] description] isEqualToString:Code401]) {
            OutlineHandel
            if (otherCase) otherCase([responseObject[Code] integerValue]);
        } else {
            if (otherCase) otherCase([responseObject[Code] integerValue]);
            [SVProgressHUD showError:responseObject[Message]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NetworkLoaded
            NetworkActivity = NO;
            NetworkUnavailable
            failure(error);
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) Log(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params isHiddeHUD:(BOOL)isHiddeHUD progress:(void (^)(double downloadProgress))downLoadProgress success:(void (^)(id json))success otherCase:(void (^)(NSInteger code))otherCase failure:(void (^)(NSError *error))failure
{
    NetworkActivity = YES; 
    if (!isHiddeHUD) NetworkLoadding
    _getDataTask = [self.mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double progress = (double)downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            if (downLoadProgress) downLoadProgress(progress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NetworkActivity = NO;
        NetworkLoaded
        Log(@"%@", responseObject);
        if ([[responseObject[Code] description] isEqualToString:Code200] || [[responseObject[Code] description] isEqualToString:Code300]) {
            if (success) success(responseObject);
        } else if ([[responseObject[Code] description] isEqualToString:Code401]) {
            OutlineHandel
            if (otherCase) otherCase([responseObject[Code] integerValue]);
        }
//        else if ([[responseObject[Code] description] isEqualToString:Code300]) { //无数据
////            OutlineHandel
//            if (otherCase) otherCase([responseObject[Code] integerValue]);
//        }
        else {
            if (otherCase) otherCase([responseObject[Code] integerValue]);
            [SVProgressHUD showError:responseObject[Message]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NetworkActivity = NO;
            NetworkLoaded
            NetworkUnavailable
            failure(error);
            NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
            if (data) Log(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
}

+ (void)downloadWithURL:(NSString *)url progress:(void (^)(double downloadProgress))downLoadProgress success:(void (^)(NSString *fullPath))success failure:(void (^)(NSError *error))failure {
    if (_downloadTask.state == NSURLSessionTaskStateSuspended) {
        [_downloadTask resume];
    }  else {
        _downloadTask = [self.mgr downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                double progress = (double)downloadProgress.completedUnitCount /downloadProgress.totalUnitCount;
                if (downLoadProgress) downLoadProgress(progress);
            });
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:fullPath];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                if (failure) failure(error);
                NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                if (data) Log(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            } else {
                if (success) success(filePath.absoluteString);
            }
        }];
        [_downloadTask resume];
    }
}

+ (void)downLoadSuspend {
    [_downloadTask suspend];
}

+ (void)cancelRequeset {
    [_mgr.operationQueue cancelAllOperations];
    [_getDataTask cancel];
    [_postDataTask cancel];
}

+ (void)checkNetWork {
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候就调用
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [MBProgressHUD showSuccess:@"已连接WIFI"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworkForWIFINotification object:nil];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                [MBProgressHUD showSuccess:@"已连接蜂窝网络"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworkForWWANNotification object:nil];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [[NSNotificationCenter defaultCenter] postNotificationName:NetworkForInterruptNotification object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD showError:@"网络似乎出现问题"];
                });
                break;
            case AFNetworkReachabilityStatusUnknown:
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showError:@"未知网络"];
                });
                break;
        }
    }];
    [mgr startMonitoring];
}

- (void)dealloc {
    [[AFNetworkReachabilityManager sharedManager]  stopMonitoring];
}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation FormData
+ (instancetype)setData:(NSData *)data name:(NSString *)name mimeType:(NSString *)mimeType fileName:(NSString *)fileName {
    FormData *formData = [[FormData alloc] init];
    formData.data = data;
    formData.name = name;
    formData.mimeType = mimeType;
    formData.filename = fileName;
    return formData;
}
@end
