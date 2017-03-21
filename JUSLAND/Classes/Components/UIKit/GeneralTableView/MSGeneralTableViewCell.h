//
//  MSTableViewCell.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/16.
//  Copyright © 2016年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCellItem.h"

@class MSGeneralTableViewCell;
@protocol MSGeneralTableViewCellDelegate <NSObject>

- (void)generalTableViewCell:(MSGeneralTableViewCell *)cell didTapSwitch:(UISwitch *)switchView;

@end

@interface MSGeneralTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *arrowImageView;
@property (nonatomic, strong, readonly) UIImageView *checkBoxImageView;
@property (nonatomic, strong, readonly) UISwitch *switchView;
@property (nonatomic, strong, readonly) UILabel *rightLabel;

@property (nonatomic, weak) id <MSGeneralTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (NSString *)reuseIdentifier;

- (void)configureCell:(MSCellItem *)item;

@end
