//
//  BMNavigationController.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/28.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMNavigationController.h"

@interface BMNavigationController ()

@end

@implementation BMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"BMNavigationController viewDidLoad");
}

- (void)dealloc {
    NSLog(@"BMNavigationController dealloc");
}


@end
