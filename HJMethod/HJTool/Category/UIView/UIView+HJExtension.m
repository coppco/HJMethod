//
//  UIView+HJExtension.m
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "UIView+HJExtension.h"
//快照地址
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
@end
