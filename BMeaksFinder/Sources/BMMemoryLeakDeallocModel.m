//
//  BMMemoryLeakDeallocModel.m
//  BMeaksFinder
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMMemoryLeakDeallocModel.h"
#import "UIViewController+BMMemoryLeakUI.h"
#import "BMMemoryLeakModel.h"

@implementation BMMemoryLeakDeallocModel

- (void)dealloc {
    [UIViewController.memoryLeakModelArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.memoryLeakDeallocModel == self
            || !obj.memoryLeakDeallocModel) {
            [UIViewController.memoryLeakModelArray removeObjectAtIndex:idx];
         }
    }];
    [UIViewController udpateUI];
}

@end
