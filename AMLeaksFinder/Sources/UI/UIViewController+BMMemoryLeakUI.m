//
//  UIViewController+BMMemoryLeakUI.m
//  BMeaksFinder
//
//  Created by liangdahong on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "UIViewController+BMMemoryLeakUI.h"
#import "UIViewController+BMMemoryLeak.h"
#import "BMMemoryLeakView.h"
#import "BMDragViewLabel.h"

static BMMemoryLeakView *memoryLeakView;
static BMDragViewLabel *dragViewLabel;

@implementation UIViewController (BMMemoryLeakUI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            memoryLeakView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(BMMemoryLeakView.class) owner:nil options:nil].firstObject;
            memoryLeakView.frame = CGRectMake(30, 60, 200, 300);
            memoryLeakView.hidden = YES;

            dragViewLabel = BMDragViewLabel.new;
            dragViewLabel.frame = CGRectMake(0, 100, 88, 88);
            dragViewLabel.layer.cornerRadius = 30;
            dragViewLabel.layer.masksToBounds = YES;
            dragViewLabel.textAlignment = NSTextAlignmentCenter;
            dragViewLabel.textColor = UIColor.redColor;
            dragViewLabel.font = [UIFont systemFontOfSize:12];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                UIViewController *rootVC = UIApplication.sharedApplication.keyWindow.rootViewController;
                [rootVC.view addSubview:memoryLeakView];
                [rootVC.view addSubview:dragViewLabel];
                [dragViewLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDragClick)]];
            });
        });
    });
}

+ (void)tapDragClick {
    memoryLeakView.hidden = !memoryLeakView.isHidden;
}

+ (void)udpateUI {
    UIViewController *rootVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if (memoryLeakView.superview != rootVC.view) {
        [rootVC.view addSubview:memoryLeakView];
        [rootVC.view addSubview:dragViewLabel];
    }
    
    __block int leakCount = 0;
    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.memoryLeakDeallocModel.shouldDealloc) {
            leakCount++;
        }
    }];
    NSString *str = [NSString stringWithFormat:@"泄漏:%d\n全部:%lu\n点击看详情\n(供参考)" ,
                     leakCount,
                     (unsigned long)UIViewController.memoryLeakModelArray.count];

    NSArray <NSString *> *strs = [str componentsSeparatedByString:@"\n"];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];

    [att setAttributes:@{
        NSForegroundColorAttributeName : UIColor.redColor,
    } range:NSMakeRange(0, strs.firstObject.length)];

    [att setAttributes:@{
        NSForegroundColorAttributeName : UIColor.orangeColor,
    } range:NSMakeRange(strs.firstObject.length+1, strs[1].length)];

    [att setAttributes:@{
        NSForegroundColorAttributeName : UIColor.blackColor,
    } range:NSMakeRange(strs.firstObject.length+1+strs[1].length+1, strs.lastObject.length)];

    dragViewLabel.attributedText = att;
    [memoryLeakView setMemoryLeakModelArray:UIViewController.memoryLeakModelArray];
}

@end
