//
//  CLPullDownRefreshView.h
//  CLPullDownRefreshView
//
//  Created by WuChunlong on 2017/3/20.
//  Copyright © 2017年 WuChunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLPullDownRefreshViewStatus) {
    CLPullDownRefreshViewStatusNormal = 0,
    CLPullDownRefreshViewStatusPulling,
    CLPullDownRefreshViewStatusRefreshing,
};


@interface CLPullDownRefreshView : UIView

/** 刷新操作 */
@property (copy, nonatomic) void(^refreshAction)();

- (void)endRefreshing;

- (void)startRefreshing;

@end
