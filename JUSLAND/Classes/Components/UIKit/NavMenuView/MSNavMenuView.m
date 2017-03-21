//
//  MSNavMenuView.m
//  MIS
//
//  Created by LIUZHEN on 2017/3/11.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSNavMenuView.h"
#import "MSNavMenuItemCell.h"
#import "MSNavMenuItem.h"

@interface MSNavMenuView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *menuCollectionView;
@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation MSNavMenuView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConfig {
    _equipartition = YES;
    _showSlectedState = YES;
    _selectedIndex = 0;
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    menuCollectionView.dataSource = self;
    menuCollectionView.delegate = self;
    menuCollectionView.showsHorizontalScrollIndicator = NO;
    menuCollectionView.backgroundColor = [UIColor whiteColor];
    [menuCollectionView registerClass:[MSNavMenuItemCell class]
           forCellWithReuseIdentifier:[MSNavMenuItemCell cellIdentifier]];
    self.menuCollectionView = menuCollectionView;
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor ms_orangeColor];
    selectedView.layer.cornerRadius = 3.0f;
    self.selectedView = selectedView;
    
    [self addSubview:menuCollectionView];
}

#pragma mark - Layout

- (void)setupConstraints {
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSNavMenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
    MSNavMenuItemCell *cell = [MSNavMenuItemCell cellWithCollectionView:collectionView indexPath:indexPath];
    [cell configureCell:item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.equipartition) {
        MSNavMenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
        CGSize size = [item.name sizeWithAttributes:@{NSFontAttributeName : [UIFont ms_smallFont]}];
        CGFloat width = size.width;
        if (item.orderType != MSNavMenuItemOrderTypeNone) {
            width += 40;
        } else {
            width += 20;
        }
        return CGSizeMake(width, collectionView.ms_height);
    } else {
        return CGSizeMake(collectionView.ms_width / self.menuItems.count, collectionView.ms_height);
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self scrollToItemAtIndex:indexPath.row animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navMenuView:didScrollToIndex:)]) {
        [self.delegate navMenuView:self didScrollToIndex:indexPath.row];
    }
}

#pragma mark - Public Methods

- (void)reloadWithTitles:(NSArray <NSString *> *)titles {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSString *title in titles) {
        MSNavMenuItem *item = [[MSNavMenuItem alloc] init];
        item.name = title;
        item.selected = [title isEqualToString:titles.firstObject];
        [items addObject:item];
    }
    [self reloadWithItems:items];
}

- (void)reloadWithItems:(NSArray <MSNavMenuItem *> *)items {
    [self.menuItems removeAllObjects];
    [self.menuItems addObjectsFromArray:items];
    [self scrollToItemAtIndex:_selectedIndex animated:NO];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (index > self.menuItems.count) {
        return ;
    }
    
    _selectedIndex = index;
    for (MSNavMenuItem *item in self.menuItems) {
        item.selected = NO;
    }
    MSNavMenuItem *item = [self.menuItems objectAtIndex:_selectedIndex];
    item.selected = YES;
    [self.menuCollectionView reloadData];
    [self.menuCollectionView layoutIfNeeded];
    
    if (_showSlectedState) {
        if (![self.menuCollectionView.subviews containsObject:self.selectedView]) {
            [self.menuCollectionView addSubview:self.selectedView];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
            UICollectionViewCell *cell = [self.menuCollectionView cellForItemAtIndexPath:indexPath];
            [self.menuCollectionView scrollToItemAtIndexPath:indexPath
                                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                    animated:YES];
            
            self.selectedView.ms_height = 2;
            self.selectedView.ms_bottom = self.menuCollectionView.ms_bottom;
            if (animated) {
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                    self.selectedView.ms_left = cell.ms_left;
                    self.selectedView.ms_width = cell.ms_width;
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                self.selectedView.ms_left = cell.ms_left;
                self.selectedView.ms_width = cell.ms_width;
            }
        });
    }
}

#pragma mark - Getter

- (NSMutableArray *)menuItems {
    if (_menuItems == nil) {
        _menuItems = [[NSMutableArray alloc] init];
    }
    return _menuItems;
}

@end
