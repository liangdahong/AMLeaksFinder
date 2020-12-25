//
//  UIView+AMLeaksFinderTools.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/12/25.
//

#import "UIView+AMLeaksFinderTools.h"
#import <objc/runtime.h>
#import "AMViewMemoryLeakDeallocModel.h"
#import "AMViewMemoryLeakModel.h"
#import "UIViewController+AMLeaksFinderTools.h"
#import "UIViewController+AMLeaksFinderUI.h"

@implementation UIView (AMLeaksFinderTools)


/// 返回 【自己】+【自己所有的子子孙孙控制器】组成的数组
- (NSArray<UIView *> *)amleaks_finder_selfAndAllChildViews {
    NSMutableArray <UIView *>*arr = @[self].mutableCopy;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObjectsFromArray:obj.amleaks_finder_selfAndAllChildViews.copy];
    }];
    return arr.copy;
}

- (void)amleaks_finder_IgnoredMemoryLeak {
    [self.amleaks_finder_selfAndAllChildViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIViewController.viewMemoryLeakModelArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(AMViewMemoryLeakModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.viewMemoryLeakDeallocModel.view == obj) {
                [UIViewController.viewMemoryLeakModelArray removeObjectAtIndex:idx1];
                *stop1 = YES;
            }
        }];
    }];
    [UIViewController udpateUI];
}

- (void)amleaks_finder_shouldDealloc {
    [self.amleaks_finder_selfAndAllChildViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMViewMemoryLeakDeallocModel *deallocModel = objc_getAssociatedObject(obj, _cmd);
        if (deallocModel) {
            deallocModel.shouldDealloc = YES;
            return;
        }
        deallocModel = AMViewMemoryLeakDeallocModel.new;
        deallocModel.shouldDealloc = YES;
        objc_setAssociatedObject(obj, _cmd, deallocModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        deallocModel.view = obj;
        
        AMViewMemoryLeakModel *memoryLeakModel = AMViewMemoryLeakModel.new;
        memoryLeakModel.viewMemoryLeakDeallocModel = deallocModel;
        [UIViewController.viewMemoryLeakModelArray insertObject:memoryLeakModel atIndex:0];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // view 应该销毁完毕
        [UIViewController udpateUI];
    });
}

@end
