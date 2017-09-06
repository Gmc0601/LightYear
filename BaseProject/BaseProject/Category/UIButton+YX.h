//
//  UIButton+YX.h
//  StareAuction
//
//  Created by  cc on 2017/7/4.
//  Copyright © 2017年 cc All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, CLButtonEdgeInsetsTitleStyle) {
    CLButtonEdgeInsetsStyleTitleTop, // title在上
    CLButtonEdgeInsetsStyleTitleLeft, // title在左
    CLButtonEdgeInsetsStyleTitleBottom, // title在下
    CLButtonEdgeInsetsStyleTitleRight // title在右
};


@interface UIButton (YX)





- (void)layoutButtonWithEdgeInsetsStyle:(CLButtonEdgeInsetsTitleStyle)style
                        imageTitleSpace:(CGFloat)space;







@end
