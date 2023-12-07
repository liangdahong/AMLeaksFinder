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

#import "UIViewController+AMLeaksFinderUI.h"
#import "AMMemoryLeakView.h"
#import "UIViewController+AMLeaksFinderTools.h"
#import "AMLeakOverviewView.h"
#import "NSObject+RunLoop.h"
#import "UIView+AMLeaksFinderTools.h"
#import "UIViewController+AMLeaksFinderUiti.h"

static AMMemoryLeakView *memoryLeakView;
static AMLeakOverviewView *leakOverviewView;

NS_INLINE void performOnMainThread(dispatch_block_t block) {
	if (NSThread.isMainThread) {
		block();
	} else {
		dispatch_async(dispatch_get_main_queue(), ^{
			block();
		});
	}
};

@implementation UIViewController (AMLeaksFinderUI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		[NSNotificationCenter.defaultCenter addObserverForName:@"AMLeaksFinderShowUINotification"
														object:nil
														 queue:nil
													usingBlock:^(NSNotification * _Nonnull notification) {
            memoryLeakView.alpha = 1;
            leakOverviewView.alpha = 1;
		}];
		[NSNotificationCenter.defaultCenter addObserverForName:@"AMLeaksFinderHideUINotification"
														object:nil
														 queue:nil
													usingBlock:^(NSNotification * _Nonnull notification) {
            memoryLeakView.alpha = 0;
            leakOverviewView.alpha = 0;
		}];
		
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            NSBundle *bundle = [NSBundle bundleForClass:AMMemoryLeakView.class];
            memoryLeakView = [bundle loadNibNamed:NSStringFromClass(AMMemoryLeakView.class) owner:nil options:nil].firstObject;
            memoryLeakView.autoresizingMask = UIViewAutoresizingNone;
            memoryLeakView.frame = CGRectMake(30, 60, 320, 400);
            memoryLeakView.hidden = YES;
            
            leakOverviewView = AMLeakOverviewView.new;
            leakOverviewView.autoresizingMask = UIViewAutoresizingNone;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                UIWindow *window = UIViewController.amleaks_finder_TopWindow;
                [window addSubview:memoryLeakView];
                [window addSubview:leakOverviewView];
                leakOverviewView.showDetailsBlock = ^{
                    memoryLeakView.hidden = !memoryLeakView.isHidden;
                };
                [self udpateUI];
            });
        });
    });
}

+ (void)udpateUI {
    
    static BOOL isCallbacking = false;
    
    // 控制回调频率
    if (isCallbacking) { return; }
    
    isCallbacking = true;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        isCallbacking = false;
        [NSObject performTaskOnDefaultRunLoopMode:^{
            
            UIWindow *window = UIViewController.amleaks_finder_TopWindow;
            [window addSubview:memoryLeakView];
            [window addSubview:leakOverviewView];
            
            // 对已经正常释放的 controller 进行删除处理
            [UIViewController.memoryLeakModelArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(AMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.memoryLeakDeallocModel.controller) {
                    [UIViewController.memoryLeakModelArray removeObjectAtIndex:idx];
                }
            }];
            
            // 获取泄漏的 controller
            __block NSMutableArray <AMMemoryLeakModel *> *vcMemoryLeakDeallocModels = @[].mutableCopy;
            __block int leakCount = 0;
            [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.memoryLeakDeallocModel != nil
                    && obj.memoryLeakDeallocModel.shouldDealloc
                    && (NSDate.new.timeIntervalSince1970 - obj.memoryLeakDeallocModel.shouldDeallocDate.timeIntervalSince1970) > 3) {
                    [vcMemoryLeakDeallocModels addObject:obj];
                }
            }];
            
            // 对已经正常释放的 view 进行删除处理
            [UIViewController.viewMemoryLeakModelArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.viewMemoryLeakDeallocModel.view) {
                    [UIViewController.viewMemoryLeakModelArray removeObjectAtIndex:idx];
                }
            }];
            
            // 获取泄漏的 view 数量
            __block NSMutableArray <AMViewMemoryLeakModel *> *viewMemoryLeakModels = @[].mutableCopy;
            [UIViewController.viewMemoryLeakModelArray enumerateObjectsUsingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.viewMemoryLeakDeallocModel.view != nil
                    && (NSDate.new.timeIntervalSince1970 - obj.viewMemoryLeakDeallocModel.shouldDeallocDate.timeIntervalSince1970) > 3) {
                    [viewMemoryLeakModels addObject:obj];
                }
            }];
            memoryLeakView.viewMemoryLeakModelArray = viewMemoryLeakModels;
            [memoryLeakView setMemoryLeakModelArray:UIViewController.memoryLeakModelArray];
            
            AMLeakDataModel *model = [AMLeakDataModel new];
            model.vcLeakCount = (int)vcMemoryLeakDeallocModels.count;
            model.vcAllCount = (int)UIViewController.memoryLeakModelArray.count;
            model.viewLeakCount = (int)viewMemoryLeakModels.count;
            leakOverviewView.leakDataModel = model;
            
            // 获取增量泄漏的控制器
            NSMutableArray <AMMemoryLeakModel *> *leakVCModels = @[].mutableCopy;
            [vcMemoryLeakDeallocModels enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (!obj.isCallback) {
                    // 标记被回调
                    obj.isCallback = YES;
                    // 设置操作路径
                    obj.vcPathModels = UIViewController.vcPathModels.copy;
                    [leakVCModels addObject:obj];
                }
            }];
            
            // 获取所有泄漏 view 的 root 节点 view 组成的数据，root view 泄漏其子孙视图肯定泄漏
            NSMutableSet<AMViewMemoryLeakModel *> *rootViewSet = [NSMutableSet new];
            [viewMemoryLeakModels enumerateObjectsUsingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *rootView = obj.viewMemoryLeakDeallocModel.view.rootView;
                if (rootView != nil) {
                    // 找到 root view model
                    [viewMemoryLeakModels enumerateObjectsUsingBlock:^(AMViewMemoryLeakModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                        if (!obj1.isCallback
                            && obj1.viewMemoryLeakDeallocModel.view == rootView
                            && rootView.aml_currentController == nil) {
                            [rootViewSet addObject:obj1];
                            *stop1 = YES;
                        }
                    }];
                }
            }];
            
            // 获取由泄漏 root view 组成的数据
            NSMutableArray <AMViewMemoryLeakModel *> *leakRooViewModels = [NSMutableArray arrayWithCapacity:rootViewSet.count];
            [rootViewSet enumerateObjectsUsingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, BOOL * _Nonnull stop) {
                // 标记被回调
                obj.isCallback = YES;
                // 设置操作路径
                obj.vcPathModels = UIViewController.vcPathModels.copy;
                [leakRooViewModels addObject:obj];
            }];
            
            NSSet <NSString *> *viewWhitelistClassNameSet = AMLeaksFinder.viewWhitelistClassNameSet;
            NSSet <NSString *> *controllerWhitelistClassNameSet = AMLeaksFinder.controllerWhitelistClassNameSet;
            
            // controller 白名单过滤
            [leakVCModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *name = NSStringFromClass(obj.memoryLeakDeallocModel.controller.class);
                [controllerWhitelistClassNameSet enumerateObjectsUsingBlock:^(NSString * _Nonnull obj1, BOOL * _Nonnull stop1) {
                    if ([name containsString:obj1]) {
                        [leakVCModels removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                }];
            }];
            
            // view 白名单过滤
            [leakRooViewModels enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *name = NSStringFromClass(obj.viewMemoryLeakDeallocModel.view.class);
                [viewWhitelistClassNameSet enumerateObjectsUsingBlock:^(NSString * _Nonnull obj1, BOOL * _Nonnull stop1) {
                    if ([name containsString:obj1]) {
                        [leakRooViewModels removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                }];
            }];
            
            // 有增量泄漏才回调
            if (leakVCModels.count > 0 || leakRooViewModels.count > 0) {
                [AMLeaksFinder.callbacks enumerateObjectsUsingBlock:^(AMLeakCallback  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj(leakVCModels, leakRooViewModels);
                }];
            }
        }];
    });
}

@end

#endif
