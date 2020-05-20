//    MIT License
//
//    Copyright (c) 2020 梁大红
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

#import "UINavigationController+AMLeaksFinderSwizzle.h"
#import "UIViewController+AMLeaksFinderUI.h"
#import "UIViewController+AMLeaksFinderTools.h"

@implementation UINavigationController (AMLeaksFinderSwizzle)

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
