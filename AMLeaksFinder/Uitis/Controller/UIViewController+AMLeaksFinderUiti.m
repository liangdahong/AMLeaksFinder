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

#import "UIViewController+AMLeaksFinderUiti.h"
#import <objc/runtime.h>
#import "UIViewController+AMLeaksFinderUI.h"
#import "AMMemoryLeakModel.h"
#import "UIView+AMLeaksFinderTools.h"
#import "NSObject+RunLoop.h"

@implementation UIViewController (AMLeaksFinderUiti)

+ (__kindof UIViewController *)amleaks_finder_TopViewController {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    UIViewController *topvc = window.rootViewController;
    while (topvc.presentedViewController) {
        topvc = topvc.presentedViewController;
    }
    return topvc;
}

/// 参考自 SVP
+ (__kindof UIWindow *)amleaks_finder_TopWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal
                                     && window.windowLevel <= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return UIApplication.sharedApplication.keyWindow;
}

@end

#endif
