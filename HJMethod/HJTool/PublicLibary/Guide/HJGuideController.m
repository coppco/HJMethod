//
//  HJGuideController.m
//  HJMethod
//
//  Created by coco on 16/6/8.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJGuideController.h"
#import "Masonry.h"
#define kGuideImageNum 4 //引导图数量
#define kCollectionViewCellIdentify @"collectionViewCell"
@interface HJGuideController () <UICollectionViewDataSource, UICollectionViewDelegate>
/**集合视图*/
@property (nonatomic, strong)UICollectionView *collectionView;
/**分页*/
@property (nonatomic, strong)UIPageControl *pageControl;
/**开始按钮*/
@property (nonatomic, strong)UIButton *beginB;
/**跳过按钮*/
@property (nonatomic, strong)UIButton *skipB;
/**图片数组*/
@property (nonatomic, strong)NSMutableArray *images;
@end

@implementation HJGuideController
//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma - mark 懒加载
- (UIButton *)beginB {
    if (!_beginB) {
        _beginB = ({
            UIButton *button = [[UIButton alloc] init];
            button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(10, self.view.frame.size.height - 120, (self.view.frame.size.width - 20), 40);
            [button setTitle:@"开启App之旅" forState:(UIControlStateNormal)];
            button.layer.cornerRadius = 20;
            button.layer.borderWidth = 1;
            button.backgroundColor = [UIColor redColor];
            button.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
            button.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
            [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [[button titleLabel] setFont:[UIFont systemFontOfSize:16]];
            [button addTarget:self action:@selector(skip:) forControlEvents:(UIControlEventTouchUpInside)];
            button.hidden = YES;
            button;
        });

    }
    return _beginB;
}
- (UIButton *)skipB {
    if (!_skipB) {
        _skipB = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button setTitle:@"跳过" forState:(UIControlStateNormal)];
            button.layer.cornerRadius = 15;
            button.layer.borderWidth = 1;
            [button addTarget:self action:@selector(skip:) forControlEvents:(UIControlEventTouchUpInside)];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor;
            [button setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
            button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
            button;
        });
    }
    return _skipB;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubview];
}

- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
        for (int  i = 0;  i < kGuideImageNum; i++) {
            NSString *str = [NSString stringWithFormat:@"new_feature_%d.png", i + 1];
            [self.images addObject:str];
        }
    }
    return _images;
}

- (void)skip:(UIButton *)button {
    //进入App
    
}

- (void)configSubview {
    //集合视图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentify];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = kGuideImageNum;
    _pageControl.pageIndicatorTintColor = [UIColor greenColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    _pageControl.userInteractionEnabled = NO;
//    [_pageControl addTarget:self action:@selector(imageChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 20));
        make.left.right.bottom.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    //跳过
    [self.view addSubview:self.skipB];
    [self.skipB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.top.equalTo(@10);
        make.right.mas_equalTo(-10);
    }];
}

//- (void)imageChange:(UIPageControl *)page {
//     [_collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width * page.currentPage, 0) animated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (self.collectionView.contentOffset.x / self.collectionView.frame.size.width) + 0.5;
    self.pageControl.currentPage = page;
    
}
#pragma mark - UICollecionViewDelegate 和 UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kGuideImageNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentify forIndexPath:indexPath];
    
    if (cell.backgroundView) {
        UIImageView *imageV = (UIImageView *)cell.backgroundView;
        imageV.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.images[indexPath.item] ofType:nil]];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:collectionView.bounds];
        imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.images[indexPath.item] ofType:nil]];
        cell.backgroundView = imageView;
    }
    
    if (indexPath.item == kGuideImageNum - 1) {
        [cell.backgroundView addSubview:self.beginB];
        self.beginB.hidden = NO;
    } else if (indexPath.row % 2 == (kGuideImageNum % 2) ? 0 : 1){
        self.beginB.hidden = YES;
    }
    
    return cell;
}
@end
