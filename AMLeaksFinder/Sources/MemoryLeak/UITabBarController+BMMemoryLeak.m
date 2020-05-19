//
//  UITabBarController+BMMemoryLeak.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/19.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "UITabBarController+BMMemoryLeak.h"
#import "UIViewController+BMMemoryLeak.h"
#import "UIViewController+BMMemoryLeakUI.h"

@implementation UITabBarController (BMMemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(UINavigationController.class,
                              @selector(setViewControllers:),
                              @selector(bm_test_setViewControllers:));
        
        swizzleInstanceMethod(UINavigationController.class,
                              @selector(setViewControllers:),
                              @selector(bm_test_setViewControllers:));
    });
}

- (void)bm_test_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray <UIViewController *> *muarray = @[].mutableCopy;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL flag = NO;
        [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj == obj1) {
                flag = YES;
            }
        }];
        if (!flag) {
            [muarray addObjectsFromArray:obj.bm_test_selfAndAllChildController];
        }
    }];
    [muarray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.memoryLeakDeallocModel.controller == obj) {
                obj1.memoryLeakDeallocModel.shouldDealloc = YES;
            }
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update ui
        [UIViewController udpateUI];
    });
    [self bm_test_setViewControllers:viewControllers];
}

- (void)bm_test_setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSMutableArray <UIViewController *> *muarray = @[].mutableCopy;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL flag = NO;
        [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj == obj1) {
                flag = YES;
            }
        }];
        if (!flag) {
            [muarray addObjectsFromArray:obj.bm_test_selfAndAllChildController];
        }
    }];
    [muarray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.memoryLeakDeallocModel.controller == obj) {
                obj1.memoryLeakDeallocModel.shouldDealloc = YES;
            }
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update ui
        [UIViewController udpateUI];
    });
    [self bm_test_setViewControllers:viewControllers animated:animated];
}

@end
