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

//#import "UIWindow+AMLeaksFinderSwizzleDealloc.h"
//#import "AMMemoryLeakModel.h"
//#import "UIViewController+AMLeaksFinderTools.h"
//
//@implementation UIWindow (AMLeaksFinderSwizzleDealloc)
//
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        swizzleInstanceMethod(self.class,
//                              @selector(setRootViewController:),
//                              @selector(bm_test_setRootViewController:)
//                              );
//    });
//}
//
//- (void)bm_test_setRootViewController:(UIViewController *)rootViewController {
//    if (UIApplication.sharedApplication.delegate.window == self
//        && self.isKeyWindow
//        && !self.hidden
//        && self.alpha > 0.1
//        && self.screen == UIScreen.mainScreen
//        && self.windowLevel >= UIWindowLevelNormal
//        && self.userInteractionEnabled
//        && self.rootViewController
//        ) {
//        // 所有的控制器都应该释放
//        //  [UIViewController bm_test_shouldAllDealloc];
//        // [self.rootViewController bm_test_shouldDealloc];
//    }
//          
//    [self bm_test_setRootViewController:rootViewController];
//}
//
//@end
