//
//  BMCorrectVC.m
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/13.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMCorrectVC.h"
#import "BMTopView.h"

@interface BMCorrectVC ()

@property (weak, nonatomic) IBOutlet BMTopView *topView;

@end

@implementation BMCorrectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.topView.didClickBlock = ^{
        __strong typeof(self) self = weakSelf;
        [self.navigationController popViewControllerAnimated:YES];
    };
}

@end
