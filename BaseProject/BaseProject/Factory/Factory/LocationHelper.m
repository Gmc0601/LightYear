//
//  LocationHelper.m
//  BaseProject
//
//  Created by cc on 2017/8/2.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LocationHelper.h"

static LocationHelper *_sharedInstance = nil;

@interface LocationHelper ()<CLLocationManagerDelegate>
{
    BOOL isCity;//判断是否请求到当前城市
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLPlacemark *currPlacemark;

@property(strong,nonatomic)NSTimer *timer;
@end


@implementation LocationHelper

#pragma mark - Class life cycle method
+ (LocationHelper *) sharedInstance
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[super allocWithZone:NULL] init];
        }
    }
    return _sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(_sharedInstance == nil)
        {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    
    return nil;
}

- (id)init
{
    if ((self=[super init]))
    {
        //开始定位并获得位置相关信息(如国家等)
                [self startLocationAndGetPlaceInfo];
        isCity=NO;
    }
    return self;
}

/// 开始定位并获得位置相关信息(如国家等)
- (void)startLocationAndGetPlaceInfo
{
//    if (self.currPlacemark) return; //如果已取得位置信息则退出
    
//    if (!self.locationManager)
//    {
        // 1. 实例化定位管理器
        self.locationManager = [[CLLocationManager alloc] init];
        // 2. 设置代理
        self.locationManager.delegate = self;
        // 3. 定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 4.请求用户权限：分为：?只在前台开启定位?在后台也可定位，
        //注意：建议只请求?和?中的一个，如果两个权限都需要，只请求?即可，
        //??这样的顺序，将导致bug：第一次启动程序后，系统将只请求?的权限，?的权限系统不会请求，只会在下一次启动应用时请求?
        self.locationManager.distanceFilter = kCLDistanceFilterNone; //1.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [_locationManager requestWhenInUseAuthorization];//?只在前台开启定位
            //需在info.plist中配置
            //            [self.locationManager requestAlwaysAuthorization];//?在后台也可定位
        }
        // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            self.locationManager.allowsBackgroundLocationUpdates = YES;
        }
        self.locationManager.pausesLocationUpdatesAutomatically = NO; //NO表示一直请求定位服务
        // 6. 更新用户位置
        [self.locationManager startUpdatingLocation];
        
//    }
    
    //开始定位
    [self.locationManager startUpdatingLocation];
}


//响应当前位置的更新，在这里记录最新的当前位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    //    //只定位一次
    [manager stopUpdatingLocation];
    //地球坐标转到火星坐标才能查询出真实地址
    CLLocationCoordinate2D gcg02Coord = [self wgs84ToGcj02:newLocation.coordinate];
    if (gcg02Coord.latitude>=0 && gcg02Coord.longitude>=0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",gcg02Coord.longitude] forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",gcg02Coord.latitude] forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    CLLocation *convertedLoc = [[CLLocation alloc] initWithLatitude:gcg02Coord.latitude longitude:gcg02Coord.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:convertedLoc completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] > 0 && error == nil) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSArray *languages = [NSLocale preferredLanguages];
             NSString *currentLanguage = [languages objectAtIndex:0];
             NSString *language;
             //判断模拟器的语言环境
             if (currentLanguage&&![currentLanguage isKindOfClass:[NSNull class]]) {
                 if (currentLanguage.length>=@"zh-Hans".length) {
                     language=[currentLanguage substringToIndex:@"zh-Hans".length];
                 }
             }
             NSString *currentCity;
             if (language)
             {
                 if ([language isEqualToString:@"zh-Hans"])
                 {
                     //因为四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市
                     if (placemark.locality)
                     {
                         currentCity = [placemark.locality substringToIndex:placemark.locality.length - 1];
                     }
                     else
                     {
                         currentCity = [placemark.administrativeArea substringToIndex:placemark.administrativeArea.length - 1];
                     }
                 }
                 else
                 {   //本地是英文时
                     if (placemark.locality)
                     {
                         currentCity = placemark.locality;
                     }
                     else
                     {
                         currentCity = placemark.administrativeArea;
                     }
                     
                 }
                 
                 if (currentCity) {
                     
                     if (self.returnBlock&&isCity!=YES) {
                         isCity=YES;
                         self.returnBlock(currentCity);
                     }
                 }
             }
         }
     }];
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Longitude = %f", manager.location.coordinate.longitude);
    NSLog(@"Latitude = %f", manager.location.coordinate.latitude);
    [_locationManager stopUpdatingLocation];

    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"Country"]);
            NSLog(@"%@", [test objectForKey:@"State"]);
            NSLog(@"%@", [test objectForKey:@"SubLocality"]);
            NSLog(@"%@", [test objectForKey:@"Street"]);
            NSString *nowAddress = [NSString stringWithFormat:@"%@%@%@",[test objectForKey:@"State"],[test objectForKey:@"SubLocality"],[test objectForKey:@"Street"]];
            [ConfigModel saveString:nowAddress forKey:NowAddress];
        }

        NSLog(@"\n失败原因：%@",error);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //只定位一次
    [manager startUpdatingLocation];
    
}


#pragma mark - 地球坐标(原始GPS坐标)和火星坐标（高德/Google中国）互转
const double g_pi = 3.14159265358979324;
const double g_a = 6378245.0;
const double g_ee = 0.00669342162296594323;
- (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)wgs84Coor
{
    
    CLLocationCoordinate2D gcj02Coor;
    
    if (outOfChina(wgs84Coor.latitude, wgs84Coor.longitude)) {
        
        gcj02Coor = wgs84Coor;
        
        return gcj02Coor;
        
    }
    
    double dLat = transformLat(wgs84Coor.longitude-105.0, wgs84Coor.latitude-35.0);
    
    double dLon = transformLon(wgs84Coor.longitude-105.0, wgs84Coor.latitude-35.0);
    
    double radLat = wgs84Coor.latitude/180.0*g_pi;
    
    double magic = sin(radLat);
    
    magic = 1-g_ee*magic*magic;
    
    double sqrtMagic = sqrt(magic);
    
    dLat = (dLat * 180.0) / ((g_a * (1 - g_ee)) / (magic * sqrtMagic) * g_pi);
    
    dLon = (dLon * 180.0) / (g_a / sqrtMagic * cos(radLat) * g_pi);
    
    gcj02Coor = CLLocationCoordinate2DMake(wgs84Coor.latitude+dLat, wgs84Coor.longitude+dLon);
    
    return gcj02Coor;
    
}

#pragma mark-火星坐标转地球坐标
- (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)gcj02Coor
{
    double lon = gcj02Coor.longitude;
    double lat = gcj02Coor.latitude;
    
    CLLocationCoordinate2D coor = [self wgs84ToGcj02:gcj02Coor];
    
    double lontitude = lon - (coor.longitude - lon);
    double latitude = lat - (coor.latitude - lat);
    
    return CLLocationCoordinate2DMake(latitude, lontitude);
    
}

#pragma mark-判断是中国还是外国
- (BOOL)isInChina:(double)lat lon:(double)lon
{
    return outOfChina(lat, lon) ? NO : YES ;
}

#pragma mark-判断是中国还是外国
bool outOfChina(double lat, double lon)
{
    //缓存中未拿到国家信息
    if ([LocationHelper sharedInstance].currPlacemark) {
        
        NSString *countryCode = [LocationHelper sharedInstance].currPlacemark.ISOcountryCode;
        if (!countryCode || countryCode.length < 1) return false; //默认认为在中国
        
        //
        if ([countryCode isEqualToString:@"CN"] ) {
            return false;
        }
    }
    
    if (lon < 72.004 || lon > 137.8347)
        return true;
    
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    
    return false;
    
}

#pragma mark-转换经度
double transformLat(double x, double y)
{
    
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    
    ret += (20.0 * sin(6.0 * x * g_pi) + 20.0 * sin(2.0 * x * g_pi)) * 2.0 / 3.0;
    
    ret += (20.0 * sin(y * g_pi) + 40.0 * sin(y / 3.0 * g_pi)) * 2.0 / 3.0;
    
    ret += (160.0 * sin(y / 12.0 * g_pi) + 320 * sin(y * g_pi / 30.0)) * 2.0 / 3.0;
    
    return ret;
    
}

#pragma mark-转换纬度
double transformLon(double x, double y)
{
    
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    
    ret += (20.0 * sin(6.0 * x * g_pi) + 20.0 * sin(2.0 * x * g_pi)) * 2.0 / 3.0;
    
    ret += (20.0 * sin(x * g_pi) + 40.0 * sin(x / 3.0 * g_pi)) * 2.0 / 3.0;
    
    ret += (150.0 * sin(x / 12.0 * g_pi) + 300.0 * sin(x / 30.0 * g_pi)) * 2.0 / 3.0;
    
    return ret;
    
}

@end
