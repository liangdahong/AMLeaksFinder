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

#import "UIView+AMLeaksFinderTools.h"
#import <objc/runtime.h>
#import "AMViewMemoryLeakDeallocModel.h"
#import "AMViewMemoryLeakModel.h"
#import "UIViewController+AMLeaksFinderTools.h"
#import "UIViewController+AMLeaksFinderUI.h"

@implementation UIView (AMLeaksFinderTools)

/// 返回 【自己】+【自己所有的子子孙孙 view 】组成的数组
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
}

- (void)amleaks_finder_shouldDeallocWithVC:(UIViewController *)vc {
    
    NSString *name = [NSString stringWithUTF8String:class_getName(self.class)];
    for (NSString *ele in AMLeaksFinder.ignoreViewClassNameSet) {
        if ([name rangeOfString:ele].location != NSNotFound) {
            // 忽略
            return;
        }
    }
    
    [self.amleaks_finder_selfAndAllChildViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *name = [NSString stringWithUTF8String:class_getName(obj.class)];
        for (NSString *ele in AMLeaksFinder.ignoreViewClassNameSet) {
            if ([name rangeOfString:ele].location != NSNotFound) {
                // 忽略
                return;
            }
        }
        
        AMViewMemoryLeakDeallocModel *deallocModel = objc_getAssociatedObject(obj, _cmd);
        if (deallocModel) {
            return;
        }
        deallocModel = AMViewMemoryLeakDeallocModel.new;
        objc_setAssociatedObject(obj, _cmd, deallocModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        deallocModel.view = obj;
        deallocModel.shouldDeallocDate = NSDate.new;
        
        AMViewMemoryLeakModel *memoryLeakModel = AMViewMemoryLeakModel.new;
        memoryLeakModel.vcName = NSStringFromClass(vc.class);
        memoryLeakModel.viewMemoryLeakDeallocModel = deallocModel;
        [UIViewController.viewMemoryLeakModelArray insertObject:memoryLeakModel atIndex:0];
    }];
}

- (void)amleaks_finder_normal {
    __block BOOL flag = NO;
    [self.amleaks_finder_selfAndAllChildViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIViewController.viewMemoryLeakModelArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(AMViewMemoryLeakModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.viewMemoryLeakDeallocModel.view == obj ) {
                // 清除需要 dealloc 记录
                [UIViewController.viewMemoryLeakModelArray removeObjectAtIndex:idx1];
                // 解除 dealloc 绑定
                objc_setAssociatedObject(obj,
                                         @selector(amleaks_finder_shouldDealloc),
                                         nil,
                                         OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                flag = YES;
            }
        }];
    }];
}

- (UIView *)rootView {
    UIView *rootView = self;
    while (rootView.superview != nil) {
        rootView = rootView.superview;
    }
    return rootView;
}

- (nullable UIViewController *)aml_currentController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

@end

#endif
