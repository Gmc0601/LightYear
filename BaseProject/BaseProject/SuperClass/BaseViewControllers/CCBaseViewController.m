//
//  BaseViewController.m
//  EasyMake
//
//  Created by cc on 2017/5/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CCBaseViewController ()

@end

@implementation CCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.titleLab];
    [self.navigationView addSubview:self.leftBar];
    [self.navigationView addSubview:self.rightBar];
    [self.navigationView addSubview:self.line];

    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated:YES];
}

#pragma mark - Action  ---> NeedReset in son
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)more:(UIButton *)sender {
    NSLog(@"NeedReset in son");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    self.leftBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.leftBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    
}

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
        _navigationView.backgroundColor = [UIColor whiteColor];
    }
    return _navigationView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, kScreenW - 160, 30)];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:18];
    }
    return _titleLab;
}

- (UIButton *)leftBar {
    if (!_leftBar) {
        UIImage *image = [UIImage imageNamed:@"icon_fh"];
        _leftBar = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, image.size.width + 15, image.size.height + 15)];
        _leftBar.backgroundColor = [UIColor clearColor];
        [_leftBar setImage:image forState:UIControlStateNormal];
        [_leftBar addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBar;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:FRAME(0, 63, kScreenW, 1)];
        _line.backgroundColor = RGBColor(239, 240, 241);
        _line.hidden = YES;
    }
    return _line;
}

- (UIButton *)rightBar {
    if (!_rightBar) {
        _rightBar = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 10 - 40, 25, 40, 30)];
        _rightBar.backgroundColor = [UIColor clearColor];
        [_rightBar setTitle:@"更多" forState:UIControlStateNormal];
        _rightBar.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBar setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_rightBar addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBar;
}

@end
