//
//  UIView+HJExtension.h
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//   UIView的常用属性

#import <UIKit/UIKit.h>

typedef  enum {
    HJViewSnapshotsTypeNone,  //不保存
    HJViewSnapshotsTypePhotes,  //相册  保存到相册会自动在沙盒缓存
    HJViewSnapshotsTypeSandbox,  //沙盒
    HJViewSnapshotsTypeBoth  //沙盒和相册
}HJViewSnapshotsType;

@interface UIView (HJExtension)

/*==============属性可以设置也可以获取================*/
/**x*/
@property (nonatomic, assign)CGFloat x;

/**y*/
@property (nonatomic, assign)CGFloat y;

/**宽*/
@property (nonatomic, assign)CGFloat width;

/**高*/
@property (nonatomic, assign)CGFloat height;

/**中心点X*/
@property (nonatomic, assign)CGFloat centerX;

/**中心点Y*/
@property (nonatomic, assign)CGFloat centerY;

/**原点*/
@property (nonatomic, assign)CGPoint origin;

/**size*/
@property (nonatomic, assign)CGSize size;

/*==============属性只可以获取================*/

/**最左边left = x*/
@property (nonatomic, assign, readonly)CGFloat minX;

/**最右边right = 最左边x + width*/
@property (nonatomic, assign, readonly)CGFloat maxX;

/**最上边top = y*/
@property (nonatomic, assign, readonly)CGFloat minY;

/**最下边bottom = 最上边y + height*/
@property (nonatomic, assign, readonly)CGFloat maxY;

/**中间x = x + width / 2*/
@property (nonatomic, assign, readonly)CGFloat midX;

/**中间y = y + height / 2*/
@property (nonatomic, assign, readonly)CGFloat midY;

/**获取UIView对象所在的控制器,不存在返回nil*/
@property (nonatomic, strong, readonly)UIViewController *viewController;

/**
 *  @author XHJ, 16-06-06 09:06:51
 *
 *  快照
 *
 *  @return view的截图
 */
- (UIImage *)hj_snapshotsWithType:(HJViewSnapshotsType)type;
@end
