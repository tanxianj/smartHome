//
//  RespondModel.m
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "RespondModel.h"

NSString *const kRespondCode = @"code";
NSString *const kRespondData = @"data";
NSString *const kRespondDesc = @"desc";
@implementation RespondModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kRespondCode] isKindOfClass:[NSNull class]]){
        self.code = [dictionary[kRespondCode] integerValue];
    }
    
    if(![dictionary[kRespondData] isKindOfClass:[NSNull class]]){
        self.data = dictionary[kRespondData];
    }
    
    if(![dictionary[kRespondDesc] isKindOfClass:[NSNull class]]){
        self.desc = dictionary[kRespondDesc];
    }
    return self;
}

@end
