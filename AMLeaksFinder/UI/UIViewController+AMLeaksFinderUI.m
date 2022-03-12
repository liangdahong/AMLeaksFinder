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

static AMMemoryLeakView *memoryLeakView;
static AMLeakOverviewView *leakOverviewView;

@implementation UIViewController (AMLeaksFinderUI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
            __block NSMutableArray <AMMemoryLeakDeallocModel *> *vcMemoryLeakDeallocModels = @[].mutableCopy;
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
            
            [AMLeaksFinder.callbacks enumerateObjectsUsingBlock:^(AMLeakCallback  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj(vcMemoryLeakDeallocModels, viewMemoryLeakModels);
            }];
        }];
    });
}

@end

#endif
