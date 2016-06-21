//
//  CubeButton.h
//  HJMethod
//
//  Created by coco on 16/6/21.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CubeButton : UIView

+ (nonnull CubeButton *)cubeButtonWithButtonTitles:(nonnull NSArray <NSString *>*)titles buttonClick:(nonnull NSArray <void (^)()>*)buttonClick;

- (nonnull instancetype)initWithButtonTitles:(nonnull NSArray  <NSString *>*)titles buttonClick:(nonnull NSArray <void (^)()>*)buttonClick;
@end
