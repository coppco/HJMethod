//
//  HJDownAlertView.m
//  HJMethod
//
//  Created by coco on 16/6/8.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJDownAlertView.h"
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
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
    }
    return self;
}
#pragma mark - 懒加载
- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = ({
            UILabel *object = [[UILabel alloc] init];
            object = [[UILabel alloc] init];
            object.numberOfLines = 1;
            object.textAlignment = NSTextAlignmentCenter;
            object.adjustsFontSizeToFitWidth = YES;
            object.font = [UIFont systemFontOfSize:20 weight:1];
            object.textColor = [UIColor blackColor];
            object.text = self.title;
            object;
        });
    }
    return _titleL;
}
- (UILabel *)contentTextL {
    if (!_contentTextL) {
        _contentTextL = ({
            UILabel *object = [[UILabel alloc] init];
            object = [[UILabel alloc] init];
            object.text = self.contentText;
            object.numberOfLines = 0;
            object.font = [UIFont systemFontOfSize:15];
            object.textAlignment = NSTextAlignmentCenter;
            object.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
            object;
        });
    }
    return _contentTextL;
}
- (UIButton *)closeB {
    if (!_closeB) {
        _closeB = ({
            UIButton *object = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [object setImage:[UIImage imageNamed:@"alertView_close"] forState:(UIControlStateNormal)];
            [object addTarget:self action:@selector(buttonHasClick:) forControlEvents:(UIControlEventTouchUpInside)];
            object;
        });
    }
    return _closeB;
}
- (UIButton *)operationB {
    if (!_operationB) {
        _operationB = ({
            UIButton *object = [UIButton buttonWithType:(UIButtonTypeCustom)];
            object.layer.cornerRadius = 5;
            [object setTitle:self.buttonTitle forState:(UIControlStateNormal)];
            [object setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [object setBackgroundColor:[UIColor colorWithRed:227.0/255.0
                                                                green:100.0/255.0
                                                                 blue:83.0/255.0
                                                                alpha:1]];
            object.titleLabel.font = [UIFont systemFontOfSize:14];
            [object addTarget:self action:@selector(buttonHasClick:) forControlEvents:(UIControlEventTouchUpInside)];
            object;
        });
    }
    return _operationB;
}
- (void)configSubview {
    
    [self addSubview:self.titleL];
    [self addSubview:self.contentTextL];
    [self addSubview:self.closeB];
    [self addSubview:self.operationB];
    
    [self.closeB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
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
    if (self.operationB == button) {
        if (self.buttonClick) {
            self.buttonClick();
        }
    }
    [self dismiss];
}
//显示
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:window.bounds];
        self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
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
    [UIView animateWithDuration:0.35 animations:^{
        [self layoutIfNeeded];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
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
    [UIView animateWithDuration:0.35 animations:^{
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

#pragma - mark setter方法和getter 方法
- (void)setTitle:(NSString *)title {
    _title = title;
    [self configSubview];
    self.titleL.text = title;
}
- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [self configSubview];
    [self.operationB setTitle:buttonTitle forState:(UIControlStateNormal)];
}
- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    [self configSubview];
    _contentTextL.text = contentText;
}

@end
