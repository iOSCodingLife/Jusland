//
//  MSGeneralViewController.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/16.
//  Copyright © 2016年 58. All rights reserved.
//

#import "MSGeneralViewController.h"
#import "MSGeneralTableViewCell.h"

@interface MSGeneralViewController () <MSGeneralTableViewCellDelegate>

@end

@implementation MSGeneralViewController

#pragma mark - Life cycle

- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor ms_backgroundColor];
    
    self.tableView.separatorColor = [UIColor ms_separatorColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[MSGeneralTableViewCell class]
           forCellReuseIdentifier:[MSGeneralTableViewCell reuseIdentifier]];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MSCellGroup *group = [self.dataSource objectAtIndex:section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSCellGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    MSCellItem *item = [group.items objectAtIndex:indexPath.row];
    
    MSGeneralTableViewCell *cell = [MSGeneralTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    [cell configureCell:item];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MSCellGroup *group = [self.dataSource objectAtIndex:section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    MSCellGroup *group = [self.dataSource objectAtIndex:section];
    return group.footer;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MSCellGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    MSCellItem *item = [group.items objectAtIndex:indexPath.row];
    if (item.type != MSCellItemTypeSwitch) {
        if (item.didClickHandler) {
            item.didClickHandler();
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MSCellGroup *group = [self.dataSource objectAtIndex:section];
    if (group.header == nil) {
        return 15;
    }
    CGRect rect = [group.header boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.tableView.frame), MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont ms_smallFont]}
                                             context:nil];
    return rect.size.height + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    MSCellGroup *group = [self.dataSource objectAtIndex:section];
    if (group.footer == nil) {
        return CGFLOAT_MIN;
    }
    CGRect rect = [group.footer boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.tableView.frame), MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont ms_smallFont]}
                                             context:nil];
    return rect.size.height + 10;
}

#pragma mark - MSGeneralTableViewCellDelegate

- (void)generalTableViewCell:(MSGeneralTableViewCell *)cell didTapSwitch:(UISwitch *)switchView {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MSCellGroup *group = [self.dataSource objectAtIndex:indexPath.section];
    MSCellItem *item = [group.items objectAtIndex:indexPath.row];
    if (item.didClickHandler) {
        item.didClickHandler();
    }
}

#pragma mark - Getter

- (NSArray<MSCellGroup *> *)dataSource {
    return nil;
}

@end
