//
//  UIView+HJExtension.h
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//   UIView的常用属性

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@class HJTipView;
typedef  enum {
    HJViewSnapshotsTypeNone,  //不保存
    HJViewSnapshotsTypePhotes,  //相册  保存到相册会自动在沙盒缓存
    HJViewSnapshotsTypeSandbox,  //沙盒
    HJViewSnapshotsTypeBoth  //沙盒和相册
}HJViewSnapshotsType;

/* 渐进动画类型*/
typedef enum {
    AnimateTypeBig,  //放大
    AnimateTypeSmall,  //缩小
}AnimateType;


/*一些动画类型*/
typedef NS_ENUM(NSInteger, HJAnimationType) {
    HJAnimationTypeFade = 1,                   //淡入淡出
    HJAnimationTypePush,                       //推挤
    HJAnimationTypeReveal,                     //揭开
    HJAnimationTypeMoveIn,                     //覆盖
    HJAnimationTypeCube,                       //立方体
    HJAnimationTypeSuckEffect,                 //吮吸
    HJAnimationTypeOglFlip,                    //翻转
    HJAnimationTypeRippleEffect,               //波纹
    HJAnimationTypePageCurl,                   //翻页
    HJAnimationTypePageUnCurl,                 //反翻页
    HJAnimationTypeCameraIrisHollowOpen,       //开镜头
    HJAnimationTypeCameraIrisHollowClose,      //关镜头
    HJAnimationTypeCurlDown,                   //下翻页
    HJAnimationTypeCurlUp,                     //上翻页
    HJAnimationTypeFlipFromLeft,               //左翻转
    HJAnimationTypeFlipFromRight,              //右翻转
};
/*动画方向*/
typedef NS_ENUM(NSInteger, DirectionType) {
    DirectionTypeLeft = 1, //左
    DirectionTypeRight, //右
    DirectionTypeBottom,  //下
    DirectionTypeTop,  //上
};


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
 *
 *  快照
 *
 *  @return view的截图
 */
- (UIImage *)hj_snapshotsWithType:(HJViewSnapshotsType)type;

#pragma - mark 动画相关
/**
 *  抖动动画
 */
- (void)animationShake;

/**
 *  慢慢放大或者缩小的动画
 *
 *  @param type   放大或者缩小
 *  @param rotate 是否旋转一点
 */
- (void)animationGradualType:(AnimateType)type isRotateFew:(BOOL)rotate delegate:(id)delegate;

/**
 *  CATransition动画
 *
 *  @param duration  动画时长
 *  @param type      动画类型
 *  @param direction 动画方向
 */
- (void)animationCATransitionWithDuration:(NSTimeInterval)duration type:(HJAnimationType)type direction:(DirectionType)direction;

/**
 *  是否自动布局
 *
 *  @return YES----->代码布局  NO---->autoLayout
 */
- (BOOL)hj_enforceFrameLayout;
//加载时的动画

/**
 *  返回自动布局的size
 *
 *  @return 
 */
- (CGSize)autoLayoutSizeWithWidth:(CGFloat)width;

//无数据或者网络错误时候的显示视图
/**tipView*/
@property (nonatomic, strong)HJTipView *tipView;
- (void)configTipViewHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock;
@end

@interface HJTipView : UIView
/**图片*/
@property (nonatomic, strong)UIImageView *imageView;
/**文字*/
@property (nonatomic, strong)UILabel *tipLabel;
/**重新加载按钮*/
@property (nonatomic, strong)UIButton *reloadButton;
/**重新加载按钮执行block*/
@property (nonatomic, copy)void (^reloadButtonBlock)();
- (void)configTipViewHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock;
@end
