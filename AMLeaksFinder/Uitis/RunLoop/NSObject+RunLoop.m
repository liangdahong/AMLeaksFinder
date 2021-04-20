//
//  NSObject+RunLoop.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2021/4/20.
//

#import "NSObject+RunLoop.h"

@implementation NSObject (RunLoop)

+ (void)performTaskOnDefaultRunLoopMode:(dispatch_block_t)block {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self performSelector:@selector(_performTask:)
                   withObject:block
                   afterDelay:0.0
                      inModes:@[NSDefaultRunLoopMode]];
    });
}

+ (void)_performTask:(dispatch_block_t)block {
    !block ? : block();
}

@end
