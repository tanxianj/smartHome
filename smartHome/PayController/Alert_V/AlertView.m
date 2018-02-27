//
//  AlertView.m
//  TostOther
//
//  Created by bang on 2018/2/9.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "AlertView.h"
#import "AlertTableViewCell.h"
#import "XCToast.h"
@interface AlertView()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger tab_height;//当前TAB的高度
    NSInteger indexpath;//当前点击的位置
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSString *alertTitle;//title
@property (nonatomic,strong)NSArray *alertOptions;//选择标签数组
@end
@implementation AlertView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
          self.backgroundColor = [UIColor AppGrayColor];
        
    }
    return self;
}
-(void)AlertViewWithTitle:(NSString *)title alertOptions:(NSArray *)alertOptions didsectBlock:(didsectBlock)results{
    self.alertTitle = title;
    self.alertOptions = alertOptions;
    if (results) {
        self.BlockIndexPath = ^(NSInteger indexpath) {
            results(indexpath);
        };
    }
}

-(void)layoutSubviews{
    [self allocView];
    [self ShowPlayView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
             return self.alertTitle ? self.alertOptions.count+1 :self.alertOptions.count;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Alertcell"];
    if (!cell) {
        cell = [[[NSBundle  mainBundle] loadNibNamed:@"AlertTableViewCell" owner:self options:nil] lastObject];
    }
    switch (indexPath.section) {
        case 0:{
            if (self.alertTitle ) {
                if (indexPath.row==0) {
                    cell.textLable.text =self.alertTitle;
                    cell.textLable.font = [UIFont systemFontOfSize:13.0];
                    cell.textLable.textColor = [UIColor AppGrayColor];
                    cell.userInteractionEnabled = NO;
                }else{
                    cell.textLable.text =self.alertOptions[indexPath.row-1];
                }
            }else{
                cell.textLable.text =self.alertOptions[indexPath.row];
            }
        }
            break;
        case 1:{
            cell.textLable.text =@"取消";
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self HiddenPlayView];
    NSString *tost = [NSString stringWithFormat:@"%@",indexPath.section==0?self.alertTitle ? indexPath.row==0? self.alertTitle :self.alertOptions[indexPath.row-1] :self.alertOptions[indexPath.row] :@"取消"];
    [XCToast showWithMessage:tost];
    if (indexPath.section == 1) return;//取消直接结束
    indexpath =indexPath.row;
    if (self.alertTitle) indexpath =indexPath.row -1;
    if (self.BlockIndexPath) {
        self.BlockIndexPath(indexpath);
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return nil;
            break;
        case 1:{
            UIView *header = [UIView new];
            header.backgroundColor = [UIColor appLineColor];
            header.frame = CGRectMake(0, 0, kScreenWidth, 10);
            return header;
        }
            break;
        default:
            break;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return 10;
            break;
        default:
            
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
-(void)allocView{
    [self addSubview:self.tableView];
    
    tab_height = self.alertTitle ? 44 +self.alertOptions.count*44.0+10.0+44.0  : self.alertOptions.count*44.0+10.0 +44.0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.offset(tab_height);
    }];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches.anyObject.view isDescendantOfView:self]) {
        [self HiddenPlayView];
    }
}
-(void)ShowPlayView{
    self.alpha = 0;
    self.tableView.transform = CGAffineTransformMakeTranslation(0,kScreenHeight+tab_height);
    [UIView animateWithDuration:.22 animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
    self.alpha = 1;
    }];
}
-(void)HiddenPlayView{
    self.alpha = 1;
    [UIView animateWithDuration:.22 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0,kScreenHeight+tab_height);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        //设置分割线的颜色
        
        _tableView.separatorColor = [UIColor appLineColor];
    }
    return _tableView;
}
@end
