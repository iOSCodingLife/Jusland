//
//  JLServiceViewController.m
//  JUSLAND
//
//  Created by Nie on 2017/3/21.
//  Copyright © 2017年 Nie. All rights reserved.
//

#import "JLServiceViewController.h"

@interface JLServiceViewController ()

@end

@implementation JLServiceViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavbar];
    [self setupSubviews];
    [self fetchData];
}

#pragma mark - Setup navbar

- (void)setupNavbar {
    self.title = @"服务";
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor ms_backgroundColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"这是服务界面";
    label.textColor = [UIColor ms_blackColor];
    label.font = [UIFont systemFontOfSize:25];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor randomColor];
    
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.and.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
}

#pragma mark - Layout

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
}

#pragma mark - Fetch data

- (void)fetchData {
    
}

#pragma mark - Event Handler

#pragma mark - Getter

@end
