//
//  ButtonSpreadViewController.m
//  smartHome
//
//  Created by bang on 2018/2/24.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "ButtonSpreadViewController.h"
#import "WPWaveRippleView.h"
@interface ButtonSpreadViewController ()
@property (nonatomic, strong) WPWaveRippleView *waveRippleView;
@end

@implementation ButtonSpreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.waveRippleView = [[WPWaveRippleView alloc] initWithTintColor:[UIColor greenColor] minRadius:40 waveCount:5 timeInterval:.5 duration:2];
    [self.view addSubview:self.waveRippleView];
    [self.waveRippleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.centerX.equalTo(self.view);
        
        make.height.width.offset(kScreenWidth);
    }];
    
}
-(void)SetNavigation{
    self.title = @"按钮扩散";
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
