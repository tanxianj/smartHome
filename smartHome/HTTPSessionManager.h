//
//  HTTPSessionManager.h
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "RespondModel.h"
typedef void(^NetworkRequestCallBack)(RespondModel *responseModel);
@interface HTTPSessionManager : AFHTTPSessionManager
// 单例
+ (instancetype)sharedManager;
// GET、POST请求
- (NSURLSessionDataTask *)GET:(NSString *)urlString  parameters:( NSDictionary *)parameters callBack:(NetworkRequestCallBack)callBack;
- (NSURLSessionDataTask *)POST:(NSString *)urlString  parameters:( NSDictionary *)parameters callBack:(NetworkRequestCallBack)callBack;

@end
