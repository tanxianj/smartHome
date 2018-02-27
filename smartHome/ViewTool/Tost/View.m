//
//  View.m
//  消汇邦
//
//  Created by 罗建 on 2017/2/22.
//  Copyright © 2017年 深圳消汇邦成都分公司. All rights reserved.
//

#import "View.h"

@implementation View

#pragma mark - life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self initialization];
//    }
//    return self;
//}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - private method

- (void)initialization {
    self.backgroundColor = [UIColor whiteColor];
    [self initializeData];
    [self initializeSubViews];
    [self addSubViews];
    [self setupSubViewMargins];
    [self addTargerts];
    [self addObservers];
}

#pragma mark - <Initialization>

- (void)initializeData {
    
}

- (void)initializeSubViews {
    
}

- (void)addSubViews {
    
}

- (void)setupSubViewMargins {
    
}

- (void)addTargerts {
    
}

- (void)addObservers {
    
}

- (void)removeObservers {
    
}

@end
