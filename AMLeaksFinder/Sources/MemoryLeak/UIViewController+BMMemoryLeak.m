//
//  UIViewController+BMMemoryLeak.m
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "UIViewController+BMMemoryLeak.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIViewController+BMMemoryLeakUI.h"
#import "BMMemoryLeakModel.h"

void swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    // 1.获取旧 Method
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    // 2.获取新 Method
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // 3.交换方法
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static void *associatedKey = &associatedKey;

@implementation UIViewController (BMMemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(UIViewController.class,
                              @selector(viewDidLoad),
                              @selector(bm_test_viewDidLoad));

        swizzleInstanceMethod(UIViewController.class,
                              @selector(dismissViewControllerAnimated:completion:),
                              @selector(bm_test_dismissViewControllerAnimated:completion:));

    });
}

- (void)bm_test_viewDidLoad {
    [self bm_test_viewDidLoad];
    BMMemoryLeakDeallocModel *deallocModel = objc_getAssociatedObject(self, associatedKey);
    if (deallocModel) {
        return;
    }
    deallocModel = BMMemoryLeakDeallocModel.new;
    objc_setAssociatedObject(self, associatedKey, deallocModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    deallocModel.controller = self;
    
    // memoryLeakModel
    BMMemoryLeakModel *memoryLeakModel = BMMemoryLeakModel.new;
    memoryLeakModel.memoryLeakDeallocModel = deallocModel;
    [UIViewController.memoryLeakModelArray insertObject:memoryLeakModel atIndex:0];

    // update ui
    [UIViewController udpateUI];
}

- (void)bm_test_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [self bm_test_dismissViewControllerAnimated:flag completion:completion];
    UIViewController *dismissedViewController = self.presentedViewController;
    if (!dismissedViewController && self.presentingViewController) {
        dismissedViewController = self;
    }
    if (!dismissedViewController) {
        return;
    }
    
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.memoryLeakDeallocModel.controller == dismissedViewController) {
            obj.memoryLeakDeallocModel.shouldDealloc = YES;
            *stop = YES;
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // update ui
        [UIViewController udpateUI];
    });
    NSLog(@"bm_test_dismissViewControllerAnimated: %@", self);
}

+ (NSMutableArray<BMMemoryLeakModel *> *)memoryLeakModelArray {
    static NSMutableArray <BMMemoryLeakModel *> *arr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[].mutableCopy;
    });
    [arr enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.memoryLeakDeallocModel.controller) {
            [arr removeObjectAtIndex:idx];
        }
    }];
    return arr;
}

- (NSArray<UIViewController *> *)bm_test_selfAndAllChildController {
    NSMutableArray *arr = @[self].mutableCopy;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObjectsFromArray:obj.bm_test_selfAndAllChildController.copy];
    }];
    return arr.copy;
}

@end
