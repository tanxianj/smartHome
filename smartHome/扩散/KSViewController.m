//
//  KSViewController.m
//  smartHome
//
//  Created by bang on 2018/2/24.
//  Copyright © 2018年 XiaoHuiBang. All rights reserved.
//

#import "KSViewController.h"

@interface KSViewController ()
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)CALayer *oldlayer;
@end

@implementation KSViewController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
            UIView *view = [UIView new];
    view.tag = 1000;
//        view.layer.cornerRadius = (kScreenWidth-i*50)/2;
//        view.backgroundColor = [UIColor redColor];
//        view.alpha = i*0.2;
//        view.layer.masksToBounds = 1;
            [self.view addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.view);
//            make.width.height.offset(kScreenWidth-i*50);
//        }];
            /*通过贝塞尔曲线 UIBezierPath 来绘制圆*/
            UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((kScreenWidth-50)/2, (kScreenWidth-50)/2, 50, 50)];
            CAShapeLayer *ShapeLayer = [CAShapeLayer layer];
            ShapeLayer.path = path.CGPath;
//            ShapeLayer.fillColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:i*0.2].CGColor;
        ShapeLayer.fillColor = [UIColor colorWithRed:0  green:0 blue:0 alpha:0.2].CGColor;
            [view.layer addSublayer:ShapeLayer];
    _oldlayer = view.layer;
        
    
    _timer = [[NSTimer alloc]initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
NSInteger number;
-(void)timerAction{
    number++;
    
    
        
    [UIView animateWithDuration:0.2 animations:^{
        UIView *view = [self.view viewWithTag:1000];
        UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((kScreenWidth-number*50)/2, (kScreenWidth-number*50)/2, number*50, number*50)];
        CAShapeLayer *ShapeLayer = [CAShapeLayer layer];
        ShapeLayer.path = path.CGPath;
        //        ShapeLayer.fillColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:i*0.5].CGColor;
        ShapeLayer.fillColor = [UIColor colorWithRed:0  green:0 blue:0 alpha:0.2].CGColor;
        [view.layer addSublayer:ShapeLayer];
        
    } completion:^(BOOL finished) {
        
    }];
    
       
    
    
    
}
-(void)SetNavigation{
    self.title = @"扩散自定义";
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
