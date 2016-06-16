//
//  HJDownAlertView.h
//  HJMethod
//
//  Created by coco on 16/6/8.
//  Copyright © 2016年 XHJ. All rights reserved.
//  添加到window上面, 不要在viewdidload里面直接使用

#import <UIKit/UIKit.h>

@interface HJDownAlertView : UIView

/**标题*/
@property (nonatomic, copy)NSString *title;
/**按钮标题*/
@property (nonatomic, copy)NSString *buttonTitle;
/**提示语*/
@property (nonatomic, copy)NSString *contentText;
/**按钮点击block*/
@property (nonatomic, copy)void (^buttonClick)();

- (void)show;

- (void)dismiss;

/**
 *  类方法
 *
 *  @param title       标题
 *  @param contentText 中间内容
 *  @param buttonTitle 按钮的标题
 *  @param buttonClick 按钮点击方法
 *
 *  @return
 */
+ (HJDownAlertView *)downAlertViewWithTitle:(NSString *)title
                            contentText:(NSString *)contentText
                            buttonTitle:(NSString *)buttonTitle
                            buttonBlock:(void (^)())buttonClick;

/**
 *  初始化方法
 *
 *  @param title       标题
 *  @param contentText 中间内容
 *  @param buttonTitle 按钮的标题
 *  @param buttonClick 按钮点击方法
 *
 *  @return
 */
- (instancetype)initWithTitle:(NSString *)title
                  contentText:(NSString *)contentText
                  buttonTitle:(NSString *)buttonTitle
                  buttonBlock:(void (^)())buttonClick;;

@end
