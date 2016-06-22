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
#import "HJCircleColorView.h"
#import "HJShoppingCartController.h"
#import "CubeButton.h"
#import "HJMarqueeLabel.h"  //跑马灯
@interface HJJJJJJ : NSObject
/**<#描述#>*/
@property (nonatomic, assign)CGFloat width;
/**<#描述#>*/
@property (nonatomic, assign)CGFloat height;
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height;
@end
@implementation HJJJJJJ
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height {
    if (self = [super init]) {
        _width = width;
        _height = height;
    }
    return self;
}
- (instancetype)init {
    //不会死循环, 注意上面的方法是super init方法
    return [self initWithWidth:5 height:5];
}
@end

@interface ViewController ()
/**hj*/
@property (nonatomic, strong)HJDownAlertView *downAlertView;

/**<#描述#>*/
@property (nonatomic, strong)HJMarqueeLabel *marquee;
@end

@implementation ViewController
- (IBAction)toNoData:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toNoData" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNoData"]) {
        segue.destinationViewController.title = @"测试无数据";
    }
}
- (void)button:(UIButton *)button {
//    if (!self.downAlertView) {
//        self.downAlertView = [HJDownAlertView downAlertViewWithTitle:@"提示" contentText:@"你还没有开启通知,开启通知,实时掌握动态!\n是否现在去打开?" buttonTitle:@"确定" buttonBlock:nil];
//        self.downAlertView = [[HJDownAlertView alloc] init];
//        self.downAlertView.title = @"提示";
//        self.downAlertView.buttonTitle = @"确定";
//        self.downAlertView.buttonClick = ^() {
//            NSLog(@"111");
//        };
//        self.downAlertView.contentText = @"你还没有开启通知,开启通知,实时掌握动态!\n是否\n现在\n去打\n开h\nhhhhhhhhhh?";
//    }
//    [self.downAlertView show];

//    CubeButton *bu = [CubeButton cubeButtonWithButtonTitles:@[@"按钮1", @"按钮2", @"按钮3"] buttonClick:@[^() {
//        NSLog(@"按钮1");
//    },^() {
//        NSLog(@"按钮2");
//    },^() {
//        NSLog(@"按钮3");
//    }]];
//    bu.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:bu];
    
    /*
    [self.view configTipViewHasData:NO hasError:YES reloadButtonBlock:^{
        NSLog(@"没数据");
    }];
    */
    button.selected = !button.selected;
    button.selected ? [self.marquee startAnimation] : [self.marquee stopAnimation];
}
- (void)gwc {
    [self.navigationController pushViewController:[[HJShoppingCartController alloc] init] animated:YES];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(gwc)];
    
    /*
     //旋转的环形进度条
    HJCircleColorView *circle = [[HJCircleColorView alloc] initWithFrame:CGRectMake(0, 44, 100, 100)];
    [circle startAnimation];
    [self.view addSubview:circle];
    */
    
    

    
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
    
    HJJJJJJ *jajj = [[HJJJJJJ alloc] init];
    NSLog(@"%f--%f", jajj.height, jajj.width);
    NSLog(@"====%d", [@"hsdfd" hj_isOnlyLetters]);
    
    
    _marquee  = [[HJMarqueeLabel alloc] init];
    _marquee.frame = CGRectMake(0, 200, 200, 40);
    _marquee.text = @"12345678901234567890123456789012345678901234567890";
    _marquee.backgroundColor = [UIColor lightGrayColor];
    _marquee.textColor = [UIColor blueColor];
    [self.view addSubview:_marquee];
}

- (void)animationDidStart:(CAAnimation *)anim {}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

