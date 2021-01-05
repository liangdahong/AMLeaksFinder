//    MIT License
//
//    Copyright (c) 2020 梁大红
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

#import "AMLeakOverviewView.h"

@interface AMLeakOverviewView ()

@property (nonatomic, strong) UIButton *hiddenButton;
@property (nonatomic, strong) UIButton *detailsButton;
@property (nonatomic, strong) UILabel *leakCountLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, assign) CGPoint oldPoint; ///< oldPoint

@end

@implementation AMLeakOverviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 88, 130)]) {
        
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.frame = CGRectMake(0, 100, 88, 30);
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self addSubview:button];
        [button setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [button setTitle:@"隐藏" forState:(UIControlStateNormal)];
        [button setTitle:@"显示" forState:(UIControlStateSelected)];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button addTarget:self action:@selector(hidenButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [[button.topAnchor constraintEqualToAnchor:self.topAnchor constant:0] setActive:YES];
        [[button.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        button.selected = true;
        self.hiddenButton = button;
        
        UILabel *leakCountLabel = [UILabel new];
        leakCountLabel.textColor = UIColor.redColor;
        leakCountLabel.font = [UIFont boldSystemFontOfSize:17];
        leakCountLabel.backgroundColor = UIColor.clearColor;
        leakCountLabel.numberOfLines = 0;
        leakCountLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:leakCountLabel];
        leakCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [[leakCountLabel.topAnchor  constraintEqualToAnchor:button.topAnchor constant:0] setActive:YES];
        [[leakCountLabel.bottomAnchor constraintEqualToAnchor:button.bottomAnchor constant:0] setActive:YES];
        [[leakCountLabel.rightAnchor constraintEqualToAnchor:button.leftAnchor constant:0] setActive:YES];
        self.leakCountLabel = leakCountLabel;
        
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [[label.topAnchor  constraintEqualToAnchor:button.bottomAnchor constant:0] setActive:YES];
        [[label.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:5] setActive:YES];;
        [[label.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-5] setActive:YES];;
        label.hidden = true;
        self.descLabel = label;
        
        UIButton *button1 = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self addSubview:button1];
        [button1 setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [button1 setTitle:@"显示详情" forState:(UIControlStateNormal)];
        button1.titleLabel.font = [UIFont systemFontOfSize:15];
        [button1 addTarget:self action:@selector(detailsButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        button1.translatesAutoresizingMaskIntoConstraints = NO;
        [[button1.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:0] setActive:YES];
        [[button1.centerXAnchor constraintEqualToAnchor:self.centerXAnchor] setActive:YES];
        self.detailsButton = button1;
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)]];
    }
    return self;
}

- (void)hidenButtonClick {
    self.hiddenButton.selected = !self.hiddenButton.isSelected;
    if (self.hiddenButton.isSelected) {
        self.layer.cornerRadius = 5;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 88, 30);
        self.leakCountLabel.hidden = false;
        self.descLabel.hidden = true;
    } else {
        self.layer.cornerRadius = 10;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 88, 120);
        self.leakCountLabel.hidden = true;
        self.descLabel.hidden = false;
    }
}

- (void)detailsButtonClick {
    !_showDetailsBlock ? : _showDetailsBlock();
}

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

- (void)setLeakDataModel:(AMLeakDataModel *)leakDataModel {
    
    _leakDataModel = leakDataModel;
    
    int total = leakDataModel.vcLeakCount + leakDataModel.viewLeakCount;

    self.leakCountLabel.text = (total == 0 ) ? @"" : [NSString stringWithFormat:@"%ld", (unsigned long)total];
    
    if (total == 0) {
        [self.hiddenButton setTitleColor:[UIColor greenColor] forState:(UIControlStateNormal)];
    } else {
        [self.hiddenButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    }
    if (total == 0) {
        NSString *str1 = [NSString stringWithFormat:@"无泄漏\n"];
        NSString *str2 = [NSString stringWithFormat:@"vc共: %d\n", leakDataModel.vcAllCount];
        NSString *str3 = [NSString stringWithFormat:@""];
        
        NSString *str = [[str1 stringByAppendingString:str2]
                         stringByAppendingString:str3];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        [att setAttributes:@{
            NSForegroundColorAttributeName : UIColor.greenColor,
            NSFontAttributeName : [UIFont boldSystemFontOfSize:13],
        } range:NSMakeRange(0, str.length)];
        self.descLabel.attributedText = att;
    } else {
        NSString *str1 = [NSString stringWithFormat:@"vc泄: %d\n",  leakDataModel.vcLeakCount];
        NSString *str2 = [NSString stringWithFormat:@"vc共: %d\n", leakDataModel.vcAllCount];
        NSString *str3 = [NSString stringWithFormat:@"view泄: %d",  leakDataModel.viewLeakCount];
        NSString *str = [[str1 stringByAppendingString:str2]
                         stringByAppendingString:str3];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        
        [att setAttributes:@{
            NSForegroundColorAttributeName : UIColor.redColor,
            NSFontAttributeName : [UIFont boldSystemFontOfSize:13],
        } range:NSMakeRange(0, str1.length)];
        
        [att setAttributes:@{
            NSForegroundColorAttributeName : UIColor.redColor,
            NSFontAttributeName : [UIFont boldSystemFontOfSize:13],
        } range:NSMakeRange(str1.length + str2.length, str3.length)];
        self.descLabel.attributedText = att;
    }
}

@end
