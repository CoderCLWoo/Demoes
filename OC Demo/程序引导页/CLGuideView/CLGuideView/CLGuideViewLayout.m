//
//  CLGuideViewLayout.m
//  CLGuideView
//
//  Created by WuChunlong（https://github.com/CoderCLWoo/） on 2017/3/6.
//  Copyright © 2017年 WuChunlong（https://github.com/CoderCLWoo/）. All rights reserved.
//

#import "CLGuideViewLayout.h"

@implementation CLGuideViewLayout

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout {
    [super prepareLayout];
//    NSLog(@"%@", NSStringFromCGRect(self.collectionView.frame));
//    NSLog(@"%@", self.collectionView);
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.itemSize = self.collectionView.bounds.size;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}

@end
