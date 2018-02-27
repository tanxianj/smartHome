//
//  InitializeViwe.h
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InitializeViwe <NSObject>
//必须
@required

//非必须
@optional
//初始化视图
-(void)Initialize;
//设置约束
-(void)InitializeConstraintC;
//添加视图
-(void)InitializeAddToSwperView;
//点击事件
-(void)InitializeClickAction;
@end
