//
//  AMTopView.h
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/13.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTopView : UIView

@property (nonatomic, copy) dispatch_block_t didClickBlock; ///< didClickBlock

@end
