//
//  AMPresentHasLeakVC.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/20.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "AMPresentHasLeakVC.h"

@implementation AMPresentHasLeakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // self -> topView -> block -> self
//    __weak typeof(self) weakSelf = self;
    self.topView.didClickBlock = ^{
//        __strong typeof(self) self = weakSelf;
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:[UIButton buttonWithType:(UIButtonTypeContactAdd)]];
    [self.view addSubview:[UIButton buttonWithType:(UIButtonTypeContactAdd)]];
    [self.view addSubview:[UIButton buttonWithType:(UIButtonTypeContactAdd)]];
    [self.view addSubview:[UIButton buttonWithType:(UIButtonTypeContactAdd)]];
    [self.view addSubview:[UIButton buttonWithType:(UIButtonTypeContactAdd)]];
    
    UITableView *tableView = [UITableView new];
    tableView.frame = CGRectMake(0, 200, self.view.bounds.size.width, 400);
    [self.view addSubview:tableView];
}

@end
