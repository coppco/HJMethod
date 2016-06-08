//
//  HJDownAlertView.m
//  HJMethod
//
//  Created by coco on 16/6/8.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJDownAlertView.h"
#import "Masonry.h"
#import "UIView+HJExtension.h"
#define kAlertViewTitleHeight 25
#define kAlertViewTitleOffsetY 15
#define kAlertViewTitleOffsetX 30
#define kAlertViewV 5
#define kAlertViewContentOffsetX 10
#define kAlertViewOperationButtonWidth 100
#define kAlertViewOperationButtonHeight 30


@interface HJDownAlertView ()
/**按钮*/
@property (nonatomic, strong)UIButton *operationB;
/**标题*/
@property (nonatomic, strong)UILabel *titleL;
/**描述*/
@property (nonatomic, strong)UILabel *contentTextL;
/**关闭按钮*/
@property (nonatomic, strong)UIButton *closeB;
/**标题*/
@property (nonatomic, copy)NSString *title;
/**按钮标题*/
@property (nonatomic, copy)NSString *buttonTitle;
/**提示语*/
@property (nonatomic, copy)NSString *contentText;
/**按钮点击block*/
@property (nonatomic, copy)void (^buttonClick)();

/**挡板*/
@property (nonatomic, strong)UIView *backView;
@end

@implementation HJDownAlertView

+ (HJDownAlertView *)alertViewWithTitle:(NSString *)title
                            contentText:(NSString *)contentText
                            buttonTitle:(NSString *)buttonTitle
                            buttonBlock:(void (^)())buttonClick {
    return [[self alloc] initWithTitle:title contentText:contentText buttonTitle:buttonTitle buttonBlock:buttonClick];
}

- (instancetype)initWithTitle:(NSString *)title contentText:(NSString *)contentText buttonTitle:(NSString *)buttonTitle buttonBlock:(void (^)())buttonClick {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        
        _title = [title copy];
        _contentText = [contentText copy];
        _buttonTitle = [buttonTitle copy];
        _buttonClick = [buttonClick copy];
        
        [self configSubview];
    }
    return self;
}

- (void)configSubview {
    self.titleL = [[UILabel alloc] init];
    self.titleL.numberOfLines = 1;
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.adjustsFontSizeToFitWidth = YES;
    self.titleL.font = [UIFont systemFontOfSize:20 weight:1];
    self.titleL.textColor = [UIColor blackColor];
    self.titleL.text = self.title;
    [self addSubview:self.titleL];
    
    self.contentTextL = [[UILabel alloc] init];
    self.contentTextL.text = self.contentText;
    self.contentTextL.numberOfLines = 0;
    self.contentTextL.font = [UIFont systemFontOfSize:15];
    self.contentTextL.textAlignment = NSTextAlignmentCenter;
    self.contentTextL.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
    [self addSubview:self.contentTextL];
    
    self.closeB = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.closeB setImage:[UIImage imageNamed:@"alertView_close"] forState:(UIControlStateNormal)];
    [self.closeB addTarget:self action:@selector(buttonHasClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.closeB];
    
    self.operationB = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.operationB.layer.cornerRadius = 5;
    [self.operationB setTitle:self.buttonTitle forState:(UIControlStateNormal)];
    [self.operationB setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.operationB setBackgroundColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]];
    self.operationB.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.operationB addTarget:self action:@selector(buttonHasClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.operationB];
    
    [self.closeB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kAlertViewTitleOffsetY);
        make.height.mas_equalTo(kAlertViewTitleHeight);
        make.left.mas_equalTo(kAlertViewTitleOffsetX);
        make.right.mas_equalTo(-kAlertViewTitleOffsetX);
    }];
    
    [self.contentTextL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(kAlertViewV);
        make.left.mas_equalTo(self).offset(kAlertViewContentOffsetX);
        make.right.mas_equalTo(self).offset(-kAlertViewContentOffsetX);
    }];
    
    [self.operationB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.frame.size.width / 2);
        make.size.mas_equalTo(CGSizeMake(kAlertViewOperationButtonWidth, kAlertViewOperationButtonHeight));
        make.top.mas_equalTo(self.contentTextL.mas_bottom).offset(kAlertViewV);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
    }];
}

//按钮点击事件
- (void)buttonHasClick:(UIButton *)button {
    NSLog(@"按钮");
    if (button == self.closeB) {
        [self dismiss];
    } else {
        if (self.buttonClick) {
            [self dismiss];
            self.buttonClick();
        }
    }
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:window.bounds];
    }
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [window addSubview:self.backView];
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(window).offset(10);
        make.right.mas_equalTo(window).offset(-10);
        //这里使用自动计算高度
    }];

    
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    self.transform = CGAffineTransformRotate(self.transform, -M_1_PI);
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
}
- (void)updateConstraints {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(window).offset(10);
        make.right.mas_equalTo(window).offset(-10);
        make.height.mas_greaterThanOrEqualTo([self autoLayoutSizeWithWidth:window.frame.size.width - 20].height);
    }];
    [super updateConstraints];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)removeFromSuperview {
    [self.backView removeFromSuperview];
    self.backView = nil;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        self.frame = CGRectMake(10, window.frame.size.height, window.frame.size.width - 20, 100);
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

/*
- (void)willMoveToSuperview:(UIView *)newSuperview {
        [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        return;
    }
    
    //旋转一点
    self.transform = CGAffineTransformRotate(self.transform, -M_1_PI);
    [UIView animateWithDuration:0.35 animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(window);
            make.width.mas_equalTo(window.frame.size.width - 20);
            make.height.mas_equalTo([self autoLayoutSizeWithWidth:(window.frame.size.width - 20)]);
        }];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];

}
*/
@end
