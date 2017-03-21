//
//  CLGuideView.h
//  CLGuideView
//
//  Created by WuChunlong（https://github.com/CoderCLWoo/） on 2017/3/6.
//  Copyright © 2017年 WuChunlong（https://github.com/CoderCLWoo/）. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLGuideView : UICollectionView

- (instancetype)initWithUrls:(NSArray<NSURL *> *)urls;

- (void)showGuideViewCompletion:(void(^)())completion;

@end
