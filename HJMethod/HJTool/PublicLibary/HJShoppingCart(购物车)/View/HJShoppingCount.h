//
//  HJShoppingCount.h
//  HJMethod
//
//  Created by coco on 16/6/14.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJShoppingCount : UIView
/**总数*/
@property (nonatomic, assign)CGFloat totalNum;

/**当前数*/
@property (nonatomic, assign)CGFloat currentNum;

/**数字改变block*/
@property (nonatomic, copy)void (^numberChange)(CGFloat number);
@end
