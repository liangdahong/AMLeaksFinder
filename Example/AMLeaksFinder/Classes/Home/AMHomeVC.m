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
#import "BMNavigationController.h"

@implementation AMHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    NSLog(@"AMHomeVC dealloc");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIApplication.sharedApplication.delegate.window.rootViewController =  [[BMNavigationController alloc] initWithRootViewController:[AMHomeVC new]];
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

- (IBAction)chanedRootVCClick {
    UIApplication.sharedApplication.delegate.window.rootViewController = [[BMNavigationController alloc] initWithRootViewController:[AMHomeVC new]];
}

@end
