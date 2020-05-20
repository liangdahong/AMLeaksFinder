//
//  UIViewController+BMMemoryLeak.m
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "UIViewController+BMMemoryLeak.h"
#import "UIViewController+BMMemoryLeakUI.h"
#import "BMMemoryLeakModel.h"
#import "UIViewController+AMLeaksFinderTools.h"
#import <objc/runtime.h>

static void *associatedKey = &associatedKey;

@implementation UIViewController (BMMemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(self.class,
                              @selector(viewDidLoad),
                              @selector(bm_test_viewDidLoad));
        
        swizzleInstanceMethod(self.class,
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
    // 真实 dismissed 的控制器
    [dismissedViewController bm_test_shouldDealloc];
}

@end
