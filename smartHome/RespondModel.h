//
//  RespondModel.h
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, RespondCode) {
    RespondCodeError        = -1,
    RespondCodeSuccess      = 200,
    RespondCodeUnauthorized = 801,
    RespondCodeNotJson      = 3840,
    RespondCodeAlert        = 802
    
};

@interface RespondModel : NSObject

@property (nonatomic, assign) RespondCode code;
@property (nonatomic, copy  ) NSString  *desc;
@property (nonatomic, strong) id        data;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
