//
//  ViewController.h
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Button.h"
#import "InitializeViwe.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
typedef NS_ENUM(NSUInteger,LeftOrRihgt) {
    Nav_Left_Item,
    Nav_Right_Item
};
@interface ViewController : UIViewController<InitializeViwe>
-(BOOL)HiddenNavView;//是否隐藏导航栏需重写此方法
-(void)SetNavigation;//初始化相关
-(void)AddBackBtn;//为视图添加返回按钮
-(BOOL)fd_interactivePopDisabled;//禁止全屏返回(pop)
-(BOOL)fd_prefersNavigationBarHidden;//禁止全屏返回(模态)
- (UIBarButtonItem *)setupNavigationItemWithLeft:(LeftOrRihgt) leftOrRight
                                       imageName:(NSString *)imageName
                                           title:(NSString *)title
                                        callBack:(ButtnBlock)buttonBlock;
@end

