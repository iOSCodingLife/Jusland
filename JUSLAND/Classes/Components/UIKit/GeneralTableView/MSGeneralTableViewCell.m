//
//  MSTableViewCell.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/16.
//  Copyright © 2016年 58. All rights reserved.
//

#import "MSGeneralTableViewCell.h"

@interface MSGeneralTableViewCell ()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *checkBoxImageView;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation MSGeneralTableViewCell

#pragma mark - Class methods

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    MSGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self reuseIdentifier]];
    if (cell == nil) {
        cell = [[MSGeneralTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:[self reuseIdentifier]];
    }
    return cell;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont ms_normalFont];
        self.textLabel.textColor = [UIColor ms_blackColor];
        
        self.detailTextLabel.font = [UIFont ms_smallFont];
        self.detailTextLabel.textColor = [UIColor ms_grayColor];
        self.detailTextLabel.numberOfLines = -1;
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = CGSizeMake(self.contentView.width * 0.6f, self.contentView.height);
    self.detailTextLabel.size = [self.detailTextLabel sizeThatFits:size];
    self.detailTextLabel.centerY = self.contentView.centerY;
    if (self.accessoryView == nil) {

//        self.detailTextLabel.right = self.contentView.right - 15;
    }
}

#pragma mark - Configure

- (void)configureCell:(MSCellItem *)item {
    // 1.设置基本数据
    self.imageView.image = item.image;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    // 2.设置右边的内容
    //    if (false) {// &&item.badgeValue) { // 紧急情况：右边有提醒数字
    //        self.bageView.badgeValue = item.badgeValue;
    //        self.accessoryView = self.bageView;
    //    } else
    if (item.type == MSCellItemTypeArrow) {
        self.accessoryView = self.arrowImageView;
    } else if (item.type == MSCellItemTypeSwitch) {
        self.accessoryView = self.switchView;
    } else if (item.type == MSCellItemTypeCheckbox) {
        self.accessoryView = self.checkBoxImageView;
    } else {
        self.accessoryView = nil;
    }
}

#pragma mark - Event Handler

- (void)onChangedSwitchStatus:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(generalTableViewCell:didTapSwitch:)]) {
        [self.delegate generalTableViewCell:self didTapSwitch:self.switchView];
    }
}

#pragma mark - Getter

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"Common_Right_Arrow"];
        _arrowImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _arrowImageView;
}

- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = [UIColor ms_orangeColor];
        [_switchView addTarget:self action:@selector(onChangedSwitchStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIImageView *)checkBoxImageView {
    if (_checkBoxImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"Common_Unchecked"];
        _checkBoxImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _checkBoxImageView;
}

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.numberOfLines = -1;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = [UIColor ms_grayColor];
        _rightLabel.font = [UIFont ms_smallFont];
    }
    return _rightLabel;
}

@end
