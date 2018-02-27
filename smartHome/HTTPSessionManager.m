//
//  HTTPSessionManager.m
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "HTTPSessionManager.h"
#define OSTYPE  @"iOS"
#import "AppDelegate.h"

@implementation HTTPSessionManager
static dispatch_once_t onceToken;
static HTTPSessionManager *manager;
NSString *const kNetworkBuildNumber = @"20180129";
+ (instancetype)sharedManager {
    dispatch_once(&onceToken, ^{
        
        
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isRelease"]) {
            manager                                           = [[HTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.app.xiaohuibang.com"]];
        }else{
            manager                                           = [[HTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://api.app.xiaohuibang.cn"]];
        }
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.requestSerializer.timeoutInterval         = 30.f;
        // 上传版本号
//        NSString *version                                 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *version = @"2.8.0";
        [manager.requestSerializer setValue:version ? version : @"" forHTTPHeaderField:@"VERSION"];
        
        // 上传约定Build号
        [manager.requestSerializer setValue:kNetworkBuildNumber     forHTTPHeaderField:@"BUILD"];
        
        //
        [manager.requestSerializer setValue:OSTYPE                  forHTTPHeaderField:@"OS"];
        
        // 上传用户Token
        
    });
//    NSString *token                                   = [UserModel sharedUserModel].token;
    NSString *token = @"fc322daa483a373f8f6702eef89b420a";
    [manager.requestSerializer setValue:token ? token : @""     forHTTPHeaderField:@"TOKEN"];
    return manager;
}
// GET请求
- (NSURLSessionDataTask *)GET:(NSString *)urlString
                   parameters:( NSDictionary *)parameters
                     callBack:(NetworkRequestCallBack)callBack{
    return [self GET:urlString
          parameters:parameters
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable  responseObject) {
                 
                 DeBuGLog(@"%@\n%@\n%@",urlString,parameters,responseObject);
                 [self handleRespond:responseObject
                               error:nil
                            callBack:callBack];
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 [self handleRespond:nil
                               error:error
                            callBack:callBack];
                 DeBuGLog(@"%@\n%@\n%@",urlString,parameters,error);
                 
             }];
}
//POST请求
- (NSURLSessionDataTask *)POST:(NSString *)urlString
                    parameters:( NSDictionary *)parameters
                      callBack:(NetworkRequestCallBack)callBack{
    return [self POST:urlString
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  DeBuGLog(@"✅%@\n%@\n%@",urlString,parameters,responseObject);
                  [self handleRespond:responseObject
                                error:nil
                             callBack:callBack];
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSAssert(NO, @"NetworkError");
                  DeBuGLog(@"❌%@\n%@\n%@",urlString,parameters,error);
                  [self handleRespond:nil
                                error:error
                             callBack:callBack];
                  
              }];
}

/**
 处理网络请求的成功和失败
 
 @param responseObject 相应的数据
 @param error 错误，可为空
 @param callBack 返回RespondModel
 */
- (void)handleRespond:(id)responseObject error:(NSError *)error callBack:(NetworkRequestCallBack)callBack{
    if (!error) {
        RespondModel *model = [[RespondModel alloc]initWithDictionary:responseObject];
        
        //处理验证失败
        if (model.code == RespondCodeUnauthorized) {
            
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            [appDelegate exit];
            
        }else if (model.code == RespondCodeAlert){
            
            //当前页面弹出框
            /*
            BottomAlertModel *alertModel = [[BottomAlertModel alloc]initWithDictionary:model.data];
            BottomAlertViewController *vc = [[BottomAlertViewController alloc]initWithBottomAlertModel:alertModel];
            [[UIViewController getCurrentVC]presentViewController:vc animated:NO completion:nil];
            */
        }else{
            
            callBack(model);
            
        }
        
    }else{
        RespondModel *model = [[RespondModel alloc] init];
        if (error.code == 3840) {
            model.code          = RespondCodeNotJson;
            model.desc          = @"服务器开小差，请稍后再试";
        }else if (error.code == -1001){
            model.code          = RespondCodeError;
            model.desc          = @"请求超时，请重试";
        }else{
            model.code          = RespondCodeError;
            model.desc          = kNetworkErrorPromptText;
        }
        callBack(model);
    }
    
}
@end
