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
