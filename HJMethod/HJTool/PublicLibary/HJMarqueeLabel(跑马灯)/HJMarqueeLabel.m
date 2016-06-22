//
//  HJMarqueeLabel.m
//  tableViewAnimation
//
//  Created by coco on 16/6/22.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJMarqueeLabel.h"

@interface HJMarqueeLabel ()
/**容器*/
@property (nonatomic, strong)UIView *containerView;
/**显示文本*/
@property (nonatomic, strong)UILabel *titleLabel;
/**文本宽度*/
@property (nonatomic, assign)CGFloat labelWidth;
/**keyframe动画*/
@property (nonatomic, strong)CAKeyframeAnimation *keyframeAnimation;
/**速率*/
@property (nonatomic, assign)CGFloat rate;
/**显示文本*/
@property (nonatomic, copy)NSString *text;
/**属性文字*/
@property (nonatomic, strong) NSAttributedString *attributedText;
@end

@implementation HJMarqueeLabel
#pragma mark - 懒加载
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = _font;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (CAKeyframeAnimation *)keyframeAnimation {
    if (!_keyframeAnimation) {
        _keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        
        _keyframeAnimation.keyTimes = @[@0, @1.0];
        _keyframeAnimation.duration = 5;
        _keyframeAnimation.values = @[[NSNumber numberWithFloat:self.frame.size.width],[NSNumber numberWithFloat:-self.labelWidth]];
        _keyframeAnimation.repeatCount = _repeatCount == 0 ? MAXFLOAT : _repeatCount;
        _keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    }
    return _keyframeAnimation;
}

#pragma mark -setter getter
- (void)setText:(NSString *)text {
    _text = text;
    _attributedText = nil;
    [self refreshLabelData];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self refreshLabelData];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    _text = nil;
    [self refreshLabelData];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.titleLabel.textColor = textColor;
}
- (void)setRepeatCount:(CGFloat)repeatCount {
    _repeatCount = repeatCount;
//    self.keyframeAnimation.repeatCount = ((repeatCount == 0) ? MAXFLOAT : repeatCount);
    NSLog(@"%f", ((repeatCount == 0) ? MAXFLOAT : repeatCount));
}

- (void)setSpeedType:(HJMarqueeSpeed)speedType {
    _speedType = speedType;
    switch (speedType) {
        case HJMarqueeSpeedMid:
            _rate = 75;
            break;
        case HJMarqueeSpeedFast:
            _rate = 90;
            break;
        case HJMarqueeSpeedLow:
            _rate = 40;
            break;
        default:
            break;
    }
//    self.keyframeAnimation.duration = self.labelWidth / _rate;
}

//刷新属性等
- (void)refreshLabelData {
    _text.length != 0 ? (self.titleLabel.text = _text) : (self.titleLabel.attributedText = _attributedText);

    CGRect frame = self.titleLabel.frame;
    frame.size.width = self.labelWidth;
    self.titleLabel.frame = frame;
}
//获取文本的宽度
- (CGFloat)labelWidth{
    return _text.length != 0 ? ([_text boundingRectWithSize:CGSizeMake(10000, self.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName : self.font} context:nil].size.width) : ([_attributedText boundingRectWithSize:CGSizeMake(10000, self.frame.size.height) options:(NSStringDrawingUsesLineFragmentOrigin) context:nil].size.width);
}
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.clipsToBounds = YES; //边框不显示
    self.font = [UIFont systemFontOfSize:15];
    self.textColor = [UIColor whiteColor];
    self.repeatCount = 0;
    self.speedType = HJMarqueeSpeedMid;
    self.rate = 75;
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.containerView);
        make.left.height.equalTo(self.containerView);
    }];
}

#pragma mark - 开始动画结束动画
- (void)startAnimation {
    [self animation];
}
- (void)stopAnimation {
    [self.containerView.layer removeAnimationForKey:@"move"];
}
- (void)animation {
    [self.containerView.layer removeAnimationForKey:@"move"];
    [self.containerView.layer addAnimation:self.keyframeAnimation forKey:@"move"];
}

@end
