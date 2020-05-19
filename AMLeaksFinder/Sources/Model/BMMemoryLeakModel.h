//
//  BMMemoryLeakModel.h
//  BMeaksFinder
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMemoryLeakDeallocModel.h"

@interface BMMemoryLeakModel : NSObject

@property (nonatomic, weak) BMMemoryLeakDeallocModel *memoryLeakDeallocModel; ///< memoryLeakDeallocModel

@end
