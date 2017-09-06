//
//  FirstViewViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FirstViewViewController.h"

#import "OrderViewController.h"
#import "MycenterViewController.h"
#import "ShoppingCarViewController.h"

@interface FirstViewViewController ()

@property (nonatomic, retain) UIView *classView;

@property (nonatomic, retain) NSArray *classArr;

@end

@implementation FirstViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"首页";
    [self.view addSubview:self.classView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//   ************   进入自己的模块  ************
- (UIView *)classView {
    if (!_classView) {
        _classView = [[UIView alloc] initWithFrame:FRAME(0, 64, SizeWidth(80), SizeHeigh(200))];
        _classView.backgroundColor = RGBColor(239, 240, 241);
        for (int i = 0; i < self.classArr.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(10), SizeHeigh(10 + i * 60), SizeWidth(60), SizeHeigh(60))];
            [btn setTitle:self.classArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:MainBlue forState:UIControlStateNormal];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(classBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_classView addSubview:btn];
        }
    }
    return _classView;
}
- (void)classBtnClick:(UIButton *)sender {
    UIViewController *to;
    switch (sender.tag - 100) {
        case 0:{//  A  个人中心，登录
            to = [MycenterViewController new];
        }
            break;
        case 1:{//  B  购物车 商品详情等
            to = [ShoppingCarViewController new];
        }
            break;
        case 2:{//  D  订单
            to = [OrderViewController new];
        }
            break;
            
        default:
            NSLog(@"搞错了吧");
            break;
    }
    [self.navigationController pushViewController:to animated:YES];
}

- (NSArray *)classArr {
    if (!_classArr) {
        _classArr = @[@"A", @"B", @"D"];
    }
    return _classArr;
}

@end
