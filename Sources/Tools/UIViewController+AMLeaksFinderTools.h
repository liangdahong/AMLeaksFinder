//
//  UIViewController+AMLeaksFinderTools.h
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/20.
//

#import <UIKit/UIKit.h>
#import "BMMemoryLeakModel.h"

void swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@interface UIViewController (AMLeaksFinderTools)

/// 全局管理控制器的 Array
@property (class, nonatomic, strong, readonly) NSMutableArray <BMMemoryLeakModel *> *memoryLeakModelArray;
/// 控制器标记准备释放
- (void)bm_test_shouldDealloc;

@end
