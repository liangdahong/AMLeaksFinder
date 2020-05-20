//
//  AMTopView.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/13.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "AMTopView.h"

@implementation AMTopView

- (IBAction)buttonClick {
    !_didClickBlock ? : _didClickBlock();
}

@end
