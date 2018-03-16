//
//  HomeViewController.m
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "HomeViewController.h"
#import "NetWorkingViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *tableArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    cell.textLabel.text = self.tableArray[indexPath.row][@"title"];
    cell.textLabel.frame = CGRectMake(0, 0, kScreenWidth, MAXFLOAT);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *vcstr = [NSString stringWithFormat:@"%@",self.tableArray[indexPath.row][@"Controller"]];
    ViewController *vc =(ViewController *) [[NSClassFromString(vcstr) alloc]init];

    [self.navigationController pushViewController:vc animated:YES];
}
-(void)SetNavigation{
    self.title = @"首页";
//    [self AddBackBtn];
}
-(void)Initialize{
    
}
-(void)InitializeAddToSwperView{
    [self.view addSubview:self.tableView];
}
-(void)InitializeConstraintC{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(NSArray *)tableArray{
    if (!_tableArray) {
        
        _tableArray = @[
                        @{@"title":@"网络请求提示相关",@"Controller":@"NetWorkingViewController" },
                        @{@"title":@"支付弹窗",@"Controller":@"PayController" },
                        @{@"title":@"蓝牙",@"Controller":@"BluetoothViewController" },
                        @{@"title":@"拖动排序",@"Controller":@"TouchMoveViewController" },
                        @{@"title":@"扩散按钮",@"Controller":@"ButtonSpreadViewController" },
                        @{@"title":@"扩散按钮2",@"Controller":@"KSViewController" },
                        @{@"title":@"Baby蓝牙",@"Controller":@"BabyBluetoothViewController" },
                        

                        
                        ];
    }
    return _tableArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
//        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    return _tableView;
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
