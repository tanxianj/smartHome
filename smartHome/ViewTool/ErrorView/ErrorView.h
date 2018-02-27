//
//  ErrorView.h
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView
+ (nonnull instancetype)loadingViewWithRefreshingBlock:(nullable void(^)(void))refreshingBlock;
- (void)beginRefreshing;
- (void)endRefreshing;
/**
 空数据的显示，文字默认为，且不可点击
 
 @param noDataString 您暂时没有相关数据
 */
- (void)endRefreshingWithNoDataString:(nullable NSString *)noDataString;
- (void)endRefreshingWithErrorString:(nullable NSString *)errorString;


- (void)endRefreshingWithString:(nullable NSString *)string image:(nullable UIImage *)image;

@property (nonatomic, copy  ) void (^ _Nullable refreshingBlock)(void);

@property (nonatomic, strong) UIImage * _Nullable noDataImage;//Default is ""
@property (nonatomic, strong) UIImage * _Nonnull errorImage;//Default is "page_reminding_chucuo"

//偏移量
@property (nonatomic, assign) CGFloat offsetY;


@property (nonatomic, strong) UIActivityIndicatorView * _Nonnull activityIndicatorView;
@property (nonatomic, strong) UILabel * _Nonnull label;
@property (nonatomic, strong) UIImageView * _Nonnull imageView;

@end
@interface UIView (ErrorView)
@property (nonatomic, strong) ErrorView * _Nullable error_loadingView;
@end
