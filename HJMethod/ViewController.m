//
//  ViewController.m
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "ViewController.h"
#import "HJTool.h"
#import <Availability.h>
#import "HJDownAlertView.h"

@interface ViewController ()
/**hj*/
@property (nonatomic, strong)HJDownAlertView *downAlertView;
@end

@implementation ViewController
- (void)button:(UIButton *)button {
    if (!self.downAlertView) {
        self.downAlertView = [HJDownAlertView downAlertViewWithTitle:@"提示" contentText:@"自\n定\n义\n弹\n出\n,\n高\n度\n自\n适\n应\n!" buttonTitle:@"取消" buttonBlock:^{
            self.view.backgroundColor = [UIColor hj_randomColor];
        }];
    }
    [self.downAlertView show];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.bounds = CGRectMake(0, 0, 100, 30);
    [button setTitle:@"点我吧" forState:(UIControlStateNormal)];
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [button addTarget:self action:@selector(button:) forControlEvents:(UIControlEventTouchUpInside)];
    button.center = self.view.center;
    [self.view addSubview:button];
    
//    self.view.backgroundColor = kColorFromRGBValue(292213);
//    self.view.backgroundColor = [UIColor colorFromHexString:@"0xabcdef"];
//    kColorFromRGBA(<#R#>, <#G#>, <#B#>, <#A#>)
//
//    NSString *string = @"1";
    NSLog(@"%@", [NSString hj_pathCaches] );
//
//    [string writeToFile:[NSString pathCachesFileName:@"a.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    [string writeToFile:[NSString pathCachesSubPath:@"a" fileName:@"a.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    [string writeToFile:[NSString pathDocumentsFileName:@"b.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    [string writeToFile:[NSString pathDocumentsSubPath:@"b" fileName:@"b.txt"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *sti;
//    UIApplicationDidBecomeActiveNotification
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:20121111];
    XHJLog(@"%ld-%ld-%ld", date.year, date.month, date.day);
    [sti hj_isValidIndentifyNumber];
    
    XHJLog(@"%.0f", [@"dsfjdslj大幅度是浪费了第三方了电视剧反垄断法律是放假了圣诞节发的是减肥了sdfdsdsfsdljfldsjlfksdjlsdjfdlsjlsdjflsdjlsdjflsdjlsdjflsa多少级分类的解放路上几分的减肥减肥fsdljfsldjflsjfdfjklsdfjslfldsjfldsjfdls" hj_heightForWidth:100 font:[UIFont systemFontOfSize:17]]);
    
//    hj_callTelephoneNumber(@"15105713500", NO);

    NSString *string = hj_dictionaryOrArrayTransformToJSONString(@{@"a":@[@1, @2, @3], @"b":@"我们"});
    XHJLog(@"字符串%@", string);
   NSDictionary *dic =  hj_JSONTransformToDictionaryOrArray(@"{\"a\":[1,2,3],\"b\":\"我们\"}");
    XHJLog(@"字典%@", dic);

    //touchID
//    [TouchID showTouchIdOnCompletion:^(BOOL success, NSError *authenticationError) {
//        
//    } failed:^(NSError *authenticationError) {
//        
//    }];
    
        XHJLog(@"%@", [@"123456" hj_safedStringWithType:(EncryptTypeMD5)]);
//    [self.view hj_snapshotsWithType:(HJViewSnapshotsTypeSandbox)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)animationDidStart:(CAAnimation *)anim {}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
