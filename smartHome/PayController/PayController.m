//
//  PayController.m
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "PayController.h"
#import "PayView.h"
#import "AlertView.h"
#import "ViewControllertest1.h"

@interface PayController (){
    
}
@property (nonatomic,strong)UIButton *payBtn;
@property (nonatomic,strong)UIButton *alertBtn;
@property (nonatomic,strong)UIButton *alertBtn2;
@property (nonatomic,strong)PayView *pay;
@property (nonatomic,strong)AlertView *alert;
@property (nonatomic,strong)AlertView *alert2;
@end

@implementation PayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)SetNavigation{
    self.title = @"支付弹窗";
    [self AddBackBtn];
}
-(void)InitializeAddToSwperView{
    [self.view addSubview:self.payBtn];
    [self.view addSubview:self.alertBtn];
    [self.view addSubview:self.alertBtn2];
}
-(void)InitializeConstraintC{
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(44);
    }];
    [self.payBtn buttonGradient:@[[UIColor redColor],[UIColor blueColor]] buttonCGSize:CGSizeMake(kScreenWidth-20, 44) ByGradientType:TXJDirectionTypeLeft2Right cornerRadius:YES];
    [self.alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.payBtn.mas_top).offset(-10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(44);
    }];
    [self.alertBtn buttonGradient:@[[UIColor redColor],[UIColor blueColor]] buttonCGSize:CGSizeMake(kScreenWidth-20, 44) ByGradientType:TXJDirectionTypeLeft2Right cornerRadius:YES];
    [self.alertBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.alertBtn.mas_top).offset(-10);
        make.right.equalTo(self.view).offset(-10);
        make.height.offset(44);
    }];
    [self.alertBtn2 buttonGradient:@[[UIColor redColor],[UIColor blueColor]] buttonCGSize:CGSizeMake(kScreenWidth-20, 44) ByGradientType:TXJDirectionTypeLeft2Right cornerRadius:YES];
}
-(void)InitializeClickAction{
    [self.payBtn addTarget:self action:@selector(payView) forControlEvents:UIControlEventTouchUpInside];
    [self.alertBtn addTarget:self action:@selector(alertView) forControlEvents:UIControlEventTouchUpInside];
    [self.alertBtn2 addTarget:self action:@selector(alertView2) forControlEvents:UIControlEventTouchUpInside];
}
-(void)alertView{
    [self.alert AlertViewWithTitle:nil alertOptions:@[@"迷你摇", @"扫一扫", @"添加朋友",@"发起群聊"] didsectBlock:^(NSInteger index){
        DeBuGLog(@"result is %li",index);
        ViewControllertest1 *vc =  [[ViewControllertest1 alloc]init];
        NSArray *array = @[@"迷你摇", @"扫一扫",@"添加朋友",@"发起群聊"];
        vc.titlestr = array[index];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view.window addSubview:self.alert];

    [self.view layoutIfNeeded];
}
-(void)alertView2{
    [self.alert2 AlertViewWithTitle:@"你是否确认清理内存" alertOptions:@[@"迷你摇", @"扫一扫",@"添加朋友",@"发起群聊",@"发起群聊",@"发起群聊",@"发起群聊",@"发起群聊"] didsectBlock:^(NSInteger index) {
        ViewControllertest1 *vc =  [[ViewControllertest1 alloc]init];
        NSArray *array = @[@"迷你摇", @"扫一扫",@"添加朋友",@"发起群聊",@"发起群聊",@"发起群聊",@"发起群聊",@"发起群聊"];
        vc.titlestr = array[index];
        [self.navigationController pushViewController:vc animated:YES];
    }];
   
    [self.view.window addSubview:self.alert2];
    
    [self.view layoutIfNeeded];
}
-(void)payView{
    
   PayView* pay1 = [[PayView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight)];
    [self.view.window addSubview:pay1];
    
    [self.view layoutIfNeeded];
}
-(AlertView *)alert{
    if (!_alert) {
        _alert = [[AlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _alert;
}
-(AlertView *)alert2{
    if (!_alert2) {
        _alert2 = [[AlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _alert2;
}
-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithTitle:@"确认支付" buttonTitleFontSize:14.0 buttonTitleColor:[UIColor whiteColor] buttonBgColor:nil buttonTextAlignment:NSTextAlignmentCenter];
        
    }
    return  _payBtn;
}
-(UIButton *)alertBtn{
    if (!_alertBtn) {
        _alertBtn = [UIButton buttonWithTitle:@"显示弹出框" buttonTitleFontSize:14.0 buttonTitleColor:[UIColor whiteColor] buttonBgColor:nil buttonTextAlignment:NSTextAlignmentCenter];
        
    }
    return  _alertBtn;
}
-(UIButton *)alertBtn2{
    if (!_alertBtn2) {
        _alertBtn2 = [UIButton buttonWithTitle:@"有Title显示弹出框" buttonTitleFontSize:14.0 buttonTitleColor:[UIColor whiteColor] buttonBgColor:nil buttonTextAlignment:NSTextAlignmentCenter];
        
    }
    return  _alertBtn2;
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
