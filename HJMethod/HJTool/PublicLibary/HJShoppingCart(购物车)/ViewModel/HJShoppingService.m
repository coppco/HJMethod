//
//  HJShoppingService.m
//  HJMethod
//
//  Created by coco on 16/6/13.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJShoppingService.h"

@interface HJShoppingService ()

@end

@implementation HJShoppingService
#pragma - mark UITableViewDelegate 和 UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HJShoppingCell" forIndexPath:indexPath];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}
@end
