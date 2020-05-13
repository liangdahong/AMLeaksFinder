//
//  BMErrorVC.m
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/13.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMErrorVC.h"
#import "BMTopView.h"

@interface BMErrorVC ()

@property (weak, nonatomic) IBOutlet BMTopView *topView;

@end

@implementation BMErrorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.didClickBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
}

@end
