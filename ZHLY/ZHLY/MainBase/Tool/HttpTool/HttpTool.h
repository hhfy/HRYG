//
//  HttpTool.h
//  新浪微博
//
//  Created by LTWL on 2017/1/31.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface HttpTool : NSObject
/**
 *  发送一个POST请求
 *
 *  @param url              请求路径
 *  @param params           请求参数
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params isHiddeHUD:(BOOL)isHiddeHUD success:(void (^)(id json))success otherCase:(void (^)(NSInteger code))otherCase failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url              请求路径
 *  @param params           请求参数
 *  @param formDataArray    文件参数数组
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params progress:(void (^)(double uploadFileProgress))uploadFileProgress formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success otherCase:(void (^)(NSInteger code))otherCase failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url              请求路径
 *  @param params           请求参数
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params isHiddeHUD:(BOOL)isHiddeHUD progress:(void (^)(double downloadProgress))downLoadProgress success:(void (^)(id json))success otherCase:(void (^)(NSInteger code))otherCase failure:(void (^)(NSError *error))failure;

/**
 *  下载文件
 *
 *  @param url               请求路径
 *  @param downLoadProgress  下载进度
 *  @param success           请求成功后的回调
 *  @param failure           请求失败后的回调
 */
+ (void)downloadWithURL:(NSString *)url progress:(void (^)(double downloadProgress))downLoadProgress success:(void (^)(NSString *fullPath))success failure:(void (^)(NSError *error))failure;
/// 暂停下载任务
+ (void)downLoadSuspend;

/// 取消当前请求，取消将要开启的异步请求
+ (void)cancelRequeset;

/// 监听网络情况
+ (void)checkNetWork;
@end

/* 用来封装文件数据的模型 */
@interface FormData : NSObject
/// 文件数据
@property (nonatomic, strong) NSData *data;
/// 参数名
@property (nonatomic, copy) NSString *name;
/// 文件名
@property (nonatomic, copy) NSString *filename;
/// 文件类型
@property (nonatomic, copy) NSString *mimeType;
+ (instancetype)setData:(NSData *)data name:(NSString *)name mimeType:(NSString *)mimeType fileName:(NSString *)fileName;
@end
