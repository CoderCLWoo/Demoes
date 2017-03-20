//
//  ViewController.m
//  定位与地图的使用
//
//  Created by WuChunlong on 2016/11/3.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationViewController.h"
#import "MapViewController.h"

static CGFloat const kBtnWH = 200.0f;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startLocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *openMapBtn;

/** 定位管理器 */
@property (nonatomic, strong) CLLocationManager *locMgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];

    
    [self setupSubViews];
    
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {

        [self locMgr];

    }else {
        // 提醒用户打开定位开关
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"请前往设置中打开定位服务的开关."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self switchLocationServiceOn];
                                                              }];
        
        [alert addAction:defaultAction];
        
        /**
         *  Presenting view controllers on detached view controllers is discouraged <L_RootViewController: 0x7fb6b3514850> 解决办法：参考 http://blog.csdn.net/msyqmsyq/article/details/51272052
         */
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    
}

// 打开定位开关
/**
 *  关于_BSMachError: (os/kern) invalid capability (20)和_BSMachError: (os/kern) invalid name (15)解决方法  参考：http://www.jianshu.com/p/aed40615239d  和 http://stackoverflow.com/questions/32899586/error-message-bsmacherror-os-kern-invalid-capability-20
 */
- (void)switchLocationServiceOn{
//    UIApplicationOpenSettingsURLString
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"]];//隐私设置
            [[UIApplication sharedApplication] openURL:url];
        });
    }
}

- (void)setupSubViews {
    self.startLocationBtn.layer.cornerRadius = kBtnWH * 0.5;
    self.openMapBtn.layer.cornerRadius = kBtnWH * 0.5;
}


#pragma mark - 懒加载
/**  位置管理者 */
- (CLLocationManager *)locMgr {
    if (_locMgr == nil) {
        // 创建位置管理者
        _locMgr = [[CLLocationManager alloc] init];
//        _locMgr.delegate = self;
        
        //每隔多少米定位一次（这里的设置为任何的移动）
        _locMgr.distanceFilter = kCLDistanceFilterNone;
        
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        _locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            
            //iOS 8.0+ 需要请求授权
            [_locMgr requestWhenInUseAuthorization]; // 前台定位授权（默认不可以在后台获取位置，需要勾选后台模式 location updates）
            
            
//            [_locMgr requestAlwaysAuthorization]; // 前后台定位授权（请求永久授权）
        }
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            
            // 一定要勾选后台模式 location updates
            _locMgr.allowsBackgroundLocationUpdates = YES; // 允许后台获取用户位置（iOS 9.0开始 要添加这句，才会出现蓝条）
        }
        
    // 或者也可以这样来判断
    //        if ([_locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    //            [_locMgr requestAlwaysAuthorization];
    //        }
    }
    
    return _locMgr;
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[LocationViewController class]]) {
        LocationViewController *locVc = (LocationViewController *)segue.destinationViewController;
        locVc.locMgr = self.locMgr;
        
    } else if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
        MapViewController *mapVc = (MapViewController *)segue.destinationViewController;
        NSLog(@"location : %@", self.location);
        (self.location) ? (mapVc.locationName = self.location) : (mapVc.locationName = @"上海");
        
    }
}

@end
