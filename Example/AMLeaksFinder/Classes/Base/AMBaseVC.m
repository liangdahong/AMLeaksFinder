//
//  AMBaseVC.m
//  AMLeaksFinder
//
//  Created by liangdahong on 2020/5/20.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "AMBaseVC.h"

@implementation AMBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(31)/255.0
                                                green:(90)/255.0
                                                 blue:(222)/255.0
                                                alpha:1];
    [self.view addSubview:self.topView];
}

- (AMTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(AMTopView.class) owner:nil options:nil].firstObject;
        _topView.frame = CGRectMake(10, 100, 300, 130);
        _topView.layer.cornerRadius = 10;
        _topView.layer.masksToBounds = YES;
    }
    return _topView;
}

@end
