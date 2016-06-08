//
//  UIView+HJExtension.m
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "UIView+HJExtension.h"
//快照保存地址
#define kSnapshot [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"HJSnapshots"]

@implementation UIView (HJExtension)

//   x坐标
- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
//  y坐标
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
//width 宽
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
//height  高
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
//centerX  中心点X
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
//centerY  中心点Y
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
//minX  最左边
- (CGFloat)minX {
    return CGRectGetMinX(self.frame);
}
//maxX 最右边
- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

//minY 最上边
- (CGFloat)minY {
    return CGRectGetMinY(self.frame);
}
//maxY 最下边
- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}
//midX  中间x
- (CGFloat)midX {
    return CGRectGetMidX(self.frame);
}
//midY  中间y
- (CGFloat)midY {
    return CGRectGetMidY(self.frame);
}
//origin
- (CGPoint)origin {
    return self.frame.origin;
}
-(void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
//size
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
//viewcontroller
- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIImage *)hj_snapshotsWithType:(HJViewSnapshotsType)type {
    if (self == nil) {
        return nil;
    }
    CGSize imageSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(image);
    
    switch (type) {
        case HJViewSnapshotsTypePhotes: {
            //将该图像保存到媒体库中
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
            break;
        case HJViewSnapshotsTypeSandbox: {
            if (![[NSFileManager defaultManager] fileExistsAtPath:kSnapshot]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:kSnapshot withIntermediateDirectories:YES attributes:nil error:nil];
            }

            NSString *fileName = [NSString stringWithFormat:@"%.0f.png", [[NSDate date] timeIntervalSince1970]];
            [data writeToFile:[kSnapshot stringByAppendingPathComponent:fileName] atomically:YES];
        }
            break;
        case HJViewSnapshotsTypeBoth: {
            //沙盒cache中
            if (![[NSFileManager defaultManager] fileExistsAtPath:kSnapshot]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:kSnapshot withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
            NSString *fileName = [NSString stringWithFormat:@"%.0f.png", [[NSDate date] timeIntervalSince1970]];
            [data writeToFile:[kSnapshot stringByAppendingPathComponent:fileName] atomically:YES];
            
            //将该图像保存到媒体库中
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
            break;
        default:
            break;
    }
    return image;
}
//保存图片的指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    } else {
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
//抖动
- (void)animationShake {
    CALayer *viewLayer = self.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    animation.removedOnCompletion = YES;
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    
    [viewLayer addAnimation:animation forKey:nil];
}
//渐进动画  慢慢放大或者缩小
- (void)animationGradualType:(AnimateType)type isRotateFew:(BOOL)rotate delegate:(id)delegate{
    if (rotate) {
        //旋转
        self.transform = CGAffineTransformRotate(self.transform, M_1_PI);
    }
    
    NSTimeInterval duration = 0.5;
    //比例
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    if (type == AnimateTypeBig) {
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
        scaleAnimation.toValue = [NSNumber numberWithFloat:2];
    } else {
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0];
    }
    //透明度
    CABasicAnimation *opacityAnimaton = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimaton.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimaton.toValue = [NSNumber numberWithFloat:0];
    
    //组动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scaleAnimation, opacityAnimaton];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.duration = duration;
    //    group.delegate = [HJCommonTools getControllerForView:view];
    if (delegate != nil) {
        group.delegate = delegate;
    }
    group.speed = 0.5;  //慢速
    group.autoreverses = NO; // 防止最后显现,不自动返回
    group.fillMode = kCAFillModeForwards;  //最终会停在终点处
    group.removedOnCompletion = NO;
    [self.layer addAnimation:group forKey:nil];
}

//CATransition动画
- (void)animationCATransitionWithDuration:(NSTimeInterval)duration type:(HJAnimationType)type direction:(DirectionType)direction {
    if (type == 0) {
        type = 1;
    }
    if (direction == 0) {
        direction = 1;
    }
    if (self == nil) {
        return;
    }
    if (duration <= 0) {
        duration = 1;
    }
    NSString *subtypeString = nil;
    switch (direction) {
        case DirectionTypeBottom:
            subtypeString = kCATransitionFromBottom;
            break;
        case DirectionTypeLeft:
            subtypeString = kCATransitionFromLeft;
            break;
        case DirectionTypeRight:
            subtypeString = kCATransitionFromRight;
            break;
        case DirectionTypeTop:
            subtypeString = kCATransitionFromTop;
            break;
        default:
            break;
    }
    
    switch (type) {
        case HJAnimationTypeFade:
            [self transitionWithType:kCATransitionFade WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypePush:
            [self transitionWithType:kCATransitionPush WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeReveal:
            [self transitionWithType:kCATransitionReveal WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeMoveIn:
            [self transitionWithType:kCATransitionMoveIn WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeCube:
            [self transitionWithType:@"cube" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeSuckEffect:
            [self transitionWithType:@"suckEffect" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeOglFlip:
            [self transitionWithType:@"oglFlip" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeRippleEffect:
            [self transitionWithType:@"rippleEffect" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypePageCurl:
            [self transitionWithType:@"pageCurl" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypePageUnCurl:
            [self transitionWithType:@"pageUnCurl" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeCameraIrisHollowOpen:
            [self transitionWithType:@"cameraIrisHollowOpen" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeCameraIrisHollowClose:
            [self transitionWithType:@"cameraIrisHollowClose" WithSubtype:subtypeString duration:duration];
            break;
            
        case HJAnimationTypeCurlDown:
            [self viewAnimationWithTransition:UIViewAnimationTransitionCurlDown duration:duration];
            break;
            
        case HJAnimationTypeCurlUp:
            [self viewAnimationWithTransition:UIViewAnimationTransitionCurlUp duration:duration];
            break;
            
        case HJAnimationTypeFlipFromLeft:
            [self viewAnimationWithTransition:UIViewAnimationTransitionFlipFromLeft duration:duration];
            break;
            
        case HJAnimationTypeFlipFromRight:
            [self viewAnimationWithTransition:UIViewAnimationTransitionFlipFromRight duration:duration];
            break;
            
        default:
            break;
    }
    
}
- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype duration:(NSTimeInterval)duration {
    //1. 创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //2. 设置时间
    animation.duration = duration;
    //设置type
    animation.type = type;
    if (subtype != nil) {
        //设置子类
        animation.subtype = subtype;
    }
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [self.layer addAnimation:animation forKey:@"animation"];
}
- (void)viewAnimationWithTransition:(UIViewAnimationTransition)transition duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:self cache:YES];
    }];
}

//是否自动布局  YES 代码布局  sizeThatFits:
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
    NSLog(@"%@", NSStringFromCGSize(size));
    return size;
}

//没有数据或者网络错误的时候
- (void)configTipViewHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock {
    if (hasData) {
        if (self.tipView) {
            self.tipView.hidden = YES;
            [self.tipView removeFromSuperview];
        }
    } else {
        if (!self.tipView) {
            self.tipView = ({
                HJTipView *tipView = [[HJTipView alloc] initWithFrame:self.bounds];
                tipView.hidden = NO;
                tipView;
            });
        }
        [self addSubview:self.tipView];
        [self.tipView configTipViewHasData:hasData hasError:hasError reloadButtonBlock:reloadButtonBlock];
    }
}



@end

@implementation HJTipView

- (void)configTipViewHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock {
    
}

@end
