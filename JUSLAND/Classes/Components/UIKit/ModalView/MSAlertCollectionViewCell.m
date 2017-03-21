//
//  MSAlertCollectionViewCell.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/19.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSAlertCollectionViewCell.h"

@interface MSAlertCollectionViewCell ()

@property (nonatomic, weak) UILabel *actionLabel;
@property (nonatomic, weak) UIView *horizontalSeparator;
@property (nonatomic, weak) UIView *verticalSeparator;

@end

@implementation MSAlertCollectionViewCell

#pragma mark - Class Methods

+ (MSAlertCollectionViewCell *)cellWithCollectionView:(UICollectionView *)collectionView
                                            IndexPath:(NSIndexPath *)indexPath {
    NSString *ID = [self cellIdentifier];
    MSAlertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID
                                                                                forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MSAlertCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    return cell;
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - setup Subviews

- (void)setupSubviews {
    UILabel *actionLabel = [[UILabel alloc] init];
    actionLabel.font = [UIFont ms_normalFont];
    actionLabel.textAlignment = NSTextAlignmentCenter;
    self.actionLabel = actionLabel;
    
    UIView *horizontalSeparator = [[UIView alloc] init];
    horizontalSeparator.backgroundColor = [UIColor ms_separatorColor];
    self.horizontalSeparator = horizontalSeparator;
    
    UIView *verticalSeparator = [[UIView alloc] init];
    verticalSeparator.backgroundColor = [UIColor ms_separatorColor];
    self.verticalSeparator = verticalSeparator;
    
    [self.contentView addSubview:actionLabel];
    [self.contentView addSubview:horizontalSeparator];
    [self.contentView addSubview:verticalSeparator];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    UIColor *backgroundColor = [UIColor whiteColor];
    if (highlighted) {
        self.backgroundColor = [UIColor darkerColorForColor:backgroundColor];
    } else {
        self.backgroundColor = backgroundColor;
    }
}

#pragma mark - Layout

- (void)setupConstraints {
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).with.offset(-0.5f);
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.verticalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_right).with.offset(-0.5);
        make.right.equalTo(self.contentView);
    }];
}

#pragma mark - configure

- (void)configureCell:(MSAlertAction *)action {
    self.actionLabel.text = action.title;
    if (action.style == MSAlertActionStyleDestructive) {
        self.actionLabel.textColor = [UIColor ms_orangeColor];
    } else {
        self.actionLabel.textColor = [UIColor ms_blackColor];
    }
}

#pragma mark - Setter

- (void)setShowVerticalSeparator:(BOOL)showVerticalSeparator {
    _showVerticalSeparator = showVerticalSeparator;
    self.verticalSeparator.hidden = !showVerticalSeparator;
}

@end
