//
//  ViewController.m
//  CLGuideView
//
//  Created by WuChunlong（https://github.com/CoderCLWoo/） on 2017/3/6.
//  Copyright © 2017年 WuChunlong（https://github.com/CoderCLWoo/）. All rights reserved.
//

#import "ViewController.h"
#import "CLGuideView.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray<NSURL *> *_imageUrls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    NSLog(@"%@", _imageUrls);
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showGuideView];
   
}

- (void)showGuideView {
    CLGuideView *guideView = [[CLGuideView alloc] initWithUrls:_imageUrls];
    [guideView showGuideViewCompletion:^{
        self.navigationController.navigationBar.hidden = NO;
    }];
}


- (void)loadData {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1 ; i <= 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%02zd", i];
        NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"jpg"];
        NSAssert(url, @"url can not be nil");
        [arr addObject:url];
        
    }
    _imageUrls = arr.copy;
}


@end

