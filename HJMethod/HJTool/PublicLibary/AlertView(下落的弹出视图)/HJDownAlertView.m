//
//  HJDownAlertView.m
//  HJMethod
//
//  Created by coco on 16/6/8.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJDownAlertView.h"
#import "Masonry.h"
#import <objc/runtime.h>

//文字
#define kAlertViewTitleHeight 25
#define kAlertViewTitleOffsetY 15
#define kAlertViewTitleOffsetX 30
//垂直间隔
#define kAlertViewV 5
//正文x
#define kAlertViewContentOffsetX 10
//按钮宽高
#define kAlertViewOperationButtonWidth 100
#define kAlertViewOperationButtonHeight 30

//整体宽度和x位置
#define kAlertViewOffsetX 10
#define kAlertViewWidth ([UIScreen mainScreen].bounds.size.width - 20)


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

/**缓存高度*/
@property (nonatomic, assign)CGFloat autoHeight;
@end

@implementation HJDownAlertView

- (CGFloat)autoHeight {
    return [self autoLayoutSizeWithWidth:kAlertViewWidth].height;
}

+ (HJDownAlertView *)downAlertViewWithTitle:(NSString *)title
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
    [self.operationB setBackgroundColor:[UIColor colorWithRed:227.0/255.0
                                                        green:100.0/255.0
                                                         blue:83.0/255.0
                                                        alpha:1]];
    self.operationB.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.operationB addTarget:self action:@selector(buttonHasClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.operationB];
    
    [self.closeB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25, 25));
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
    if (button == self.closeB) {
        [self dismiss];
    } else {
        if (self.buttonClick) {
            [self dismiss];
            self.buttonClick();
        }
    }
}
//显示
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:window.bounds];
    }
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [window addSubview:self.backView];
    [window addSubview:self];


    [self mas_remakeConstraints :^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(window.mas_top);
        make.left.mas_equalTo(window).offset(10);
        make.right.mas_equalTo(window).offset(-10);
        make.height.mas_greaterThanOrEqualTo(self.autoHeight);
    }];
    
    [self layoutIfNeeded];
    
    [self mas_remakeConstraints :^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(window);
        make.left.mas_equalTo(window).offset(10);
        make.right.mas_equalTo(window).offset(-10);
        make.height.mas_greaterThanOrEqualTo(self.autoHeight);
    }];
    
    self.transform = CGAffineTransformRotate(self.transform, -M_1_PI / 2);
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}
- (void)didMoveToWindow {
    [super didMoveToWindow];
    
}
//隐藏
- (void)dismiss {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(window.mas_bottom).offset(100);
        make.left.mas_equalTo(window).offset(10);
        make.right.mas_equalTo(window).offset(-10);
        make.height.mas_greaterThanOrEqualTo(self.autoHeight);
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformRotate(self.transform, M_1_PI / 1.5);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        self.backView = nil;
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
    
}

//是否自动布局  YES 代码布局  需要实现sizeThatFits:
- (BOOL)hj_enforceFrameLayout {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (CGSize)autoLayoutSizeWithWidth:(CGFloat)width {
    CGSize size;
    if ([self hj_enforceFrameLayout]) {
        SEL selector = @selector(sizeThatFits:);
        BOOL inherited = ![self isMemberOfClass:UIView.class];
        BOOL overrided = [self.class instanceMethodForSelector:selector] != [UIView instanceMethodForSelector:selector];
        if (inherited && !overrided) {
            NSAssert(NO, @"view must override '-sizeThatFits:' method if not using auto layout.");
        }
        size = [self sizeThatFits:CGSizeMake(width, 0)];
    } else {
        NSLayoutConstraint *tempWidthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
        [self addConstraint:tempWidthConstraint];
        // Auto layout engine does its math
        size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [self removeConstraint:tempWidthConstraint];
    }
    return size;
}
@end
