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

// v: 2.2.8

// 👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
// 打开宏表示【 启用内存泄漏监控 】
#define __AUTO_MEMORY_LEAKS_FINDER_ENABLED__
// 👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆

#ifdef __AUTO_MEMORY_LEAKS_FINDER_ENABLED__

#import "AMMemoryLeakModel.h"
#import "AMViewMemoryLeakModel.h"

typedef void(^AMLeakCallback)(NSArray <AMMemoryLeakModel *> * _Nonnull controllerMemoryLeakModels,
                              NSArray <AMViewMemoryLeakModel *> * _Nonnull viewMemoryLeakModels);

typedef void(^AMLVCPathCallback)(NSArray <AMVCPathModel *> * _Nonnull all, AMVCPathModel* _Nonnull current);

@interface AMLeaksFinder : NSObject

/// vc 操作路径
@property (class, readonly) NSArray <AMVCPathModel *> *currentAllVCPathModels;

/// vc 泄漏数据
@property (class, readonly) NSArray <AMMemoryLeakModel *> *leakVCModelArray;

/// view 泄漏数据
@property (class, readonly) NSArray <AMViewMemoryLeakModel *> *leakViewModelArray;

/// 添加泄漏数据回调
/// @param callback block
+ (void)addLeakCallback:(nonnull AMLeakCallback)callback;

/// 控制器路径变化回调
/// @param callback block
+ (void)addVCPathChangedCallback:(nonnull AMLVCPathCallback)callback;

+ (nonnull NSArray <AMLeakCallback> *)callbacks;
+ (nonnull NSArray <AMLVCPathCallback> *)vcPathCallbacks;

// controller 泄漏白名单, 仅用于【泄漏数据回调的过滤】,【泄漏数据实时 UI 状态】暂无此计划
@property (class) NSSet <NSString *> * _Nullable controllerWhitelistClassNameSet;
// view 泄漏白名单, 仅用于【泄漏数据回调的过滤】, 【泄漏数据实时 UI 状态】暂无此计划
@property (class) NSSet <NSString *> * _Nullable viewWhitelistClassNameSet;

@property (class) NSSet <NSString *> * _Nullable ignoreVCClassNameSet;
@property (class) NSSet <NSString *> * _Nullable ignoreViewClassNameSet;

@end

#endif
