//
//  ViewControllertest1.m
//  smartHome
//
//  Created by bang on 2018/2/10.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "ViewControllertest1.h"

@interface ViewControllertest1 ()

@end

@implementation ViewControllertest1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)SetNavigation{
    self.title = self.titlestr;
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
