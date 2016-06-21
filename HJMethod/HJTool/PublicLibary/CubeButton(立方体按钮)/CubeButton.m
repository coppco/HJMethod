//
//  CubeButton.m
//  HJMethod
//
//  Created by coco on 16/6/21.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "CubeButton.h"

@interface CubeButton ()
/**按钮的名称*/
@property (nonatomic, strong)NSArray <NSString *>*titles;
/**按钮的点击block*/
@property (nonatomic, strong)NSArray <void (^)()>*buttonClick;
@end

@implementation CubeButton

- (instancetype)initWithButtonTitles:(NSArray<NSString *> *)titles buttonClick:(NSArray<void (^)()> *)buttonClick {
    self = [super init];
    if (self) {
        _titles = titles;
        _buttonClick = buttonClick;
        
        //向左滑动的手势
        UISwipeGestureRecognizer *grl = [[UISwipeGestureRecognizer alloc] init];
        [grl setDirection:UISwipeGestureRecognizerDirectionLeft];
        [grl addTarget:self action:@selector(selectMenuItemLeft)];
        [self addGestureRecognizer:grl];
        //向右滑动的手势
        UISwipeGestureRecognizer *grr = [[UISwipeGestureRecognizer alloc] init];
        [grr setDirection:UISwipeGestureRecognizerDirectionRight];
        [grr addTarget:self action:@selector(selectMenuItemRight)];
        [self addGestureRecognizer:grr];
        
        [self configSubview];
    }
    return self;
}
+ (CubeButton *)cubeButtonWithButtonTitles:(NSArray<NSString *> *)titles buttonClick:(NSArray<void (^)()> *)buttonClick {
    return [[self alloc] initWithButtonTitles:titles buttonClick:buttonClick];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //向左滑动的手势
        UISwipeGestureRecognizer *grl = [[UISwipeGestureRecognizer alloc] init];
        [grl setDirection:UISwipeGestureRecognizerDirectionLeft];
        [grl addTarget:self action:@selector(selectMenuItemLeft)];
        [self addGestureRecognizer:grl];
        //向右滑动的手势
        UISwipeGestureRecognizer *grr = [[UISwipeGestureRecognizer alloc] init];
        [grr setDirection:UISwipeGestureRecognizerDirectionRight];
        [grr addTarget:self action:@selector(selectMenuItemRight)];
        [self addGestureRecognizer:grr];
    }
    return self;
}

- (void)configSubview {
    NSInteger minCount = MIN(_titles.count, _buttonClick.count);
    for (int i = 0; i < minCount; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:_titles[i] forState:(UIControlStateNormal)];
//        button.hidden = YES;
//        if (0 == i) {
//            button.hidden = NO;
//        }
        button.tag = 5600 + i;
        [button addTarget:self action:@selector(buttonHasClick:) forControlEvents:(UIControlEventTouchUpInside)];
        button.backgroundColor = [UIColor hj_randomColor];
        [self addSubview:button];
    }
}
- (void)buttonHasClick:(UIButton *)button {
    void (^blcok)() = _buttonClick[button.tag - 5600];
    if (blcok) {
        blcok();
    }
}
//向左
- (void)selectMenuItemLeft{
    //动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.8;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;
    
    NSInteger i = MIN(_titles.count, _buttonClick.count) - 1;
    //最上面的一个view
    UIButton *button = (UIButton *)[self.subviews lastObject];

    if (button.tag - 5600 < i) {
        UIView *view = [self viewWithTag:button.tag + 1];

        [self bringSubviewToFront:view];
    } else if (button.tag - 5600 == i){
        UIView *view = [self viewWithTag:5600];

        [self bringSubviewToFront:view];
    }
    
     [self.layer addAnimation:animation forKey:@"animation"];
}
//向右
- (void)selectMenuItemRight{
    //动画
    CATransition *animation = [CATransition animation];
    animation.duration = 0.8;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromLeft;
    
    NSInteger i = MIN(_titles.count, _buttonClick.count) - 1;
    //最上面的一个view
    UIButton *button = (UIButton *)[self.subviews lastObject];

    if (button.tag - 5600 == 0) {
        UIView *view = [self viewWithTag:5600 + i];
        [self bringSubviewToFront:view];
    } else if (button.tag - 5600 > 0){
        UIView *view = [self viewWithTag:button.tag - 1];

        [self bringSubviewToFront:view];
    }
    
    [self.layer addAnimation:animation forKey:@"animation"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIButton *butotn in self.subviews) {
        butotn.frame = self.bounds;
    }
}
@end
