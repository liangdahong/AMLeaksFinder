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
    self.topView.didClickBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}

@end
