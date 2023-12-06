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

static NSMutableArray <AMLeakCallback> *blocks = nil;
static NSMutableArray <AMLVCPathCallback> *vcPathCallbacks = nil;
static NSSet <NSString *> *_controllerWhitelistClassNameSet = nil;
static NSSet <NSString *> *_viewWhitelistClassNameSet = nil;
static NSSet <NSString *> *_ignoreVCClassNameSet = nil;
static NSSet <NSString *> *_ignoreViewClassNameSet = nil;

@implementation AMLeaksFinder

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blocks = @[].mutableCopy;
        vcPathCallbacks = @[].mutableCopy;
    });
}

+ (NSArray<AMVCPathModel *> *)currentAllVCPathModels {
    return UIViewController.vcPathModels;
}

+ (NSArray<AMMemoryLeakModel *> *)leakVCModelArray {
    return UIViewController.memoryLeakModelArray;
}

+ (NSArray<AMViewMemoryLeakModel *> *)leakViewModelArray {
    return UIViewController.viewMemoryLeakModelArray;
}

+ (void)addLeakCallback:(AMLeakCallback)callback {
    if (blocks == nil) { blocks = @[].mutableCopy; }
    [blocks addObject:callback];
}

+ (NSArray <AMLeakCallback> *)callbacks {
    return blocks;
}

+ (void)addVCPathChangedCallback:(nonnull AMLVCPathCallback)callback {
    if (vcPathCallbacks == nil) { vcPathCallbacks = @[].mutableCopy; }
    [vcPathCallbacks addObject:callback];
}

+ (nonnull NSArray <AMLVCPathCallback> *)vcPathCallbacks {
    return vcPathCallbacks;
}

+ (NSSet<NSString *> *)controllerWhitelistClassNameSet {
    return _controllerWhitelistClassNameSet;
}

+ (void)setControllerWhitelistClassNameSet:(NSSet<NSString *> *)controllerWhitelistClassNameSet {
    _controllerWhitelistClassNameSet = controllerWhitelistClassNameSet;
}

+ (NSSet<NSString *> *)viewWhitelistClassNameSet {
    return _viewWhitelistClassNameSet;
}

+ (void)setViewWhitelistClassNameSet:(NSSet<NSString *> *)viewWhitelistClassNameSet {
    _viewWhitelistClassNameSet = viewWhitelistClassNameSet;
}

+ (NSSet<NSString *> *)ignoreVCClassNameSet {
    return _ignoreVCClassNameSet;
}

+ (void)setIgnoreVCClassNameSet:(NSSet<NSString *> *)ignoreVCClassNameSet {
    _ignoreVCClassNameSet = ignoreVCClassNameSet;
}

+ (NSSet<NSString *> *)ignoreViewClassNameSet {
    return _ignoreViewClassNameSet;
}

+ (void)setIgnoreViewClassNameSet:(NSSet<NSString *> *)ignoreViewClassNameSet {
    _ignoreViewClassNameSet = ignoreViewClassNameSet;
}

@end

#endif
