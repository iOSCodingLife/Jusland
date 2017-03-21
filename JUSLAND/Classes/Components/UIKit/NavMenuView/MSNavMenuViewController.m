//
//  MSNavMenuViewController.m
//  MIS
//
//  Created by LIUZHEN on 2017/3/11.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSNavMenuViewController.h"

static NSString *kMSNavMenuCollectionViewCell = @"MSNavMenuCollectionViewCell";

@interface MSNavMenuViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MSNavMenuViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MSNavMenuView *menuView;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation MSNavMenuViewController

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _allowsNavBarChange = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupConstraints];
}

#pragma mark - Setup navbar

- (void)setupNavbar:(UIViewController *)viewController {
    self.title = viewController.title;
    self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor ms_backgroundColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[UICollectionViewCell class]
       forCellWithReuseIdentifier:kMSNavMenuCollectionViewCell];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.collectionView = collectionView;
    
    [self.view addSubview:self.menuView];
    [self.view addSubview:collectionView];
    if (self.menuTitles.count > 0) {
        [self.menuView reloadWithTitles:self.menuTitles];
    } else if (self.menuItems.count > 0) {
        [self.menuView reloadWithItems:self.menuItems];
    }
}

#pragma mark - Layout

- (void)setupConstraints {
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSNavMenuCollectionViewCell forIndexPath:indexPath];
    
    UIViewController *viewController = [self.viewControllers objectAtIndex:indexPath.row];
    viewController.view.tag = indexPath.row;
    UIView *view = viewController.view;
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (![cell.contentView.subviews containsObject:view]) {
        [cell.contentView addSubview:viewController.view];
        [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_allowsNavBarChange) {
        UIViewController *viewController = [self.viewControllers objectAtIndex:indexPath.row];
        [self setupNavbar:viewController];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.ms_size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UICollectionView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.collectionView.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
        return;
    }
    
    if (scrollView.contentOffset.x > (self.viewControllers.count - 1) * self.view.ms_width) {
        [scrollView setContentOffset:CGPointMake((self.viewControllers.count - 1) * self.view.ms_width, 0)];
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / self.view.ms_width;
    [self.menuView scrollToItemAtIndex:page animated:YES];
}

#pragma mark - MSNavMenuViewDelegate

- (void)navMenuView:(MSNavMenuView *)menuView didScrollToIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

#pragma mark - Setter

- (void)setMenuTitles:(NSArray <NSString *> *)menuTitles {
    _menuTitles = menuTitles;
}

- (void)setMenuItems:(NSArray <MSNavMenuItem *> *)menuItems {
    _menuItems = menuItems;
}

- (void)setViewControllers:(NSArray <UIViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    for (UIViewController *viewController in viewControllers) {
        [self addChildViewController:viewController];
    }
    [self.collectionView reloadData];
}

#pragma mark - Getter

- (MSNavMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[MSNavMenuView alloc] init];
        _menuView.delegate = self;
    }
    return _menuView;
}

@end
