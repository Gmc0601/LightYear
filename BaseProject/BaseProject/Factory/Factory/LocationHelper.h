//
//  LocationHelper.h
//  BaseProject
//
//  Created by cc on 2017/8/2.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
typedef void(^ReturnCurrentCity)(NSString *currentcity);

@interface LocationHelper : NSObject

/// 单例实例
+ (LocationHelper *) sharedInstance;

/// 开始定位并获得位置相关信息
- (void)startLocationAndGetPlaceInfo;

/// 地球坐标系(真实GPS坐标)转火星坐标（高德坐标）
- (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)wgs84Coor;
/// 火星坐标转地球坐标系
- (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)gcj02Coor;
/// 坐标是否在中国内
- (BOOL)isInChina:(double)lat lon:(double)lon;

@property(nonatomic,copy)ReturnCurrentCity  returnBlock;

@end

