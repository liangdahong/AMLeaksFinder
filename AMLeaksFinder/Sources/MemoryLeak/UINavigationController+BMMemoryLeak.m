
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

- (UIViewController *)bm_test_popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [self bm_test_popViewControllerAnimated:YES];
    NSMutableArray <UIViewController *> *deallocs = vc.bm_test_selfAndAllChildController.mutableCopy;
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [deallocs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1 == obj.memoryLeakDeallocModel.controller) {
                obj.memoryLeakDeallocModel.shouldDealloc = YES;
                *stop1 = YES;
            }
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update ui
        [UIViewController udpateUI];
    });
    return vc;
}

- (NSArray<UIViewController *> *)bm_test_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *vcs = [self bm_test_popToViewController:viewController animated:animated];

    NSMutableArray *deallocs = @[].mutableCopy;
    [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [deallocs addObjectsFromArray:obj.bm_test_selfAndAllChildController];
    }];

    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [deallocs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1 == obj.memoryLeakDeallocModel.controller) {
                obj.memoryLeakDeallocModel.shouldDealloc = YES;
                *stop1 = YES;
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
    NSArray <UIViewController *> *vcs = [self bm_test_popToRootViewControllerAnimated:animated];
    NSMutableArray *deallocs = @[].mutableCopy;
    [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [deallocs addObjectsFromArray:obj.bm_test_selfAndAllChildController];
    }];
    
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [deallocs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1 == obj.memoryLeakDeallocModel.controller) {
                obj.memoryLeakDeallocModel.shouldDealloc = YES;
                *stop1 = YES;
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
