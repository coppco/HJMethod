//
//  HJShoppingBottomBar.h
//  HJMethod
//
//  Created by coco on 16/6/13.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJShoppingBottomBar : UIView
/**总价钱*/
@property (nonatomic, assign)CGFloat money;
/**切换, NO--->结算状态, YES --->删除状态*/
@property (nonatomic, assign)BOOL normal;

@end
