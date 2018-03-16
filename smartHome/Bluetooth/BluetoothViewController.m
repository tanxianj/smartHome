//
//  BluetoothViewController.m
//  smartHome
//
//  Created by bang on 2018/2/12.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "BluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "StrConversion.h"
typedef NS_ENUM(NSInteger, BluetoothState){
    BluetoothStateDisconnect = 0,
    BluetoothStateScanSuccess,
    BluetoothStateScaning,
    BluetoothStateConnected,
    BluetoothStateConnecting
};

typedef NS_ENUM(NSInteger, BluetoothFailState){
    BluetoothFailStateUnExit = 0,
    BluetoothFailStateUnKnow,
    BluetoothFailStateByHW,
    BluetoothFailStateByOff,
    BluetoothFailStateUnauthorized,
    BluetoothFailStateByTimeout
};

@interface BluetoothViewController ()<BluetoothViewDelegete,CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property(nonatomic,strong)UIButton *button;
@property (strong , nonatomic) UITableView *tableView;
@property (strong , nonatomic) CBCentralManager *manager;//中央设备
@property (assign , nonatomic) BluetoothFailState bluetoothFailState;
@property (assign , nonatomic) BluetoothState bluetoothState;
@property (strong , nonatomic) CBPeripheral * discoveredPeripheral;//周边设备
@property (strong , nonatomic) CBCharacteristic *characteristic1;//周边设备服务特性
@property (strong , nonatomic) NSMutableArray *BleViewPerArr;

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建外设管理器，会回调peripheralManagerDidUpdateState方法
//    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    self.delegate = self;
    SEL sende = NSSelectorFromString(@"SendFile");
    if ([self.delegate respondsToSelector:sende]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.delegate performSelector:sende];
#pragma clang diagnostic pop
    }
    ///
    [self.view addSubview:self.tableView];
    self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    self.manager.delegate = self;
    self.BleViewPerArr = [[NSMutableArray alloc]initWithCapacity:10];
//
    
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"fail, state is off.");
        switch (central.state) {
            case CBCentralManagerStatePoweredOff:
                NSLog(@"连接失败了\n请您再检查一下您的手机蓝牙是否开启，\n然后再试一次吧");
                _bluetoothFailState = BluetoothFailStateByOff;
                break;
            case CBCentralManagerStateResetting:
                _bluetoothFailState=BluetoothFailStateByTimeout;
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@"检测到您的手机不支持蓝牙4.0\n所以建立不了连接.建议更换您\n的手机再试试。");
                _bluetoothFailState = BluetoothFailStateByHW;
                break;
            case CBCentralManagerStateUnauthorized:
                NSLog(@"连接失败了\n请您再检查一下您的手机蓝牙是否开启，\n然后再试一次吧");
                _bluetoothFailState = BluetoothFailStateUnauthorized;
                break;
            case CBCentralManagerStateUnknown:
                _bluetoothFailState = BluetoothFailStateUnKnow;
                break;
            default:
                break;
        }
        
        return;
    }
    [self scan];
    _bluetoothFailState = BluetoothFailStateUnExit;
}
-(void)scan{
    //判断状态开始扫瞄周围设备 第一个参数为空则会扫瞄所有的可连接设备  你可以
    //指定一个CBUUID对象 从而只扫瞄注册用指定服务的设备
    //scanForPeripheralsWithServices方法调用完后会调用代理CBCentralManagerDelegate的
    //- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI方法
    [self.manager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    //记录目前是扫描状态
    _bluetoothState = BluetoothStateScaning;
    //清空所有外设数组
    [self.BleViewPerArr removeAllObjects];
    //如果蓝牙状态未开启，提示开启蓝牙
    if(_bluetoothFailState==BluetoothFailStateByOff)
    {
        NSLog(@"%@",@"检查您的蓝牙是否开启后重试");
    }else{
        DeBuGLog(@"哈哈");
    }
    
}

//扫描设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    if (peripheral == nil||peripheral.identifier == nil/*||peripheral.name == nil*/)
    {
        return;
    }
    NSString *pername=[NSString stringWithFormat:@"%@",peripheral.name];
//
    //判断是否存在@"你的设备名"
    NSRange range=[pername rangeOfString:@"SmartHome"];

    //如果从搜索到的设备中找到指定设备名，和BleViewPerArr数组没有它的地址
    //加入BleViewPerArr数组
    if(range.location&&![_BleViewPerArr containsObject:peripheral]&&peripheral.name){
        [_BleViewPerArr addObject:peripheral];
    }
    _bluetoothFailState = BluetoothFailStateUnExit;
    _bluetoothState = BluetoothStateScanSuccess;
    [_tableView reloadData];
//
//    // 判断是否是你需要连接的设备
//    if ([peripheral.name isEqualToString:@"VerslinkUart"]) {
//        peripheral.delegate = self;
//        self.discoveredPeripheral = peripheral;
//        // 开始连接设备
//        [self.manager connectPeripheral:self.discoveredPeripheral options:nil];
//    }
}
// 获取当前链接到的设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    self.discoveredPeripheral = peripheral;
    // 设置设备代理
    [peripheral setDelegate:self];
    // 大概获取服务和特征
    [peripheral discoverServices:nil];
    
    //或许只获取你的设备蓝牙服务的uuid数组，一个或者多个
    //[peripheral discoverServices:@[[CBUUID UUIDWithString:@""],[CBUUID UUIDWithString:@""]]];
    [_manager stopScan];
    _bluetoothState=BluetoothStateConnected;
    
//    // 停止扫描
//    [self.manager stopScan];
//    // 发现服务
//    [self.discoveredPeripheral discoverServices:@[[CBUUID UUIDWithString:@"180A"]]];
}
// 获取当前设备服务services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{

//    CBService *service = peripheral.services.firstObject;
//    [peripheral discoverCharacteristics:nil forService:service];
    //遍历所有service
    for (CBService *service in peripheral.services){
        NSLog(@"服务--UUID %@",service.UUID);
        //找到你需要的servicesuuid
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]]){
            //监听它
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
    [self.tableView reloadData];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
        DeBuGLog(@"连接成功");
    for (CBCharacteristic *characteristic in service.characteristics) {
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A23"]]) {
//            // 这里是读取Mac地址， 可不要， 数据固定， 用readValueForCharacteristic， 不用setNotifyValue:setNotifyValue
//            [self.discoveredPeripheral readValueForCharacteristic:characteristic];
//        }
//
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF6"]]) {
            // 订阅特性，当数据频繁改变时，一般用它， 不用readValueForCharacteristic
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.characteristic1 = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//             [peripheral readValueForCharacteristic:characteristic];
            
            
            NSData *data = [StrConversion convertHexStringToData:@"FEBED004AAAA0D0A"];
            [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }

}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError *)error{
//    DeBuGLog(@"----------- %@",characteristic.value.description);
    NSString *value = [NSString stringWithFormat:@"%@",characteristic.value.description];
//    NSMutableString *macString = [[NSMutableString alloc] init];
//    [macString appendString:[[value substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
//    [macString appendString:@":"];
//    [macString appendString:[[value substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
//    [macString appendString:@":"];
//    [macString appendString:[[value substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
//    [macString appendString:@":"];
//    [macString appendString:[[value substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
//    [macString appendString:@":"];
//    [macString appendString:[[value substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
//    [macString appendString:@":"];
//    [macString appendString:[[value substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
    DeBuGLog(@"mac == %@",value);
    
    
    
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
    
    for (int i= 0 ; i<_BleViewPerArr.count; i++) {
        //断开所有连接
        [self.manager cancelPeripheralConnection:_BleViewPerArr[i]];
    }
    //连接点击的
    [_manager connectPeripheral:_BleViewPerArr[indexPath.row] options:nil];
    _discoveredPeripheral = _BleViewPerArr[indexPath.row];
    DeBuGLog(@"peripheral ---- is %@",_discoveredPeripheral.identifier);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

-(void)SendFile{
    DeBuGLog(@"测试");
}
-(void)SetNavigation{
    self.title = @"蓝牙";
    [self AddBackBtn];
    self.navigationItem.rightBarButtonItem=[self setupNavigationItemWithLeft:Nav_Right_Item imageName:nil title:@"测试" callBack:^{
        
            NSData *data = [StrConversion convertHexStringToData:@"FEBEAA132642616E67266861356F3275377026AAAA0D0A"];
            [self.discoveredPeripheral writeValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        
    }];
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
@end
