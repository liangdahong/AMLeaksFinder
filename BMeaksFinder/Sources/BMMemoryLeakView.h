//
//  BMMemoryLeakView.h
//  BMeaksFinder
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMMemoryLeakModel.h"

@interface BMMemoryLeakView : UIView

@property (nonatomic, copy) NSArray <BMMemoryLeakModel *> *memoryLeakModelArray;

@end
