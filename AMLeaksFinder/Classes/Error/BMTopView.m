//
//  BMTopView.m
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/13.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMTopView.h"
#import "XXNibBridge.h"

@interface BMTopView () <XXNibBridge>

@end

@implementation BMTopView

- (IBAction)buttonClick {
    !_didClickBlock ? : _didClickBlock();
}

@end
