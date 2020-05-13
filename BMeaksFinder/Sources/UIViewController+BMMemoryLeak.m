//
//  UIViewController+BMMemoryLeak.m
//  BMMoonStore
//
//  Created by liangdahong on 2020/4/6.
//  Copyright © 2020 liangdahong. All rights reserved.
//

/*
 目前功能是尝试阶段，后面准备参考同类框架继续扩展和加强。
 https://github.com/Tencent/MLeaksFinder
  只在 DEBUG 模式下生效
 上架前建议全部注释即可。
*/
#pragma mark - Memory Leak

#ifdef DEBUG
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSMutableArray <NSDictionary <NSString *, NSString *> *> *array = nil;
static UILabel *label;
static UITextView *text;

@class BMTestVCObj, BMWeakOBJModel;

static NSMutableArray <BMWeakOBJModel *> *weakOBJModelArray = nil;

@interface BMWeakOBJModel : NSObject

@property (nonatomic, weak) BMTestVCObj *objj; ///< objj

@end

@implementation BMWeakOBJModel

@end


@interface BMTestVCObj : NSObject

@property (nonatomic, copy) NSString *vckey; ///< vc memory address
@property (nonatomic, weak) UIViewController *weakVC; ///< weakVC
@property (nonatomic, assign) void * vcpp;

@end

@implementation BMTestVCObj

- (void)dealloc {
    // 释放的时候删除
    NSString *key = self.vckey;
    [array enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.allKeys.firstObject isEqualToString:key]) {
            [array removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    if (text) {
        NSMutableString *str = @"".mutableCopy;
        [array enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [str appendFormat:@"%ld、%@", idx+1, obj.allValues.firstObject];
            [str appendString:@"\n"];
        }];
        text.text = str;
    }
    label.text = [NSString stringWithFormat:@"内存中 %lu 个控制器", (unsigned long)array.count];
    [weakOBJModelArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(BMWeakOBJModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.objj) {
            UIViewController *vc = obj.objj.weakVC;
            if (vc && [vc isKindOfClass:NSClassFromString(@"BMBaseVC")]) {
                if (!vc.navigationController && !vc.nextResponder) {
                    NSLog(@"❌❌❌❌%@ 很可能泄露了", vc);
                }
            }
        } else {
            [weakOBJModelArray removeObjectAtIndex:idx];
        }
    }];
}

@end

void swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    // 1.获取旧 Method
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    // 2.获取新 Method
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // 3.交换方法
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIViewController (BMMemoryLeak)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[UIDevice currentDevice].name hasPrefix:@"bmtestldh"]) {
            [self bm_startMemoryLeak];
        }
    });
}

- (void)bm_test_viewDidLoad {

    [self bm_test_viewDidLoad];
    [array insertObject:@{
        [NSString stringWithFormat:@"%p", self] : NSStringFromClass(self.class)
    } atIndex:0];
    if (text) {
        NSMutableString *str = @"".mutableCopy;
        [array enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [str appendFormat:@"%ld、%@", idx+1, obj.allValues.firstObject];
            [str appendString:@"\n"];
        }];
        text.text = str;
    }
    BMTestVCObj *obj = BMTestVCObj.new;
    objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    obj.vckey = [NSString stringWithFormat:@"%p", self];
    obj.weakVC = self;
    obj.vcpp = (__bridge void *)(self);
    label.text = [NSString stringWithFormat:@"内存中 %lu 个控制器", (unsigned long)array.count];

    BMWeakOBJModel *weakOBJModel = BMWeakOBJModel.new;
    weakOBJModel.objj = obj;
    [weakOBJModelArray addObject:weakOBJModel];

    [weakOBJModelArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(BMWeakOBJModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.objj) {
            UIViewController *vc = obj.objj.weakVC;
            if (vc && ![NSStringFromClass(vc.class) hasPrefix:@"UI"]) {
                if (!vc.navigationController && !vc.nextResponder) {
                    NSLog(@"❌❌❌❌%@ 很可能泄露了", vc);
                }
            }
        } else {
            [weakOBJModelArray removeObjectAtIndex:idx];
        }
    }];
}

+ (void)bm_startMemoryLeak {
#ifdef DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = @[].mutableCopy;
        weakOBJModelArray = @[].mutableCopy;
        swizzleInstanceMethod(UIViewController.class, @selector(viewDidLoad), @selector(bm_test_viewDidLoad));
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // label
            label = [UILabel new];
            label.userInteractionEnabled = NO;
            [UIApplication.sharedApplication.keyWindow addSubview:label];
            label.frame = CGRectMake(100, 20, 300, 20);
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = UIColor.redColor;
            label.font = [UIFont boldSystemFontOfSize:20];

            // Add button
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeContactAdd)];
            [UIApplication.sharedApplication.keyWindow addSubview:button];
            button.frame = CGRectMake(100, 40, 20, 20);
            
            // UITextView
            text = UITextView.new;
            [UIApplication.sharedApplication.keyWindow addSubview:text];
            text.frame = CGRectMake(100, 60, 200, 200);
            text.backgroundColor = [UIColor grayColor];
            text.hidden = YES;
            [button addTarget:self action:@selector(buttonClick) forControlEvents:(UIControlEventTouchUpInside)];
            label.text = [NSString stringWithFormat:@"内存中 %lu 个控制器", (unsigned long)array.count];
            NSMutableString *str = @"".mutableCopy;
            [array enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [str appendFormat:@"%ld、%@", idx+1, obj.allValues.firstObject];
                [str appendString:@"\n"];
            }];
            text.text = str;
        });
    });
#endif
}

+ (void)buttonClick {
    text.hidden = !text.isHidden;
}

@end

#endif
