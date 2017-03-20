//
//  LocationViewController.m
//  定位与地图的使用
//
//  Created by WuChunlong on 2016/11/3.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "LocationViewController.h"
#import "SVProgressHUD.h"
#import "ViewController.h"

@interface LocationViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


/**
 *  经纬度
 */
@property(assign, nonatomic) CLLocationCoordinate2D coordinate;
/** 地理编码 */
@property (strong, nonatomic) CLGeocoder *geoCoder;
/** 反地理编码获得的地址全称 */
@property (copy, nonatomic) NSString *name;


@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.locationLabel.text = self.locationName;
    self.locMgr.delegate = self;
    // 开始定位用户的位置
    [self.locMgr startUpdatingLocation];
    
    // 显示HUD
    [SVProgressHUD showWithStatus:@"正在定位..."  maskType:SVProgressHUDMaskTypeBlack];
    
}

#pragma mark - <CLLocationManagerDelegate>
/**
 *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    
    //    CLLocation *loc = [locations firstObject];
    CLLocation *loc = [locations lastObject];
    //纬度：loc.coordinate.latitude
    
    //经度：loc.coordinate.longitude
    
    NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    
    NSLog(@"%ld",locations.count);
    
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    if (locations.count) {
        [self.locMgr stopUpdatingLocation];
        
        self.coordinate = loc.coordinate;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            // 反地理编码
            [self getLocationName];
        });
        
    }
}

- (void)getLocationName {
    // 反地理编码
    if (self.coordinate.longitude || self.coordinate.latitude) { // 容错检查
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
        [self.geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error) { // 反地理编码失败
                NSLog(@"%s, line = %d", __func__, __LINE__);
                NSLog(@"%@", [error localizedDescription]);
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [SVProgressHUD showErrorWithStatus:@"定位失败"];
                }];
                
            } else { // 反地理编码成功
                
                //                [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //
                //                    self.name = obj.name;
                //                }];
                CLPlacemark *pk = placemarks.firstObject; // 地标数组按照相关度进行排序，一般取首个地标。
                self.name = pk.name;
                NSLog(@"name:%@", self.name);
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [SVProgressHUD showSuccessWithStatus:@"定位成功"];
                    self.locationLabel.text = self.name;
                }];

            }
            
        }];
    }
}

#pragma mark - 懒加载
/** 地理编码 */
- (CLGeocoder *)geoCoder {
    if (_geoCoder == nil) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    
    return _geoCoder;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ViewController class]]) {
            ViewController *vc = (ViewController *)obj;
            NSLog(@"----%@",self.name);
            vc.location = self.name;
        }
        
    }];
    
}

@end
