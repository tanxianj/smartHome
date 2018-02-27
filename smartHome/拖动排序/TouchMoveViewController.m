//
//  TouchMoveViewController.m
//  smartHome
//
//  Created by bang on 2018/2/24.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "TouchMoveViewController.h"

@interface TouchMoveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *titleArray2;
@end

@implementation TouchMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)SetNavigation{
    self.title = @"拖动排序";
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightaction:)];
    
    [right setTintColor:[UIColor appBlackColor]];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateSelected];
    /*
    [self setupNavigationItemWithLeft:Nav_Right_Item imageName:nil title:@"编辑" callBack:^{
        
        // 开启编辑模式
        self.tableView.editing = self.tableView.editing ? NO :YES;
//        self.navigationItem.rightBarButtonItem.title = self.tableView.editing ? @"完成" : @"编辑";
        [self.view layoutSubviews];
    }];
     */
    self.navigationItem.rightBarButtonItem = right;
    [self AddBackBtn];
}
-(void)rightaction:(UIBarButtonItem *)item{
    // 开启编辑模式
    self.tableView.editing = self.tableView.editing ? NO :YES;
    item.title = self.tableView.editing ? @"完成" : @"编辑";
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array1 = self.titleArray[section];
    return  array1.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        
    }
   
            cell.textLabel.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.section][indexPath.row]];
      
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    UILabel *lab = [UILabel LableInitWith:[NSString stringWithFormat:@"第%li个分组",section] LabFontSize:15.0 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
    lab.frame = CGRectMake(10, 0, kScreenWidth-10, 40);
    [view addSubview:lab];
    return view;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.titleArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    DeBuGLog(@"\n原始位置 is 第%li组第%li行\n当前位置 is 第%li组第%li行",sourceIndexPath.section,sourceIndexPath.row,destinationIndexPath.section,destinationIndexPath.row);
    
    
    
    NSMutableArray *array1 =self.titleArray[sourceIndexPath.section];//拿到移动的那个分组
    [self.titleArray removeObjectAtIndex:sourceIndexPath.section];//删除移动的那个分组
    //
    NSString *str = array1[sourceIndexPath.row];//拿到移动的那个分组移动的某条数据
    [array1 removeObjectAtIndex:sourceIndexPath.row];//删除移动的那个分组移动的某条数据
    [self.titleArray insertObject:array1 atIndex:sourceIndexPath.section];//添加刚刚删除后的分组到删除的位置
    
    
    //
    NSMutableArray *array2 =self.titleArray[destinationIndexPath.section];//拿到移动到的那个分组
    [self.titleArray removeObjectAtIndex:destinationIndexPath.section];//删除移动的那个分组
    //
    [array2 insertObject:str atIndex:destinationIndexPath.row];//将刚刚移动的数据添加到最后移动到的那个分组
    [self.titleArray insertObject:array2 atIndex:destinationIndexPath.section];//将刚刚删除的那个移动的分组添加回去
    
    
    [self.tableView reloadData];//最后！！！刷新数据。
}
#pragma mark 视图初始化协议
-(void)InitializeAddToSwperView{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:10];
        for (int x = 0; x<5; x++) {
            NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:10];
            [_titleArray addObject:mutableArray];
            for (int i = 0; i<5; i++) {
                NSString *str = [NSString stringWithFormat:@"第%d组----第%d行",x,i];
                [mutableArray addObject:str];
            }
        }
        
    }
    return _titleArray;
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
