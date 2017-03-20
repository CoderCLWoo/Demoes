//
//  MapViewController.m
//  定位与地图的使用
//
//  Created by WuChunlong on 2016/11/3.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) CLGeocoder *geocoder;
/** 地图视图 */
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.geocoder = [[CLGeocoder alloc] init];//地理编码器
    
//    [self locationInSystemMap];
    
    [self setupMapView];
    
}

/**  在创建的地图视图上显示  */
- (void)setupMapView {
    self.mapView.showsUserLocation = YES;//显示当前位置，在模拟器上显示不出来，因为模拟器没法定位
    self.mapView.zoomEnabled = YES;//用户可以通过收缩，拖动和其他方式与显示的地图进行交互
    self.mapView.delegate = self;
    
    self.mapView.mapType = MKMapTypeStandard;//标准地图
    // 用户位置
    NSLog(@"用户位置：%@", self.mapView.userLocation.location);
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;//跟踪类型
    
}

/** 在苹果自带地图应用上标记一个位置 */
-(void)locationInSystemMap{
    //根据 地名 进行地理编码
    [self.geocoder geocodeAddressString:self.locationName completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkplacemark=[[MKPlacemark alloc]initWithPlacemark:clPlacemark];//定位地标转化为地图的地标
        
         MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:mkplacemark];//根据地图上的地标，创建在地图上可显示的Item
        
        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};//地图类型
        
        [mapItem openInMapsWithLaunchOptions:options];//在地图上打开编码后的地点
        
        
    }];
}

#pragma mark - MKMapViewDelegate
//地图加载完成后触发
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"地图加载完成");
}

//地图加载失败后触发
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"地图加载失败，%@", error.localizedDescription);
}


@end
