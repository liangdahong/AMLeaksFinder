
//
//  UINavigationController+BMMemoryLeak.m
//  BMeaksFinder
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "UINavigationController+BMMemoryLeak.h"
#import "UIViewController+BMMemoryLeak.h"
#import "UIViewController+BMMemoryLeakUI.h"

@implementation UINavigationController (BMMemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(UINavigationController.class,
                              @selector(popViewControllerAnimated:),
                              @selector(bm_test_popViewControllerAnimated:));

        swizzleInstanceMethod(UINavigationController.class,
                              @selector(popToViewController:animated:),
                              @selector(bm_test_popToViewController:animated:));

        swizzleInstanceMethod(UINavigationController.class,
                              @selector(popToRootViewControllerAnimated:),
                              @selector(bm_test_popToRootViewControllerAnimated:));
    });
}

- (UIViewController *)bm_test_popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [self bm_test_popViewControllerAnimated:YES];
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (vc == obj.memoryLeakDeallocModel.controller) {
            obj.memoryLeakDeallocModel.shouldDealloc = YES;
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update ui
        [UIViewController udpateUI];
    });
    return vc;
}

- (NSArray<UIViewController *> *)bm_test_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *vcs = [self bm_test_popToViewController:viewController animated:animated];
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1 == obj.memoryLeakDeallocModel.controller) {
                obj.memoryLeakDeallocModel.shouldDealloc = YES;
            }
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update ui
        [UIViewController udpateUI];
    });
    return vcs;
}

- (NSArray<UIViewController *> *)bm_test_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *vcs = [self bm_test_popToRootViewControllerAnimated:animated];
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1 == obj.memoryLeakDeallocModel.controller) {
                obj.memoryLeakDeallocModel.shouldDealloc = YES;
            }
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update ui
        [UIViewController udpateUI];
    });
    return vcs;
}

@end
