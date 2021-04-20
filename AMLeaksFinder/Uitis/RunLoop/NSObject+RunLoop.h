//
//  NSObject+RunLoop.h
//  AMLeaksFinder
//
//  Created by liangdahong on 2021/4/20.
//

#import <Foundation/Foundation.h>

@interface NSObject (RunLoop)

+ (void)performTaskOnDefaultRunLoopMode:(dispatch_block_t)block;

@end
