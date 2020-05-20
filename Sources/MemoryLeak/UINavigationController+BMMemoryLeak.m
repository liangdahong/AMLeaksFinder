
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
#import "UIViewController+AMLeaksFinderTools.h"

@implementation UINavigationController (BMMemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(self.class,
                              @selector(popViewControllerAnimated:),
                              @selector(bm_test_popViewControllerAnimated:));

        swizzleInstanceMethod(self.class,
                              @selector(popToViewController:animated:),
                              @selector(bm_test_popToViewController:animated:));

        swizzleInstanceMethod(self.class,
                              @selector(popToRootViewControllerAnimated:),
                              @selector(bm_test_popToRootViewControllerAnimated:));

        swizzleInstanceMethod(self.class,
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
            [muarray addObject:obj];
        }
    }];
    [muarray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bm_test_shouldDealloc];
    }];
    
    [self bm_test_setViewControllers:viewControllers];
}

- (UIViewController *)bm_test_popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [self bm_test_popViewControllerAnimated:YES];
    [vc bm_test_shouldDealloc];
    return vc;
}

- (NSArray<UIViewController *> *)bm_test_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *vcs = [self bm_test_popToViewController:viewController animated:animated];
    [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bm_test_shouldDealloc];
    }];
    return vcs;
}

- (NSArray<UIViewController *> *)bm_test_popToRootViewControllerAnimated:(BOOL)animated {
    NSArray <UIViewController *> *vcs = [self bm_test_popToRootViewControllerAnimated:animated];
    [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj bm_test_shouldDealloc];
    }];
    return vcs;
}

@end
