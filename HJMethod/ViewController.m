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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    XHJLog(@"%.0f", [@"dsfjdslj大幅度是浪费了第三方了电视剧反垄断法律是放假了圣诞节发的是减肥了多少级分类的解放路上几分的减肥减肥fsdljfsldjflsjfdfjklsdfjslfldsjfldsjfdls" hj_heightForWidth:100 font:[UIFont systemFontOfSize:17]]);
    
//    hj_callTelephoneNumber(@"15105713500", NO);

    NSString *string = hj_dictionaryOrArrayTransformToJSONString(@{@"a":@[@1, @2, @3], @"b":@"我们"});
    XHJLog(@"字符串%@", string);
   NSDictionary *dic =  hj_JSONTransformToDictionaryOrArray(@"{\"a\":[1,2,3],\"b\":\"我们\"}");
    XHJLog(@"字典%@", dic);

    
    [TouchID showTouchIdOnCompletion:^(BOOL success, NSError *authenticationError) {
        
    } failed:^(NSError *authenticationError) {
        
    }];
    
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
