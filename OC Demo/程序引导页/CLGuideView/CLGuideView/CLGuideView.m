//
//  CLGuideView.m
//  CLGuideView
//
//  Created by WuChunlong（https://github.com/CoderCLWoo/） on 2017/3/6.
//  Copyright © 2017年 WuChunlong（https://github.com/CoderCLWoo/）. All rights reserved.
//

#import "CLGuideView.h"
#import "CLGuideViewLayout.h"
#import "CLGuideViewCell.h"
#import  <objc/runtime.h>


static NSString * const cellReuseIdentifier = @"CLGuideViewCellReuseIdentifier";
static NSString * const emptyCellReuseIdentifier = @"CLEmptyCellReuseIdentifier";

@interface CLGuideView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CLGuideView
{
    /** imageUrls */
    NSArray<NSURL *> *_urls;
}

- (instancetype)initWithUrls:(NSArray<NSURL *> *)urls {
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[[CLGuideViewLayout alloc] init]]) {
    
        self.backgroundColor = [UIColor clearColor];
        _urls = urls;
        self.dataSource = self;
        [self registerClass:[CLGuideViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        [self registerClass:[CLEmptyCell class] forCellWithReuseIdentifier:emptyCellReuseIdentifier];
        
        self.delegate = self;
    }
    return self;
}

- (void)showGuideViewCompletion:(void(^)())completion {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    if (completion) {
        objc_setAssociatedObject(self, @selector(showGuideViewCompletion:), completion, OBJC_ASSOCIATION_COPY);
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _urls.count + 1;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _urls.count) { // 最后一个
        CLEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:emptyCellReuseIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    CLGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    cell.url = _urls[indexPath.item];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x / self.bounds.size.width;
    
    NSInteger itemCounts = [self numberOfItemsInSection:0];

    if (offset == (itemCounts - 1)) {

        [UIView animateWithDuration:0.25 animations:^{
            scrollView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [scrollView removeFromSuperview];
            
            void(^completion)() = objc_getAssociatedObject(self, @selector(showGuideViewCompletion:));
            if (completion) {
                completion();
            }
            
        }];
        
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x / self.bounds.size.width;
    if (offset > _urls.count - 1) {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_urls.count inSection:0]];
        CGFloat progress = 1 - (offset - (_urls.count - 1));
        cell.alpha = progress;
    }
}



@end
