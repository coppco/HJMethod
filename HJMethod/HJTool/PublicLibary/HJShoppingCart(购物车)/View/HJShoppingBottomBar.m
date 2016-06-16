//
//  HJShoppingBottomBar.m
//  HJMethod
//
//  Created by coco on 16/6/13.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJShoppingBottomBar.h"

/**全选按钮文字*/
#define kShopping_bottomBarSelectButtonTitle @"全选"
/**全选按钮宽度*/
#define kShopping_bottomBarSelectButtonWidth 70
/**删除按钮宽度*/
#define kShopping_bottomBarDeleteButtonWidth 100
@interface HJShoppingBottomBar ()
/**全选按钮*/
@property (nonatomic, strong)UIButton *selectButton;
/**删除按钮*/
@property (nonatomic, strong)UIButton *deleteButton;
/**结算按钮*/
@property (nonatomic, strong)UIButton *balanceButton;
/**总价钱文本*/
@property (nonatomic, strong)UILabel *totalPriceLabel;
@end

@implementation HJShoppingBottomBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    //全选按钮
    [self addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(kShopping_bottomBarSelectButtonWidth);
    }];
    
    //删除按钮
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(kShopping_bottomBarDeleteButtonWidth);
    }];
    
    //价格
    [self addSubview:self.totalPriceLabel];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.mas_equalTo(self.selectButton.mas_right);
        make.right.mas_equalTo(self.deleteButton.mas_left);
    }];
    
    //观察者模式
    @weakify(self);
    [RACObserve(self, money) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.totalPriceLabel.text = [NSString stringWithFormat:@"总计￥:%.2f",x.floatValue];
    }];
    /*
    //动态链接,  reduce这里简单对象 需要转成对象
    RAC(self.totalPriceLabel, text) = [RACSignal combineLatest:@[RACObserve(self, money)] reduce:^id (NSNumber *money){
        return [NSString stringWithFormat:@"总计￥:%.2f",money.floatValue];
    }];
     */
    
    RACSignal *signal = [RACSignal combineLatest:@[RACObserve(self, money)] reduce:^id (NSNumber *money){
        if (money.floatValue == 0) {
            self.selectButton.selected = NO;
        }
        return @(money.floatValue > 0);
    }];
    RAC(self.deleteButton, enabled) = signal;
    
    [RACObserve(self, normal) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        BOOL normal = x.boolValue;
        if (normal) {
            [self.deleteButton setTitle:@"删除" forState:(UIControlStateNormal)];
            self.totalPriceLabel.hidden = YES;
        } else {
             [self.deleteButton setTitle:@"结算" forState:(UIControlStateNormal)];
            self.totalPriceLabel.hidden = NO;
        }
    }];
}
#pragma - mark 懒加载
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button setTitle:kShopping_bottomBarSelectButtonTitle forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@"Shopping_bottomBar_normal"] forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:@"Shopping_bottomBar_select"] forState:(UIControlStateSelected)];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [button addTarget:self action:@selector(selectAllShopping:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
    }
    return _selectButton;
}
- (void)selectAllShopping:(UIButton *)button {
    button.selected = !button.selected;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = ({
            UIButton *object = [UIButton buttonWithType:(UIButtonTypeCustom)];

            [object setTitle:@"删除" forState:(UIControlStateNormal)];
            [object setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            //不同状态下的图片
            [object setBackgroundImage:[UIImage hj_imageFromColor:[UIColor redColor]] forState:(UIControlStateNormal)];
             [object setBackgroundImage:[UIImage hj_imageFromColor:[UIColor grayColor]] forState:(UIControlStateDisabled)];
            object;
        });
    }
    return _deleteButton;
}

- (UILabel *)totalPriceLabel {
    if (!_totalPriceLabel) {
        _totalPriceLabel = ({
            UILabel *object = [[UILabel alloc] init];
            object.textColor = [UIColor blackColor];
            object.font = [UIFont systemFontOfSize:17];
            object.adjustsFontSizeToFitWidth = YES;
            object.textAlignment = NSTextAlignmentRight;
            object.text = [NSString stringWithFormat:@"总计￥:%.2f",00.00];
            object;
        });
    }
    return _totalPriceLabel;
}
@end
