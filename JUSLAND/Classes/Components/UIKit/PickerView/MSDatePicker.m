//
//  MSDatePicker.m
//  MIS
//
//  Created by LIUZHEN on 2017/3/7.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSDatePicker.h"

@interface MSDatePicker ()

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation MSDatePicker

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
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minimumDate = [NSDate date];
    self.datePicker = datePicker;
    
    [containerView addSubview:toolBar];
    [containerView addSubview:datePicker];
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
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolBar.mas_bottom);
        make.left.and.right.equalTo(self.containerView);
        make.height.equalTo(self.containerView);
    }];
}

#pragma mark - Action Handler

- (void)didTapCompleted:(UIButton *)sender {
    if (self.didSelectAtDate) {
        self.didSelectAtDate(self);
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCompleteDatePicker:)]) {
        [self.delegate didSelectCompleteDatePicker:self];
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
