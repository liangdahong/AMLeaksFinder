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

#import "AppDelegate.h"
#import "AMHomeVC.h"
#import "BMNavigationController.h"
#import "AMTabBarController.h"
#import "UIViewController+AMLeaksFinderTools.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AMLeaksFinder.controllerWhitelistClassNameSet = [NSSet setWithObjects:@"WhitelistVC", nil];
    AMLeaksFinder.viewWhitelistClassNameSet = [NSSet setWithObjects:@"MyView", nil];
    // AMLeaksFinder.ignoreVCClassNameSet = [NSSet setWithObjects:@"PushHasLeakVC", nil];
    // AMLeaksFinder.ignoreViewClassNameSet = [NSSet setWithObjects:@"View", nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *nav = [[BMNavigationController alloc] initWithRootViewController:[AMHomeVC new]];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.hidden = NO;
    
    AMTabBarController *tabVC = [[AMTabBarController alloc] init];
    tabVC.viewControllers = @[nav];
    self.window.rootViewController = tabVC;
        
    [AMLeaksFinder addLeakCallback:^(NSArray<AMMemoryLeakModel *> * _Nonnull controllerMemoryLeakModels, NSArray<AMViewMemoryLeakModel *> * _Nonnull viewMemoryLeakModels) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"泄漏回调 - VC 泄漏数量：%@ View 泄漏数量：%@", @(controllerMemoryLeakModels.count), @(viewMemoryLeakModels.count)]];
        [controllerMemoryLeakModels enumerateObjectsUsingBlock:^(AMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *vc = obj.memoryLeakDeallocModel.controller;
            if (vc != nil) {
                NSMutableString *str = @"".mutableCopy;
                [obj.vcPathModels enumerateObjectsUsingBlock:^(AMVCPathModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [str appendFormat:@"%@(%@) -> \n", obj.vcName, NSStringFromSelector(obj.sel)];
                }];
                printf("\n%s", [NSString stringWithFormat:@"⚠️👇🏻\n控制器泄漏:%@ \n操作路径:\n%@⚠️👆🏻\n", vc, str].UTF8String);
            }
        }];
        
        [viewMemoryLeakModels enumerateObjectsUsingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *view = obj.viewMemoryLeakDeallocModel.view;
            if (view != nil) {
                NSMutableString *str = @"".mutableCopy;
                [obj.vcPathModels enumerateObjectsUsingBlock:^(AMVCPathModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [str appendFormat:@"%@(%@) -> \n", obj.vcName, NSStringFromSelector(obj.sel)];
                }];
                printf("\n%s", [NSString stringWithFormat:@"⚠️👇🏻\n视图泄漏:%@ \n视图所在控制器 %@ \n操作路径:\n%@⚠️👆🏻\n", view, obj.vcName, str].UTF8String);
            }
        }];
    }];
    
    [AMLeaksFinder addVCPathChangedCallback:^(NSArray<AMVCPathModel *> * _Nonnull all, AMVCPathModel * _Nonnull current) {
        printf("\n%s", [NSString stringWithFormat:@"控制器路径变化%@ %@ %@", current.vcName, NSStringFromSelector(current.sel), current.date].UTF8String);
    }];
    
    return YES;
}

@end
