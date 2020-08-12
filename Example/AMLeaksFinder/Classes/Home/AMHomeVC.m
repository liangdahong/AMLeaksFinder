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
#import "AMLeaksFinder-Swift.h"

@implementation AMHomeVC

- (IBAction)pushNoLeakButtonClick {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"类型选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OC" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:AMPushNoLeakVC.new animated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Swift" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self.navigationController pushViewController:PushNoLeakVC.new animated:YES];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)pushHasLeakButtonClick {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"类型选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OC" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:AMPushHasLeakVC.new animated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Swift" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self.navigationController pushViewController:PushHasLeakVC.new animated:YES];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
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
