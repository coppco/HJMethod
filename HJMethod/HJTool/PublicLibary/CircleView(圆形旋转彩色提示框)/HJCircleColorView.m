//
//  HJCircleColorView.m
//  HJMethod
//
//  Created by coco on 16/6/12.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJCircleColorView.h"

@implementation HJCircleColorView

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
+ (Class)layerClass {
    return [CAGradientLayer class];
}
- (void)setup {
    //彩色的
    [self setupColors];
    //遮罩
    [self setupMask];
}
- (void)setupColors {
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    // 设置颜色线条分布的方向
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    
    // 创建颜色数组
    NSMutableArray *colors = [NSMutableArray array];
    for (NSInteger hue = 0; hue <= 300; hue += 10) {
        [colors addObject:(id)[UIColor colorWithHue:1.0*hue/360.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor];
    }
    
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
}
- (void)setupMask {
    // 生产出一个圆的路径
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat circleRadius = self.bounds.size.width/2.0 - 5;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:circleCenter
                                                              radius:circleRadius
                                                          startAngle:M_PI
                                                            endAngle:-M_PI
                                                           clockwise:NO];
    
    // 生产出一个圆形路径的Layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 5;
    
    // 可以设置出圆的完整性
    shapeLayer.strokeStart = 0.2;
    shapeLayer.strokeEnd = 1.0;
    
    self.layer.mask = shapeLayer;
}

- (void)startAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 3;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = [NSNumber numberWithDouble:0];
    animation.toValue = [NSNumber numberWithDouble:M_PI*2];
    [self.layer addAnimation:animation forKey:@"transform"];
}

- (void)stopAnimaton {
      [self.layer removeAllAnimations];
}
@end
