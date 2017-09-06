//
//  BaseViewController.h
//  EasyMake
//
//  Created by cc on 2017/5/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCBaseViewController : UIViewController

@property (nonatomic, retain) UIView *navigationView;

@property (nonatomic, retain) UIButton *leftBar;

@property (nonatomic, retain) UIButton *rightBar;

@property (nonatomic, retain) UILabel *titleLab;

@property (nonatomic, retain) UILabel *line;
//
- (void)back:(UIButton *)sender ;

- (void)more:(UIButton *)sender ;
@end
