//
//  AMLeakDataModel.h
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/12/26.
//

#import <Foundation/Foundation.h>

@interface AMLeakDataModel : NSObject

@property (nonatomic, assign) int vcLeakCount;
@property (nonatomic, assign) int vcAllCount;

@property (nonatomic, assign) int viewLeakCount;

@end
