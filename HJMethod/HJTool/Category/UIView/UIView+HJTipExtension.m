//
//  UIView+HJTipExtension.m
//  HJMethod
//
//  Created by coco on 16/6/21.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "UIView+HJTipExtension.h"
static const NSString *kHJTipViewKey = @"HJTipViewKey";

//提示视图
@interface HJTipView ()
/**图片*/
@property (nonatomic, strong)UIImageView *imageView;
/**文字*/
@property (nonatomic, strong)UILabel *tipLabel;
/**重新加载按钮*/
@property (nonatomic, strong)UIButton *reloadButton;
/**重新加载按钮执行block*/
@property (nonatomic, copy)void (^reloadData)();
- (void)configViewWithHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock;
@end

@implementation HJTipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)configViewWithHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock {
    _reloadData = reloadButtonBlock;
    if (hasData) {
        //有数据
        [self removeFromSuperview];
        return;
    }
    self.alpha = 1;
    //图片
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    [self addSubview:_imageView];
    //    文字
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    [self addSubview:_tipLabel];
    //    布局
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(130, 130));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        //        make.top.equalTo(_imageView.mas_bottom);  为什么是nil
        make.top.equalTo(self.mas_centerY);
        make.height.mas_equalTo(@50);
    }];
    if (hasError) {
        //加载失败
        if (!_reloadButton) {
            _reloadButton = ({
                UIButton *object = [UIButton buttonWithType:(UIButtonTypeCustom)];
                [object setTitle:@"重新加载" forState:(UIControlStateNormal)];
                [object setBackgroundColor:[UIColor orangeColor]];
                object.layer.cornerRadius = 5;
                [object addTarget:self action:@selector(reloadDataButton:) forControlEvents:(UIControlEventTouchUpInside)];
                object;
            });
            [self addSubview:_reloadButton];
            [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_tipLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(100, 30));
            }];
        }
        _reloadButton.hidden = NO;
        _imageView.image = [UIImage imageNamed:@"alertView_close"];
        _tipLabel.text = @"貌似加载出错了,真忧伤!";
    } else {
        //空白数据
        if (_reloadButton) {
            _reloadButton.hidden = YES;
        }
        _tipLabel.text = @"貌似没有数据";
        _imageView.image = [UIImage imageNamed:@"alertView_close"];
    }
    
}

- (void)reloadDataButton:(UIButton *)butotn {
    if (_reloadData) {
        _reloadData();
    }
}

- (void)layoutSubviews {
    NSLog(@"%@", NSStringFromCGRect(self.frame));
}

@end




@interface UIView (HJTipExtension1)
/**NoData无数据视图*/
@property (nonatomic, strong)HJTipView *tipView;
@end
//分类

@implementation UIView (HJTipExtension)

- (void)setTipView:(HJTipView *)tipView {
    [self willChangeValueForKey:@"tipView"];
    objc_setAssociatedObject(self, &kHJTipViewKey,
                             tipView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"tipView"];
}
- (HJTipView *)tipView {
    return objc_getAssociatedObject(self, &kHJTipViewKey);
}
 

/*没有数据或者网络错误的时候*/
- (void)configTipViewHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock {
    if (hasData) {
        if (self.tipView) {
            self.tipView.hidden = YES;
            [self.tipView removeFromSuperview];
        }
    } else {
        if (!self.tipView) {
            self.tipView = ({
                HJTipView *tipView = [[HJTipView alloc] initWithFrame:self.noDataContainer.bounds];
                tipView;
            });
        }
        self.tipView.hidden = NO;
        [self.noDataContainer addSubview:self.tipView];
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.equalTo(self.noDataContainer);
        }];
        [self.tipView configViewWithHasData:hasData hasError:hasError reloadButtonBlock:reloadButtonBlock];
    }
}

- (UIView *)noDataContainer{
    UIView *noDataContainer = self;
    for (UIView *aView in [self subviews]) {
        if ([aView isKindOfClass:[UITableView class]]) {
            noDataContainer = aView;
        }
    }
    return noDataContainer;
}

@end
