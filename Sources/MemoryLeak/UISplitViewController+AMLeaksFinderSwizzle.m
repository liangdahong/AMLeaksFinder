//
//  UISplitViewController+AMLeaksFinderSwizzle.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/20.
//

#import "UISplitViewController+AMLeaksFinderSwizzle.h"
#import "UIViewController+AMLeaksFinderUI.h"
#import "UIViewController+AMLeaksFinderTools.h"

@implementation UISplitViewController (AMLeaksFinderSwizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
                *stop1 = YES;
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

@end
