//
//  XCToast.m
//  消汇邦
//
//  Created by 1244 on 2017/9/26.
//  Copyright © 2017年 深圳消汇邦成都分公司. All rights reserved.
//

#import "XCToast.h"


@interface XCToast()

/**  */
@property (nonatomic, strong) NSString *message;

/**  */
@property (nonatomic, strong) NSTimer *timer;

/**  */
@property (nonatomic, assign) BOOL isOnScreen;

/**  */
//@property (nonatomic, assign) CGFloat keyboardHeight;

/**  */

@property (nonatomic, assign) NSTimeInterval duration;

/**  */
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation XCToast{
    BOOL _keyboardIsVisible;
}


#pragma mark - Public Method
+ (void)showWithMessage:(NSString *)message{
    [XCToast showWithMessage:message duration:1];
}

+ (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration{
    if (message.length == 0) {
        NSAssert(NO, @"Message can not be nil~");
        return;
    }
    XCToast *toast = [XCToast sharedInstance];
    toast.duration = duration;
    toast.message = message;
    [toast showOnScreen];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:toast];
}

#pragma mark - Private Method
- (void)showOnScreen{
    if (self.isOnScreen) {
        [[NSRunLoop currentRunLoop]cancelPerformSelector:@selector(removeFromScreen) target:self argument:nil];
    }else{
        //animation
        self.isOnScreen = YES;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.f;
            if (_keyboardIsVisible) {
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(keyWindow);
                }];
            }else{
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(keyWindow);
                    make.bottom.equalTo(keyWindow.mas_bottom).offset(-60);
                }];
            }
            
            
            [keyWindow layoutIfNeeded];
            
        } completion:^(BOOL finished) {
        }];
    }
    
    
    [self.timer invalidate];
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:_duration]
                                          interval:0
                                            target:self
                                          selector:@selector(removeFromScreen)
                                          userInfo:nil
                                           repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeFromScreen{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            self.isOnScreen = NO;
            self.contentLabel.text = @"*";
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow layoutIfNeeded];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(keyWindow);
                make.top.equalTo(keyWindow.mas_bottom);
            }];
            [keyWindow layoutIfNeeded];
        }
    }];
}

- (void)setMessage:(NSString *)message{
    _message = message;
    
    self.contentLabel.text = message;
    [self.contentLabel sizeToFit];
}


#pragma mark - Initialization
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static XCToast *toast;
    dispatch_once(&onceToken, ^{
        toast = [[XCToast alloc]init];
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:toast];
        [toast mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(keyWindow);
            make.top.equalTo(keyWindow.mas_bottom);
        }];
    });
    return toast;
}

- (instancetype)init{
    if (self = [super init]) {
        
        [self initSubviews];
        
    }
    return self;
}




- (void)initSubviews {
    self.layer.masksToBounds = YES;
    
    //base height = 34;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.6];
    
    self.contentLabel = [[UILabel alloc]init];
    
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.preferredMaxLayoutWidth = kScreenWidth - 108;
    
    self.layer.cornerRadius = (17 + 2 * 8)/2.f;
    
    [self addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
}


//Keyboard Show/Hide Method
- (void)keyboardDidShow{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide{
    _keyboardIsVisible = NO;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
