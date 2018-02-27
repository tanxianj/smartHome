//
//  PromptViewTwo.m
//  消汇邦
//
//  Created by 罗建 on 2017/2/23.
//  Copyright © 2017年 深圳消汇邦成都分公司. All rights reserved.
//

#import "PromptViewTwo.h"
#import "ViewController.h"
#import "XCToast.h"
@interface PromptViewTwo ()


@property (nonatomic, strong) UIView  *backV;
@property (nonatomic, strong) UILabel *titleLB;

@end

@implementation PromptViewTwo

#pragma mark - life cycle

#pragma mark - 显示和移除


//0922 modify by 1244

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static PromptViewTwo *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PromptViewTwo alloc]init];
    });
    return instance;
}

+ (void)promptTitle:(NSString *)title {
    [XCToast showWithMessage:title];
//    return;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wunreachable-code"
//
//    if (title.length == 0) {
//#pragma clang diagnostic pop
//        return;
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        //    NSString *oldVC = [[NSUserDefaults standardUserDefaults]objectForKey:@"oldVC"];
//        //    if ([keyWindow.rootViewController isKindOfClass:[TabBarController class]]) {
//        //        TabBarController *tabbar = (TabBarController *)keyWindow.rootViewController;
//        //        if ([tabbar.selectedViewController isKindOfClass:[NavigationController class]]) {
//        //            NavigationController *navi = (NavigationController *)tabbar.selectedViewController;
//        //            if ([navi.topViewController isKindOfClass:NSClassFromString(oldVC)]) {
//        //                return;
//        //            }else{
//        //                [[NSUserDefaults standardUserDefaults] setObject:NSStringFromClass([navi.topViewController class]) forKey:@"oldVC"];
//        //            }
//        //        }
//        //    }
//
//
//
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        style.minimumLineHeight = 18;
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                     NSParagraphStyleAttributeName:style};
//        CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX)
//                                          options:NSStringDrawingUsesLineFragmentOrigin
//                                       attributes:attributes
//                                          context:nil];
//        rect.size.width += 32;
//        rect.size.height = 34;
//
//        BOOL haveP = false;
//
//        for (UIView *subV in keyWindow.subviews) {
//
//            if ([subV isKindOfClass:[PromptViewTwo class]]) {
//                haveP = 1;
//                [subV removeFromSuperview];
//            }
//        }
//
//        PromptViewTwo *view = [[PromptViewTwo alloc] init];
//        view.backgroundColor = [UIColor clearColor];
//        if (haveP) {
//
//            view.frame = CGRectMake((kScreenWidth - rect.size.width) / 2.0,
//                                    kScreenHeight - 68 - rect.size.height,
//                                    rect.size.width,
//                                    rect.size.height);
//            view.titleLB.text = title;
//
//            [keyWindow addSubview:view];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [view remove];
//            });
//
//        }else{
//            view.frame = CGRectMake((kScreenWidth - rect.size.width) / 2.0,
//                                    kScreenHeight,
//                                    rect.size.width,
//                                    rect.size.height);
//            view.titleLB.text = title;
//
//            [keyWindow addSubview:view];
//            [UIView animateWithDuration:0.3 animations:^{
//                view.frame = CGRectMake((kScreenWidth - rect.size.width) / 2.0,
//                                        kScreenHeight - 68 - rect.size.height,
//                                        rect.size.width,
//                                        rect.size.height);
//            } completion:^(BOOL finished) {
//                if (finished) {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [view remove];
//                    });
//                }
//            }];
//        }
//    });
//
//
}

#pragma mark - private method

- (void)remove {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
    }];
}

#pragma mark - <Initialization>

- (void)initializeSubViews {
    _backV = [[UIView alloc] init];
    _backV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _backV.layer.cornerRadius = 17;
    
    _titleLB = [UILabel LableInitWith:nil LabFontSize:14.0 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    _titleLB.numberOfLines = 0;
    _titleLB.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)addSubViews {
    [self addSubview:_backV];
    [self addSubview:_titleLB];
}

- (void)setupSubViewMargins {
    [self.backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backV).insets(UIEdgeInsetsMake(8, 0, 8, 0));
    }];
}

@end
