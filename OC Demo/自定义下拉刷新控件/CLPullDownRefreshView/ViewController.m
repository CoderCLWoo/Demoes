//
//  ViewController.m
//  CLPullDownRefreshView
//
//  Created by WuChunlong on 2017/3/20.
//  Copyright © 2017年 WuChunlong. All rights reserved.
//

#import "ViewController.h"
#import "CLPullDownRefreshView.h"

@interface ViewController ()
@property(nonatomic)NSArray *dataSource;
@property(nonatomic)NSArray *refreshDataArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CLPullDownRefreshView *refreshView = [[CLPullDownRefreshView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.tableView addSubview:refreshView];
    
    __weak typeof(refreshView) weak_refreshView = refreshView;
    [refreshView setRefreshAction:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.refreshDataArr];
            [arrM addObjectsFromArray:self.dataSource];
            self.dataSource = arrM.copy;
            [self.tableView reloadData];
            
            [weak_refreshView endRefreshing];
            
        });
        
    }];
    
    [refreshView startRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[@"北京", @"上海", @"广州", @"深圳"];
    }
    
    return _dataSource;
}

- (NSArray *)refreshDataArr {
    if (_refreshDataArr == nil) {
        _refreshDataArr = @[@"香港", @"澳门", @"台湾", @"海南"];
    }
    
    return _refreshDataArr;
}

@end
