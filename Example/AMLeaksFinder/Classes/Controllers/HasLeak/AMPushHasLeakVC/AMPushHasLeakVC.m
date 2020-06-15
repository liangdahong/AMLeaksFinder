//
//  AMPushHasLeakVC.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/20.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "AMPushHasLeakVC.h"

@implementation AMPushHasLeakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // self -> topView -> block -> self
//    __weak typeof(self) weakSelf = self;
    self.topView.didClickBlock = ^{
//        __strong typeof(self) self = weakSelf;
        [self.navigationController popViewControllerAnimated:YES];
    };
}

@end
