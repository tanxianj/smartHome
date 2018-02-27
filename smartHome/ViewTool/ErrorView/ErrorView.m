//
//  ErrorView.m
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "ErrorView.h"
#import <objc/runtime.h>
CGFloat const space = 24;
@interface ErrorView(){
    UIBezierPath *_bezierPath;
}

@property (nonatomic, assign) BOOL needAppear;
@end
@implementation ErrorView

+ (instancetype)loadingViewWithRefreshingBlock:(void (^)(void))refreshingBlock{
    ErrorView *view = [[ErrorView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.refreshingBlock = refreshingBlock;
    return view;
}
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _needAppear = YES;
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
    }
}

#pragma mark - Public Method
- (void)beginRefreshing{
    
    if (_needAppear == NO) {
        return;
    }
    
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    [self.activityIndicatorView startAnimating];
    self.label.hidden = YES;
    self.imageView.hidden = YES;
    self.userInteractionEnabled = NO;
}

- (void)endRefreshing{
    self.hidden = YES;
    
    _needAppear = NO;
    
    [self.activityIndicatorView stopAnimating];
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tmp = (UIScrollView *)self.superview;
        tmp.scrollEnabled = YES;
    }
}

- (void)endRefreshingWithNoDataString:(NSString *)noDataString{
    [self endRefreshingWithString:noDataString?:kNoDataPromptText image:self.noDataImage?:[UIImage imageNamed:@"page_reminding_chucuo"]];
}

- (void)endRefreshingWithErrorString:(NSString *)errorString{
    [self endRefreshingWithString:errorString?:kNetworkErrorPromptText image:self.errorImage?:[UIImage imageNamed:@"page_reminding_chucuo"]];
}

- (void)endRefreshingWithString:(NSString *)string image:(UIImage *)image{
    
    if (_needAppear == NO) {
        return;
    }
    
    self.hidden = NO;
    
    
    
    [self.superview bringSubviewToFront:self];
    
    _needAppear = YES;
    
    [self.activityIndicatorView stopAnimating];
    self.label.hidden = NO;
    self.imageView.hidden = NO;
    
    self.label.text = string;
    self.imageView.image = image;
    
    
    //FIXME: scrollEnabled, maybe there is a better way
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tmp = (UIScrollView *)self.superview;
        tmp.scrollEnabled = NO;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
    
}

#pragma mark - Pravite Method
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.superview.bounds;
    rect.origin.y += _offsetY;
    rect.size.height -= _offsetY;
    self.frame = rect;
    [self placeSubviews];
}

- (void)placeSubviews{
    
    self.activityIndicatorView.frame = self.bounds;
    
    CGSize imageViewSize = self.imageView.image.size;
    CGSize labelSize = [self.label sizeThatFits:CGSizeMake(kScreenWidth - 40, MAXFLOAT)];
    
    CGFloat startY = (self.mj_h - imageViewSize.height - space - labelSize.height)/2.f;
    
    self.imageView.frame = CGRectMake((self.mj_w - imageViewSize.width)/2.f,
                                      startY,
                                      imageViewSize.width,
                                      imageViewSize.height);
    
    self.label.frame = CGRectMake((self.mj_w - labelSize.width)/2.f,
                                  startY + imageViewSize.height + space,
                                  labelSize.width,
                                  labelSize.height);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if (_bezierPath == nil) {
        _bezierPath = [UIBezierPath bezierPathWithArcCenter:YYTextCGRectGetCenter(self.bounds) radius:100 startAngle:0 endAngle:M_PI*2 clockwise:NO];
    }
    
    if ([_bezierPath containsPoint:[touches.anyObject locationInView:self]]) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    }
    
}



#pragma mark - Views
- (UIActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.textColor = [UIColor appBlackSubColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.userInteractionEnabled = NO;
        _label.numberOfLines = 0;
        _label.preferredMaxLayoutWidth = kScreenWidth - 40;
        [self addSubview:_label];
    }
    return _label;
}

@end
const void* kLoadingViewKey = "ErrorViewKey";
@implementation UIView (ErrorView)


-(void)setError_loadingView:(ErrorView *)error_loadingView{
    if (error_loadingView != self.error_loadingView) {
        // 删除旧的，添加新的
        [self.error_loadingView removeFromSuperview];
        //        [self insertSubview:xc_loadingView atIndex:0];
        [self addSubview:error_loadingView];
        
        // 存储新的
        //        [self willChangeValueForKey:@"mj_footer"]; // KVO
        objc_setAssociatedObject(self, kLoadingViewKey, error_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //        [self didChangeValueForKey:@"mj_footer"]; // KVO
    }
}

- (ErrorView *)error_loadingView{
    return objc_getAssociatedObject(self, kLoadingViewKey);
}
@end
