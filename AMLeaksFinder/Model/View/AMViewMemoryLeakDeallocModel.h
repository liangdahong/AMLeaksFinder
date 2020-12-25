//
//  AMViewMemoryLeakDeallocModel.h
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AMViewMemoryLeakDeallocModel : NSObject

@property (nonatomic, weak) UIView *view;
@property (nonatomic, assign) BOOL shouldDealloc; ///< 应该释放了

@end

