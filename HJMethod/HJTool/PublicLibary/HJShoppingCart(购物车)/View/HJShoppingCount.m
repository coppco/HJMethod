//
//  HJShoppingCount.m
//  HJMethod
//
//  Created by coco on 16/6/14.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJShoppingCount.h"

@interface HJShoppingCount ()
/**加*/
@property (nonatomic, strong)UIButton *addButton;
/**减*/
@property (nonatomic, strong)UIButton *minusButton;
/**输入框*/
@property (nonatomic, strong)UITextField *inputTextField;
@end

@implementation HJShoppingCount

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
    self.currentNum = 0;
    self.totalNum = 10;
    [self addSubview:self.minusButton];
    [self addSubview:self.inputTextField];
    [self addSubview:self.addButton];
    //布局
    [@[self.minusButton, self.inputTextField, self.addButton] mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[self.minusButton, self.inputTextField, self.addButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
    }];
    
    //动态绑定
    //按钮的方法
    @weakify(self);
    [[self.minusButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        self.currentNum -= 1;
        if (self.numberChange) {
            self.numberChange(self.currentNum);
        }
    }];
    [[self.addButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        @strongify(self);
        self.currentNum += 1;
        if (self.numberChange) {
            self.numberChange(self.currentNum);
        }
    }];
    
    //监听事件
    
    [[self.inputTextField rac_signalForControlEvents:(UIControlEventEditingChanged)] subscribeNext:^(UITextField *text) {
        NSString *x = text.text;

        NSString *regan1 = @"(^\\d+|^.{1}\\d{1,})(.\\d{1,})?$"; //匹配数字  和小数
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regan1 options:(NSRegularExpressionAllowCommentsAndWhitespace) error:nil];
        NSArray *arr = [regular matchesInString:x options:(0) range:NSMakeRange(0, x.length)];
        NSLog(@"%d", arr.count);
        /*
        if (x.floatValue > self.totalNum && self.totalNum != 0) {
            self.currentNum = self.totalNum;
        } else if (x.floatValue < 0) {
            self.currentNum = 0;
        } else {
            self.currentNum = x.floatValue;
        }
         */
    }];
     
    
    /*
    [[self.inputTextField rac_textSignal] subscribeNext:^(NSString *x) {
        if (x.floatValue > self.totalNum && self.totalNum != 0) {
            self.currentNum = self.totalNum;
        } else if (x.floatValue < 0) {
            self.currentNum = 0;
        } else {
            self.currentNum = x.floatValue;
        }
        if (self.numberChange) {
            self.numberChange(self.currentNum);
        }
    }];
     */
    
    
    //绑定按钮的enable  map 转换事件
    RACSignal *addSignal = [RACObserve(self, currentNum) map:^id(NSNumber *value) {
        return @(value.floatValue < self.totalNum);
    }];
    RACSignal *minusSignal = [RACObserve(self, currentNum) map:^id(NSNumber *value) {
        return @(value.floatValue > 0);
    }];
    RAC(self.minusButton, enabled) = minusSignal;
    RAC(self.addButton, enabled) = addSignal;
    
    //监听currentNum
    /*
     //方法1
    [RACObserve(self, currentNum) subscribeNext:^(NSNumber *x) {
        self.inputTextField.text = [NSString stringWithFormat:@"%.0f", x.floatValue];
    }];
     */
    /*
     //方法2
    [[RACObserve(self, currentNum) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%0.f", value.floatValue];
    }] subscribeNext:^(NSString *x) {
        self.inputTextField.text =x;
    }];
     */
    /*
    //方法3
    RAC(self.inputTextField, text) = [RACSignal combineLatest:@[RACObserve(self, currentNum)] reduce:^id (NSNumber *value){
        return [NSString stringWithFormat:@"%.0f", value.floatValue];
    }];
     */
//    RAC(self.inputTextField, text) = [RACObserve(self, currentNum) map:^id(NSNumber *value) {
//        return [NSString stringWithFormat:@"%.2f", value.floatValue];
//    }];
    
    //颜色
    RAC(self.inputTextField, textColor) = [RACSignal combineLatest:@[self.inputTextField.rac_textSignal] reduce:^id (NSString *value){
        return value.floatValue == self.totalNum ? [UIColor redColor] : [UIColor blackColor];
    }];
}
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = ({
            UIButton *object = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [object setBackgroundImage:[UIImage imageNamed:@"product_detail_add_no"] forState:(UIControlStateDisabled)];
            [object setBackgroundImage:[UIImage imageNamed:@"product_detail_add_normal"] forState:(UIControlStateNormal)];
            object;
        });
    }
    return _addButton;
}
- (UIButton *)minusButton {
    if (!_minusButton) {
        _minusButton = ({
            UIButton *object = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [object setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_no"] forState:(UIControlStateDisabled)];
            [object setBackgroundImage:[UIImage imageNamed:@"product_detail_sub_normal"] forState:(UIControlStateNormal)];
            object;
        });
    }
    return _minusButton;
}
- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = ({
            UITextField *object = [[UITextField alloc] init];
            object.keyboardType = UIKeyboardTypeDecimalPad;
//            object.keyboardType = UIKeyboardTypeNumberPad;
//            object.borderStyle = UITextBorderStyleRoundedRect;
//            object.clearButtonMode = UITextFieldViewModeWhileEditing;
            object.adjustsFontSizeToFitWidth = YES;
//            object.clearsOnBeginEditing = YES; //编辑的时候清空
            object.tintColor = [UIColor blueColor];
            object.backgroundColor = [UIColor whiteColor];
            object.textColor = [UIColor blackColor];
            object.adjustsFontSizeToFitWidth = YES;
            object.textAlignment=NSTextAlignmentCenter;
            
            object.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor;
            object.layer.borderWidth = 1.3;
            object;
        });
    }
    return _inputTextField;
}
@end
