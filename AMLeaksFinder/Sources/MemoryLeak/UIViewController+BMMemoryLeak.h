//
//  UIViewController+BMMemoryLeak.h
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMMemoryLeakModel.h"

void swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@interface UIViewController (BMMemoryLeak)

@property (class, nonatomic, strong, readonly) NSMutableArray <BMMemoryLeakModel *> *memoryLeakModelArray; ///< memoryLeakModelArray

@property (nonatomic, strong, readonly) NSArray <UIViewController *> *bm_test_selfAndAllChildController;

@end
