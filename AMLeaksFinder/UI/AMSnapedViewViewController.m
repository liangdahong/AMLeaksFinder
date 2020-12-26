//
//  AMSnapedViewViewController.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/12/26.
//

#import "AMSnapedViewViewController.h"

@implementation AMSnapedViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.snapedView.bounds.size.width * 0.5 > UIScreen.mainScreen.bounds.size.width / 2.0 ? UIScreen.mainScreen.bounds.size.width / 2.0 : self.snapedView.bounds.size.width * 0.5;
    CGFloat height = self.snapedView.bounds.size.height * 0.5 > UIScreen.mainScreen.bounds.size.height / 2.0 ? UIScreen.mainScreen.bounds.size.height / 2.0 : self.snapedView.bounds.size.height * 0.5;
    
    [self.view addSubview:self.snapedView];
    self.snapedView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.snapedView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.snapedView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
    [[self.snapedView.widthAnchor constraintEqualToConstant:width] setActive:YES];
    [[self.snapedView.heightAnchor constraintEqualToConstant:height] setActive:YES];

    UILabel *topLabel = [UILabel new];
    topLabel.text = @"↓ 可能泄漏的 view ↓";
    [self.view addSubview:topLabel];
    topLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[topLabel.centerXAnchor constraintEqualToAnchor:self.snapedView.centerXAnchor] setActive:YES];
    [[topLabel.bottomAnchor constraintEqualToAnchor:self.snapedView.topAnchor] setActive:YES];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.text = @"↑ 可能泄漏的 view ↑";
    [self.view addSubview:bottomLabel];
    bottomLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[bottomLabel.centerXAnchor constraintEqualToAnchor:self.snapedView.centerXAnchor] setActive:YES];
    [[bottomLabel.topAnchor constraintEqualToAnchor:self.snapedView.bottomAnchor] setActive:YES];
        
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.view addSubview:button];
    button.frame = CGRectMake(20, 60, 40, 30);
    [button setTitle:@"返回" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
