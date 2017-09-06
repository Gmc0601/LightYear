//
//  UILabel+Width.h
//  BaseProject
//
//  Created by cc on 2017/7/20.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Width)
//  自适应高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
//  自适应宽度
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
