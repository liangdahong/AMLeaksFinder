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

#import <UIKit/UIKit.h>
#import "AMMemoryLeakModel.h"

void swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@interface UIViewController (AMLeaksFinderTools)

/// 全局管理控制器的 Array
@property (class, nonatomic, strong, readonly) NSMutableArray <AMMemoryLeakModel *> *memoryLeakModelArray;
/// 控制器标记准备释放
- (void)bm_test_shouldDealloc;
/// 所有控制器标记为准备释放
+ (void)bm_test_shouldAllDealloc;

@property (class, nonatomic, strong, readonly) __kindof UIViewController *bm_test_TopViewController;
@property (class, nonatomic, strong, readonly) __kindof UIWindow *bm_test_TopWindow;

@end
