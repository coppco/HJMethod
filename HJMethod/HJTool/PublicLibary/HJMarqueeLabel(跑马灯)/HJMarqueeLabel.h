//
//  HJMarqueeLabel.h
//  tableViewAnimation
//
//  Created by coco on 16/6/22.
//  Copyright © 2016年 XHJ. All rights reserved.
//   跑马灯效果的Label

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HJMarqueeSpeed) {
    HJMarqueeSpeedLow,  //慢
    HJMarqueeSpeedMid,  //中等
    HJMarqueeSpeedFast   //快速
};

@interface HJMarqueeLabel : UIView
/**文字数组*/
@property (nonatomic, strong)NSArray *textArray;

/**文字大小,默认15*/
@property (nonatomic, strong)UIFont *font;
/**文字颜色,默认白色*/
@property (nonatomic, strong)UIColor *textColor;
/**重复次数, 默认为0一直重复*/
@property (nonatomic, assign)CGFloat repeatCount;
/**速度, 默认中等*/
@property (nonatomic, assign)HJMarqueeSpeed speedType;

- (void)startAnimation;
- (void)stopAnimation;
@end
