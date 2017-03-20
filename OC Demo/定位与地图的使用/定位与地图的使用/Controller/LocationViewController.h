//
//  LocationViewController.h
//  定位与地图的使用
//
//  Created by WuChunlong on 2016/11/3.
//  Copyright © 2016年 WuChunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationViewController : UIViewController

/** 定位管理器 */
@property (nonatomic, strong) CLLocationManager *locMgr;

@end
