//
//  UIView+AMLeaksFinderTools.h
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/12/25.
//

#import <UIKit/UIKit.h>

@interface UIView (AMLeaksFinderTools)

/// 标记需要销毁
- (void)amleaks_finder_shouldDealloc;
// 标记为忽略的内存泄露
- (void)amleaks_finder_IgnoredMemoryLeak;

@end
