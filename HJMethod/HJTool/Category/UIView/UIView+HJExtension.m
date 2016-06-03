//
//  UIView+HJExtension.m
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "UIView+HJExtension.h"

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


@end
