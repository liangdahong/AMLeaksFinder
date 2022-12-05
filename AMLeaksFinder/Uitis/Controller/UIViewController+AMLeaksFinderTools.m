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

#import "AMLeaksFinder.h"

#ifdef __AUTO_MEMORY_LEAKS_FINDER_ENABLED__

#import "UIViewController+AMLeaksFinderTools.h"
#import <objc/runtime.h>
#import "UIViewController+AMLeaksFinderUI.h"
#import "AMMemoryLeakModel.h"
#import "UIView+AMLeaksFinderTools.h"
#import "NSObject+RunLoop.h"

static const void * const associatedKey = &associatedKey;

void am_fi_sw_in_me(Class clas,
                    SEL originalSelector,
                    SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(clas, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clas, swizzledSelector);
    if (class_addMethod(clas, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(clas, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIViewController (AMLeaksFinderTools)

+ (NSMutableArray<AMViewMemoryLeakModel *> *)viewMemoryLeakModelArray {
    static NSMutableArray <AMViewMemoryLeakModel *> *arr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[].mutableCopy;
    });
    return arr;
}

+ (NSMutableArray<AMMemoryLeakModel *> *)memoryLeakModelArray {
    static NSMutableArray <AMMemoryLeakModel *> *arr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[].mutableCopy;
    });
    return arr;
}

+ (NSMutableString *)vcPath {
    static NSMutableString *vcPathStr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vcPathStr = [@"" mutableCopy];
    });
    return vcPathStr;
}

+ (NSMutableArray<AMVCPathModel *> *)vcPathModels {
    static NSMutableArray <AMVCPathModel *> *arr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[].mutableCopy;
    });
    return arr;
}

/// 返回 【自己】+【自己所有的子子孙孙控制器】组成的数组
- (NSArray<UIViewController *> *)amleaks_finder_selfAndAllChildController {
    NSMutableArray *arr = @[self].mutableCopy;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObjectsFromArray:obj.amleaks_finder_selfAndAllChildController.copy];
    }];
    return arr.copy;
}

- (void)amleaks_finder_DidDisappear {
    NSString *name = [NSString stringWithUTF8String:class_getName(self.class)];
    for (NSString *ele in AMLeaksFinder.ignoreVCClassNameSet) {
        if ([name rangeOfString:ele].location != NSNotFound) {
            // 忽略
            return;
        }
    }
    
    [NSObject performTaskOnDefaultRunLoopMode:^{
        [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.memoryLeakDeallocModel.controller == self
                && obj1.memoryLeakDeallocModel.shouldDealloc == YES) {
                obj1.memoryLeakDeallocModel.shouldDeallocDate = NSDate.new;
                // 获取控制器的 view 以及所有 子子孙孙 view
                UIViewController *vc = obj1.memoryLeakDeallocModel.controller;
                [vc.view amleaks_finder_shouldDeallocWithVC:vc];
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // update ui
            [UIViewController udpateUI];
        });
    }];
}

- (void)amleaks_finder_self_shouldDealloc {
    NSString *name = [NSString stringWithUTF8String:class_getName(self.class)];
    for (NSString *ele in AMLeaksFinder.ignoreVCClassNameSet) {
        if ([name rangeOfString:ele].location != NSNotFound) {
            // 忽略
            return;
        }
    }
    [NSObject performTaskOnDefaultRunLoopMode:^{
        [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.memoryLeakDeallocModel.controller == self) {
                obj1.memoryLeakDeallocModel.shouldDealloc = YES;
                obj1.memoryLeakDeallocModel.shouldDeallocDate = [NSDate.new initWithTimeIntervalSinceNow:MAXFLOAT];
            }
        }];
    }];
}

- (void)amleaks_finder_shouldDealloc {
    NSString *name = [NSString stringWithUTF8String:class_getName(self.class)];
    for (NSString *ele in AMLeaksFinder.ignoreVCClassNameSet) {
        if ([name rangeOfString:ele].location != NSNotFound) {
            // 忽略
            return;
        }
    }
    [NSObject performTaskOnDefaultRunLoopMode:^{
        [self.amleaks_finder_selfAndAllChildController enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj amleaks_finder_self_shouldDealloc];
        }];
    }];
}

+ (void)amleaks_finder_shouldAllDeallocBesidesController:(UIViewController *)controller
                                                  window:(UIWindow *)window
                                                   newVC:(UIViewController *)newVC {
    NSMutableSet *oldSet = [NSMutableSet setWithArray:controller.amleaks_finder_selfAndAllChildController];
    NSMutableSet *newSet = [NSMutableSet setWithArray:newVC.amleaks_finder_selfAndAllChildController];
    
    NSMutableSet *notDeallocSet = [NSMutableSet set];
    [oldSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([newSet containsObject:obj]) {
            [notDeallocSet addObject:obj];
        }
    }];
    
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 控制器的窗口是当前的窗口 或者 [ 当前的控制器没有窗口 这个条件不应该需要 fix: https://github.com/liangdahong/AMLeaksFinder/issues/8  ]
        // && 这个控制器没有在准备重新设置 root vc 中
        if (obj.memoryLeakDeallocModel.controller.view.window == window
            && ![notDeallocSet containsObject:obj.memoryLeakDeallocModel.controller]) {
            [obj.memoryLeakDeallocModel.controller amleaks_finder_self_shouldDealloc];
        }
    }];
}

- (void)amleaks_finder_normal {
    [NSObject performTaskOnDefaultRunLoopMode:^{
        __block BOOL flag = NO;
        [self.amleaks_finder_selfAndAllChildController
         enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj,
                                      NSUInteger idx,
                                      BOOL * _Nonnull stop) {
            [UIViewController.memoryLeakModelArray
             enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj1,
                                          NSUInteger idx1,
                                          BOOL * _Nonnull stop1) {
                if (obj1.memoryLeakDeallocModel.controller == obj
                    && obj1.memoryLeakDeallocModel.shouldDealloc) {
                    // 如果控制器已经设置为将要释放
                    // 就改为正常
                    obj1.memoryLeakDeallocModel.shouldDealloc = NO;
                    // views 设置为正常
                    [obj1.memoryLeakDeallocModel.controller.view amleaks_finder_normal];
                    flag = YES;
                }
            }];
        }];
        if (flag) {
            // update ui
            [UIViewController udpateUI];
        }
    }];
}

@end

#endif
