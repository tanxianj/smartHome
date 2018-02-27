//
//  AlertView.h
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didsectBlock)(NSInteger index);
@interface AlertView : UIView

@property (nonatomic,copy)void (^BlockIndexPath) (NSInteger indexpath);
@property (nonatomic,strong)didsectBlock didselectblock;
-(void)AlertViewWithTitle:(NSString *)title alertOptions:(NSArray *)alertOptions didsectBlock:(didsectBlock)results;
-(void)ShowPlayView;
-(void)HiddenPlayView;
@end
