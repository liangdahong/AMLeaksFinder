//
//  AMViewMemoryLeakDeallocModel.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/12/25.
//

#import "AMViewMemoryLeakDeallocModel.h"
#import "UIViewController+AMLeaksFinderTools.h"
#import "UIViewController+AMLeaksFinderUI.h"
#import "AMMemoryLeakModel.h"
#import "UIViewController+AMLeaksFinderTools.h"

@implementation AMViewMemoryLeakDeallocModel

- (void)dealloc {
    [UIViewController.viewMemoryLeakModelArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AMViewMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.viewMemoryLeakDeallocModel == self) {
            [UIViewController.viewMemoryLeakModelArray removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [UIViewController udpateUI];
}

@end
