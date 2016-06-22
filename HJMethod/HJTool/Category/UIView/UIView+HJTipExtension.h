//
//  UIView+HJTipExtension.h
//  HJMethod
//
//  Created by coco on 16/6/21.
//  Copyright © 2016年 XHJ. All rights reserved.
//  只是测试,不做实际开发使用

#import <UIKit/UIKit.h>

@interface HJTipView : UIView
@end

@interface UIView (HJTipExtension)
/**NoData无数据视图  还需要手动配置*/
//@property (nonatomic, strong)HJTipView *tipView;
- (void)configTipViewHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock;
@end
