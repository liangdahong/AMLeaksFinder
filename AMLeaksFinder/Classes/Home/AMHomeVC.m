//
//  ViewController.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/13.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "AMHomeVC.h"
#import "AMPushNoLeakVC.h"
#import "AMPushHasLeakVC.h"
#import "AMPresentNoLeakVC.h"
#import "AMPresentHasLeakVC.h"

@implementation AMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)pushNoLeakButtonClick {
    [self.navigationController pushViewController:AMPushNoLeakVC.new animated:YES];
}

- (IBAction)pushHasLeakButtonClick {
    [self.navigationController pushViewController:AMPushHasLeakVC.new animated:YES];
}

- (IBAction)presentNoLeakButtonClick {
    [self presentViewController:AMPresentNoLeakVC.new animated:YES completion:nil];
}

- (IBAction)presentHasLeakButtonClick {
    [self presentViewController:AMPresentHasLeakVC.new animated:YES completion:nil];
}

@end
