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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"测试" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"去正常释放的界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self.navigationController pushViewController:BMCorrectVC.new animated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"去用内存泄露的局面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:BMErrorVC.new animated:YES];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
