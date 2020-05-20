//
//  AMPresentNoLeakVC.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/20.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "AMPresentNoLeakVC.h"

@implementation AMPresentNoLeakVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.topView.didClickBlock = ^{
        __strong typeof(self) self = weakSelf;
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}

@end
