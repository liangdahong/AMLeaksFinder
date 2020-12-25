//
//  AMViewMemoryLeakModel.h
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/12/25.
//

#import <Foundation/Foundation.h>
#import "AMViewMemoryLeakDeallocModel.h"

@interface AMViewMemoryLeakModel : NSObject

@property (nonatomic, weak) AMViewMemoryLeakDeallocModel *viewMemoryLeakDeallocModel;

@end
