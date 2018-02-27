//
//  NetWorkingViewController.m
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "NetWorkingViewController.h"

@interface NetWorkingViewController ()
@property (nonatomic,strong)UILabel *hongbao_remain;
@end

@implementation NetWorkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.error_loadingView = [ErrorView loadingViewWithRefreshingBlock:^{
        [self lodData];
    }];
    [self lodData];
}
-(void)lodData{
    [self.view.error_loadingView beginRefreshing];
    [[HTTPSessionManager sharedManager]GET:@"hongbao/exchangeInfo" parameters:@{@"source":@"home"} callBack:^(RespondModel *responseModel) {
        DeBuGLog(@"code is %li desc is %@",responseModel.code,responseModel.desc);
        if (responseModel.code==200) {
            
            self.hongbao_remain.text = responseModel.data[@"hongbao_remain"];
            [self.view.error_loadingView endRefreshing];
        }else{
            [self.view.error_loadingView endRefreshingWithErrorString:responseModel.desc];
        }
    }];
}
-(UILabel *)hongbao_remain{
    if (!_hongbao_remain) {
        _hongbao_remain = [[UILabel alloc]init];
        _hongbao_remain.textAlignment = NSTextAlignmentCenter;
        _hongbao_remain.textColor = [UIColor redColor];
        _hongbao_remain.font = [UIFont systemFontOfSize:14.0];
    }
    return _hongbao_remain;
}
-(void)SetNavigation{
    self.title = @"网络请求";
    [self AddBackBtn];
}
-(void)InitializeAddToSwperView{
    [self.view addSubview:self.hongbao_remain];
}
-(void)InitializeConstraintC{
    [self.hongbao_remain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view).offset(0);
        make.height.offset(30);
    }];
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
