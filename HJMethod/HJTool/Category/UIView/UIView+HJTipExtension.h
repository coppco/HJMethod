//
//  UIView+HJTipExtension.h
//  HJMethod
//
//  Created by coco on 16/6/21.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJTipView : UIView
@end

@interface UIView (HJTipExtension)
/**NoData无数据视图*/
@property (nonatomic, strong)HJTipView *tipView;
- (void)configTipViewHasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)())reloadButtonBlock;
@end
