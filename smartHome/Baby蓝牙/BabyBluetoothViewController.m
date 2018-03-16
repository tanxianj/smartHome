//
//  BabyBluetoothViewController.m
//  smartHome
//
//  Created by bang on 2018/2/27.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "BabyBluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface BabyBluetoothViewController ()<UITableViewDelegate,UITableViewDataSource>{
     BabyBluetooth *baby;
}
@property (strong , nonatomic) UITableView *tableView;
@property (strong , nonatomic) NSMutableArray *BleViewPerArr;
@end

@implementation BabyBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态
    baby.scanForPeripherals().begin();
    [self.view addSubview:self.tableView];
}
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    //设置扫描到设备的委托
    __weak typeof(self) wekself = self;
    wekself.BleViewPerArr = [NSMutableArray arrayWithCapacity:10];
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        
        //如果从搜索到的设备中找到指定设备名，和BleViewPerArr数组没有它的地址
        //加入BleViewPerArr数组
        if (peripheral == nil||peripheral.identifier == nil/*||peripheral.name == nil*/)
        {
            return;
        }
        NSString *pername=[NSString stringWithFormat:@"%@",peripheral.name];
        
        //判断是否存在@"你的设备名"
        NSRange range=[pername rangeOfString:@"SmartHome"];
        if(range.location&&![_BleViewPerArr containsObject:peripheral]&&peripheral.name){
            DeBuGLog(@"\n pername is %@ \n peripheral is %@--\n--%@",pername,peripheral,peripheral.identifier.UUIDString);
            
            [wekself.BleViewPerArr addObject:peripheral];
            [wekself.tableView reloadData];
        }
    }];
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //过滤器
    //设置查找设备的过滤器
//    [baby setDiscoverPeripheralsFilter:^BOOL(NSString *peripheralsFilter) {
//        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
//        if (peripheralsFilter.length >1) {
//            return YES;
//        }
//        return NO;
//    }];
    //
    [baby setFilterOnDiscoverPeripheralsAtChannel:@"" filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
    
    //设置连接的设备的过滤器
    __block BOOL isFirst = YES;
    [baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //这里的规则是：连接第一个AAA打头的设备
        if(isFirst && [peripheralName hasPrefix:@"AAA"]){
            isFirst = NO;
            return YES;
        }
        return NO;
    }];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IsConnect"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IsConnect"];
    }
    
    // 将蓝牙外设对象接出，取出name，显示
    //蓝牙对象在下面环节会查找出来，被放进BleViewPerArr数组里面，是CBPeripheral对象
    CBPeripheral *per=(CBPeripheral *)_BleViewPerArr[indexPath.row];
    //    NSString *bleName=[per.name substringWithRange:NSMakeRange(0, 9)];
    cell.textLabel.text = per.name;
    NSString *connected = [NSString stringWithFormat:@"%ld",(long)per.state ];
    DeBuGLog(@"connected is %@",connected);
    switch (per.state) {
        case CBPeripheralStateDisconnected:
            cell.detailTextLabel.text = @"未连接";
            break;
        case CBPeripheralStateConnecting:
            cell.detailTextLabel.text = @"正在连接";
            break;
        case CBPeripheralStateConnected:
            cell.detailTextLabel.text = @"已连接";
            break;
        case CBPeripheralStateDisconnecting:
            cell.detailTextLabel.text = @"正在断开连接";
            break;
        default:
            break;
    }
    //    cell.detailTextLabel.text = per.state==CBPeripheralStateConnected ?@"已连接":@"未连接";
    return cell;
}

#pragma mark UiTableDedegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _BleViewPerArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [baby connectPeripheral:_BleViewPerArr[indexPath.row] options:nil];
    [baby cancelScan];
    DeBuGLog(@"%@", [baby findConnectedPeripheral:@""]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)SetNavigation{
    self.title = @"Baby蓝牙";
    [self AddBackBtn];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
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
