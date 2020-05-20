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
#import "UIViewController+AMLeaksFinderTools.h"

@implementation UITabBarController (BMMemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(self.class,
                              @selector(setViewControllers:),
                              @selector(bm_test_setViewControllers:));
        
        swizzleInstanceMethod(self.class,
                              @selector(setViewControllers:animated:),
                              @selector(bm_test_setViewControllers:animated:));
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
            [muarray addObject:obj];
        }
    }];
    [muarray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bm_test_shouldDealloc];
    }];
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
            [muarray addObject:obj];
        }
    }];
    [muarray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bm_test_shouldDealloc];
    }];
    [self bm_test_setViewControllers:viewControllers animated:animated];
}

@end
