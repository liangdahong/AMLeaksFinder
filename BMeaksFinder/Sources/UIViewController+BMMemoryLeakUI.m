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
                [UIApplication.sharedApplication.keyWindow addSubview:memoryLeakView];
                [UIApplication.sharedApplication.keyWindow addSubview:dragViewLabel];
                [dragViewLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDragClick)]];
            });
        });
    });
}

+ (void)tapDragClick {
    memoryLeakView.hidden = !memoryLeakView.isHidden;
}

+ (void)udpateUI {
    __block int leakCount = 0;
    __block int customizeCount = 0;

    [UIViewController.memoryLeakModelArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.memoryLeakDeallocModel.controller) {
            [UIViewController.memoryLeakModelArray removeObjectAtIndex:idx];
        }
    }];

    [UIViewController.memoryLeakModelArray enumerateObjectsUsingBlock:^(BMMemoryLeakModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.memoryLeakDeallocModel.shouldDealloc) {
            leakCount++;
        }
        if (![NSStringFromClass(obj.memoryLeakDeallocModel.controller.class) hasPrefix:@"_"]
            && ![NSStringFromClass(obj.memoryLeakDeallocModel.controller.class) hasPrefix:@"UI"]) {
            customizeCount++;
        }
    }];

    NSString *str = [NSString stringWithFormat:@"已泄漏VC:%d\n自定义VC:%d\n全部VC:%lu\n点击看详情\n(供参考)" ,
                     leakCount,
                     customizeCount,
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
