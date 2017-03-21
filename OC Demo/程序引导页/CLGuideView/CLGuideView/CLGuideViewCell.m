//
//  CLGuideViewCell.m
//  CLGuideView
//
//  Created by WuChunlong（https://github.com/CoderCLWoo/） on 2017/3/6.
//  Copyright © 2017年 WuChunlong（https://github.com/CoderCLWoo/）. All rights reserved.
//

#import "CLGuideViewCell.h"

@implementation CLGuideViewCell
{
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            _imageView.image = img;
        });
        
    });
}

@end


@implementation CLEmptyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
