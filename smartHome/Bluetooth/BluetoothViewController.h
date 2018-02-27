//
//  BluetoothViewController.h
//  smartHome
//
//  Created by bang on 2018/2/12.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "ViewController.h"
@protocol BluetoothViewDelegete <NSObject>
-(void)SendFile;
@end
@interface BluetoothViewController : ViewController
@property (nonatomic,weak)id<BluetoothViewDelegete> delegate;
@end
