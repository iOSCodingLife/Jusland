//
//  MSNavMenuItemCell.m
//  MIS
//
//  Created by LIUZHEN on 2017/3/11.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSNavMenuItemCell.h"

@interface MSNavMenuItemCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *orderImageView;
@property (nonatomic, weak) UIView *separator;

@end

@implementation MSNavMenuItemCell

#pragma mark - Class Methods

+ (MSNavMenuItemCell *)cellWithCollectionView:(UICollectionView *)collectionView
                                    indexPath:(NSIndexPath *)indexPath {
    NSString *ID = [self cellIdentifier];
    MSNavMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID
                                                                        forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MSNavMenuItemCell alloc] initWithFrame:CGRectZero];
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
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor ms_blackColor];
    nameLabel.font = [UIFont ms_smallFont];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel = nameLabel;
    
    UIImageView *orderImageView = [[UIImageView alloc] init];
    self.orderImageView = orderImageView;
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor ms_separatorColor];
    self.separator = separator;
    
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:orderImageView];
    [self.contentView addSubview:separator];
}

#pragma mark - Layout

- (void)setupConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    [self.orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.nameLabel.mas_right).with.offset(10);
    }];
    
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).with.offset(-0.5f);
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - configure

- (void)configureCell:(MSNavMenuItem *)item {
    self.nameLabel.text = item.name;
    if (item.isSelected) {
        self.nameLabel.textColor = [UIColor ms_orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor ms_blackColor];
    }
    
    if (item.orderType == MSNavMenuItemOrderTypeNone) {
        self.orderImageView.image = nil;
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    } else {
        if (item.orderType == MSNavMenuItemOrderTypeAsc) {
            self.orderImageView.image = [UIImage imageNamed:@"CRM_Opportunity_Filter_Order_Asc"];
        } else if (item.orderType == MSNavMenuItemOrderTypeDesc) {
            self.orderImageView.image = [UIImage imageNamed:@"CRM_Opportunity_Filter_Order_Desc"];
        }
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).with.offset(-10);
        }];
    }
}

@end
