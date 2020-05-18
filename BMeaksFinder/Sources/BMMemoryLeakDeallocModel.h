//
//  BMMemoryLeakDeallocModel.h
//  BMeaksFinder
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMMemoryLeakDeallocModel : NSObject

@property (nonatomic, weak) UIViewController *controller; ///< controller
@property (nonatomic, assign) BOOL shouldDealloc; ///< 应该释放了

@end
