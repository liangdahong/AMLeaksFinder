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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"测试" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@".viewControllers = @[self.navigationController.viewControllers.firstObject" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@".viewControllers = @[self.navigationController.viewControllers.last" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.navigationController.viewControllers = @[self.navigationController.viewControllers.lastObject];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
