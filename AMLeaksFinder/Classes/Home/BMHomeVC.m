//
//  ViewController.m
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/13.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMHomeVC.h"
#import "BMErrorVC.h"
#import "BMCorrectVC.h"

@implementation BMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)noLeakButtonClick {
    [self.navigationController pushViewController:BMCorrectVC.new animated:YES];
}

- (IBAction)leakButtonClick {
    [self.navigationController pushViewController:BMErrorVC.new animated:YES];
}

@end
