//
//  KSViewController.m
//  smartHome
//
//  Created by bang on 2018/2/24.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "KSViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface KSViewController ()

@end

@implementation KSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)SetNavigation{
    self.title = @"蓝牙";
    [self AddBackBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
