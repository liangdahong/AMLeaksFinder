//
//  BMDragViewLabel.m
//  BMeaksFinder
//
//  Created by mac on 2020/5/18.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMDragViewLabel.h"

@interface BMDragViewLabel ()

@property (nonatomic, assign) CGPoint oldPoint; ///< oldPoint

@end

@implementation BMDragViewLabel

#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - 私有方法

- (void)initUI {
    self.numberOfLines = 0;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)]];
}

#pragma mark - 事件响应

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint point = [panGestureRecognizer locationInView:self.superview];
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.oldPoint = point;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGRect frame = self.frame;
            frame.origin.y = (self.frame.origin.y + (point.y - self.oldPoint.y));
            frame.origin.x = (self.frame.origin.x + (point.x - self.oldPoint.x));
            self.oldPoint = point;
            self.frame = frame;
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
}

@end
