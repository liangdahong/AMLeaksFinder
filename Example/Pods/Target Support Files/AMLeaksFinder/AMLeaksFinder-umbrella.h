#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UINavigationController+AMLeaksFinderSwizzleDealloc.h"
#import "UIPageViewController+AMLeaksFinderSwizzleDealloc.h"
#import "UISplitViewController+AMLeaksFinderSwizzleDealloc.h"
#import "UITabBarController+AMLeaksFinderSwizzleDealloc.h"
#import "UIViewController+AMLeaksFinderSwizzleDealloc.h"
#import "UIWindow+AMLeaksFinderSwizzleDealloc.h"
#import "UIViewController+AMLeaksFinderSwizzleViewDidLoad.h"
#import "AMMemoryLeakDeallocModel.h"
#import "AMMemoryLeakModel.h"
#import "UIViewController+AMLeaksFinderTools.h"
#import "AMDragViewLabel.h"
#import "AMMemoryLeakView.h"
#import "UIViewController+AMLeaksFinderUI.h"

FOUNDATION_EXPORT double AMLeaksFinderVersionNumber;
FOUNDATION_EXPORT const unsigned char AMLeaksFinderVersionString[];

