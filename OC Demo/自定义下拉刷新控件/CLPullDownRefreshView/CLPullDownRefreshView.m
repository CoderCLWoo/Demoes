//
//  CLPullDownRefreshView.m
//  CLPullDownRefreshView
//
//  Created by WuChunlong on 2017/3/20.
//  Copyright © 2017年 WuChunlong. All rights reserved.
//

#import "CLPullDownRefreshView.h"
@interface CLPullDownRefreshView ()

@property(nonatomic) UIImageView *imgView;
@property(nonatomic) UILabel *stateLabel;

/** 刷新动画图片 */
@property(nonatomic) NSArray *refreshImages;

/** 当前刷新状态 */
@property (assign, nonatomic) CLPullDownRefreshViewStatus currentStatus;
/** 可滚动的父控件 */
@property (strong, nonatomic) UIScrollView *superScrollView;


@end

@implementation CLPullDownRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor brownColor];
        
        [self addSubview:self.imgView];
        [self addSubview:self.stateLabel];
        
        CGFloat titleW = 100;
        CGFloat margin = 8;
        CGFloat wh = 50;
        CGFloat x = (frame.size.width - titleW - wh - margin) * 0.5;
        CGFloat y = (frame.size.height- wh) * 0.5 ;
        self.imgView.frame = CGRectMake(x, y, 50, 50);
        self.stateLabel.frame = CGRectMake(x+wh+margin, y, titleW, wh);
        
    }
    return self;
}


- (void)dealloc {
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)endRefreshing {
    
    // refreshing -> normal
    if (self.currentStatus == CLPullDownRefreshViewStatusRefreshing) {
        self.currentStatus = CLPullDownRefreshViewStatusNormal;
        
        // tableview 回到原位
        [UIView animateWithDuration:0.25 animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top - self.bounds.size.height, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
        }];
        
        
    }
}

- (void)startRefreshing {
    if (self.currentStatus != CLPullDownRefreshViewStatusRefreshing) {
        self.currentStatus = CLPullDownRefreshViewStatusRefreshing;
      
    }
}


#pragma mark - 内部方法
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScrollView = (UIScrollView *)newSuperview;
        
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        // 根据拖动的程度切换状态
        if ([self.superScrollView isDragging]) {
            // normal -> pulling  pulling -> normal
            CGFloat normalPullingOffset = -128;
            if (self.currentStatus == CLPullDownRefreshViewStatusNormal && self.superScrollView.contentOffset.y < normalPullingOffset) {
                self.currentStatus = CLPullDownRefreshViewStatusPulling;
            } else if (self.currentStatus == CLPullDownRefreshViewStatusPulling && self.superScrollView.contentOffset.y > normalPullingOffset) {
                self.currentStatus = CLPullDownRefreshViewStatusNormal;
            }
            
        } else { // 松开手 pulling -> refreshing
            if (self.currentStatus == CLPullDownRefreshViewStatusPulling) {
                self.currentStatus = CLPullDownRefreshViewStatusRefreshing;
            }
        }
    }
}


#pragma mark 设置刷新状态
- (void)setCurrentStatus:(CLPullDownRefreshViewStatus)currentStatus {
    _currentStatus = currentStatus;
    
    switch (currentStatus) {
        case CLPullDownRefreshViewStatusNormal:
            NSLog(@"切换到普通状态");
            self.stateLabel.text = @"下拉刷新";
            if ([self.imgView isAnimating]) {
                [self.imgView stopAnimating];
            }
            self.imgView.image = [UIImage imageNamed:@"normal"];
            break;
        case CLPullDownRefreshViewStatusPulling:
            NSLog(@"切换到下拉释放刷新状态");
            self.stateLabel.text = @"释放刷新";
            self.imgView.image = [UIImage imageNamed:@"pulling"];
            break;
        case CLPullDownRefreshViewStatusRefreshing:
            NSLog(@"切换到正在刷新状态");
            
            self.stateLabel.text = @"正在刷新...";
            // 设置刷新动画
            self.imgView.animationImages = self.refreshImages;
            self.imgView.animationDuration = 0.1 * self.refreshImages.count;
            [self.imgView startAnimating];
            
            // 让 tableview 下拉 显示刷新动画
            [UIView animateWithDuration:0.25 animations:^{
                self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top + self.bounds.size.height, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
            }];
            
            // 执行刷新操作
            if (self.refreshAction) {
                self.refreshAction();
            }
            
            
            break;
            
    }
}

#pragma mark - lazy load
- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"normal"]];
    }
    
    return _imgView;
}

- (UILabel *)stateLabel {
    if (_stateLabel == nil) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.text = @"下拉刷新";
        _stateLabel.textColor = [UIColor darkGrayColor];
        _stateLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _stateLabel;
}


- (NSArray *)refreshImages {
    if (_refreshImages == nil) {
        NSMutableArray *arrM  = [NSMutableArray array];
        for (int i = 1; i <= 3; i++) {
            NSString *imgName = [NSString stringWithFormat:@"refreshing_0%d", i];
            UIImage *img = [UIImage imageNamed:imgName];
            [arrM addObject:img];
        }
        _refreshImages = arrM.copy;
    }
    
    return _refreshImages;
}


@end
