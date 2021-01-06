//
//  AMTabBarController.m
//  AMLeaksFinder_Example
//
//  Created by liangdahong on 2021/1/5.
//  Copyright © 2021 ios@liangdahong.com. All rights reserved.
//

#import "AMTabBarController.h"

@interface AMTabBarController ()

@end

@implementation AMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AMTabBarController viewDidLoad");
}


- (void)dealloc {
    NSLog(@"AMTabBarController dealloc");
}

@end
