//
//  MSPickerView.m
//  MIS
//
//  Created by LIUZHEN on 2017/3/6.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSPickerView.h"

@implementation MSPickerItem

+ (instancetype)itemWithTitle:(NSString *)title value:(NSString *)value {
    MSPickerItem *item = [[MSPickerItem alloc] init];
    item.title = title;
    item.value = value;
    return item;
}

@end

@interface MSPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, weak) UIPickerView *pickerView;

@end

@implementation MSPickerView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithHexString:@"#000000" colorAlpha:0.5f];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [backgroundView addGestureRecognizer:tap];
    self.backgroundView = backgroundView;
    
    UIView *containerView = [[UIView alloc] init];
    self.containerView = containerView;
    
    UIView *toolBar = [self createToolBar];
    self.toolBar = toolBar;
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:0 inComponent:0 animated:NO];
    self.pickerView = pickerView;
    
    [containerView addSubview:toolBar];
    [containerView addSubview:pickerView];
    [self addSubview:backgroundView];
    [self addSubview:containerView];
}

- (UIView *)createToolBar {
    UIView *toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = [UIColor whiteColor];
    toolBar.layer.borderColor = [UIColor ms_separatorColor].CGColor;
    toolBar.layer.borderWidth = 0.5f;
    
    UIButton *completedButton = [[UIButton alloc] init];
    [completedButton setTitle:@"完成" forState:UIControlStateNormal];
    [completedButton setTitleColor:[UIColor ms_blackColor] forState:UIControlStateNormal];
    completedButton.titleLabel.font = [UIFont ms_normalFont];
    [completedButton addTarget:self action:@selector(didTapCompleted:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:completedButton];
    [completedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolBar);
        make.right.equalTo(@(-15));
    }];
    return toolBar;
}

#pragma mark - Layout

- (void)setupConstraints {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).with.offset(-270);
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.left.and.right.equalTo(self.containerView);
        make.height.equalTo(@45);
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar.mas_bottom);
        make.left.and.right.equalTo(self.containerView);
        make.height.equalTo(self.containerView);
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerItems.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    MSPickerItem *item = [self.pickerItems objectAtIndex:row];
    return item.title;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    MSPickerItem *item = [self.pickerItems objectAtIndex:row];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    label.text = item.title;
    label.font = [UIFont ms_normalFont];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - Action Handler

- (void)didTapCompleted:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectCompleteAtItem:)]) {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        MSPickerItem *item = [self.pickerItems objectAtIndex:index];
        [self.delegate pickerView:self didSelectCompleteAtItem:item];
    }
    [self hide];
}

#pragma mark - Show & Hide

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.frame = window.bounds;
    [self setNeedsLayout];
    [self slideInFromBottom];
}

- (void)showWithTitles:(NSArray <NSString *> *)titles {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSString *title in titles) {
        MSPickerItem *item = [MSPickerItem itemWithTitle:title value:title];
        [items addObject:item];
    }
    self.pickerItems = items;
    [self show];
}

- (void)hide {
    [self slideOutToBottom];
}

- (void)slideInFromBottom {
    self.alpha = 0.0f;
    self.containerView.ms_top = self.ms_height;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.containerView.ms_top = self.ms_height - 270;
                         self.alpha = 1.0f;
                         self.backgroundView.alpha = 1.0f;
                     }
                     completion:nil];
}

- (void)slideOutToBottom {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.containerView.ms_top = self.ms_height;
                         self.backgroundView.alpha = 0.0f;
                     }
                     completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.3f
                                          animations:^{
                                              self.alpha = 0.0f;
                                              [self removeFromSuperview];
                                          }
                                          completion:nil];
                     }];
}

@end
