//
//  HJShoppingCartController.m
//  HJMethod
//
//  Created by coco on 16/6/12.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJShoppingCartController.h"
#import "HJShoppingBottomBar.h"
#import "HJShoppingService.h"

@interface HJShoppingCartController ()
/**表视图*/
@property (nonatomic, strong)UITableView *tableView;
/**底部工具条*/
@property (nonatomic, strong)HJShoppingBottomBar *bottomBar;
/**代理*/
@property (nonatomic, strong)HJShoppingService *service;
@end

@implementation HJShoppingCartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    [self setup];
}
- (void)setup {
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor hj_randomColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomBar];
    self.bottomBar.backgroundColor = [UIColor hj_randomColor];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
//        make.left.equalTo(@0);
        /*坑   这里不能使用make.left.equalTo(0)
         可以使用make.left.mas_equalTo(0)或者make.left.equalTo(self.view)或者make.left.equalTo(@0)
        */
    }];
    //导航栏左侧按钮为编辑按钮
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (!editing) {
        self.editButtonItem.title = @"编辑";
    } else {
        self.editButtonItem.title = @"完成";
    }
}
#pragma - mark 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:(UITableViewStyleGrouped)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        _tableView.delegate = self.service;
        _tableView.dataSource = self.service;
        _tableView.rowHeight = 100;
        [_tableView registerNib:[UINib nibWithNibName:@"HJShoppingCell" bundle:nil] forCellReuseIdentifier:@"HJShoppingCell"];
    }
    return _tableView;
}
- (HJShoppingService *)service {
    if (!_service) {
        _service = ({
            HJShoppingService *object = [[HJShoppingService alloc] init];
            object;
        });
    }
    return _service;
}
- (HJShoppingBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = ({
            HJShoppingBottomBar *bottomBar = [[HJShoppingBottomBar alloc] init];
            bottomBar;
        });
    }
    return _bottomBar;
}
@end
