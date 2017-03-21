//
//  MSAlertViewController.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/19.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSAlertController.h"
#import "MSAlertCollectionViewCell.h"

static NSString *const kMSAlertCollectionViewCellHeader = @"MSAlertCollectionViewCellHeader";
static CGFloat actionSetionHeaderHeight = 5.0f;

@interface MSAlertAction ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) MSAlertActionStyle style;
@property (nonatomic, copy) MSAlertActionBlock handler;

@end

@implementation MSAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                          value:(NSString *)value {
    return [MSAlertAction actionWithTitle:title value:value style:MSAlertActionStyleDefault handler:nil];
}

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(MSAlertActionStyle)style
                        handler:(MSAlertActionBlock)handler {
    return [MSAlertAction actionWithTitle:title value:nil style:style handler:handler];
}

+ (instancetype)actionWithTitle:(NSString *)title value:(NSString *)value
                          style:(MSAlertActionStyle)style
                        handler:(MSAlertActionBlock)handler {
    MSAlertAction *action = [[MSAlertAction alloc] init];
    action.title = title;
    action.value = value;
    action.style = style;
    action.handler = handler;
    return action;
}

@end

@interface MSAlertController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, assign) MSAlertControllerStyle style;

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *messageView;
@property (nonatomic, weak) UICollectionView *actionCollectionView;

@property (nonatomic, assign) CGFloat actionHeight;
@property (nonatomic, strong) NSMutableArray<MSAlertAction *> *actions;
@property (nonatomic, strong) NSMutableArray<MSAlertAction *> *cancelAction;

@end

@implementation MSAlertController

#pragma mark - Class Methods

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithTitle:title message:message preferredStyle:MSAlertControllerStyleActionSheet];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(MSAlertControllerStyle)preferredStyle {
    MSAlertController *alertController = [[MSAlertController alloc] init];
    alertController.alertTitle = title;
    alertController.alertMessage = message;
    alertController.style = preferredStyle;
    return alertController;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.actionHeight = 50.0f;
    if (self.style == MSAlertControllerStyleAlert) {
        [self.actions addObjectsFromArray:self.cancelAction];
        [self.cancelAction removeAllObjects];
        self.actionHeight = 45.0f;
    }
    [self setupAlertWindow];
    [self setupSubviews];
    [self setupConstraints];
}

#pragma mark - Setup subViews

- (void)setupAlertWindow {
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.windowLevel = UIWindowLevelAlert;
    alertWindow.backgroundColor = [UIColor clearColor];
    alertWindow.rootViewController = self;
    self.alertWindow = alertWindow;
}

- (void)setupSubviews {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithHexString:@"#000000" colorAlpha:0.5f];
    self.backgroundView = backgroundView;
    if (self.style == MSAlertControllerStyleActionSheet) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
        [backgroundView addGestureRecognizer:tap];
    }
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    if (self.style == MSAlertControllerStyleAlert) {
        containerView.layer.cornerRadius = 8.0f;
        containerView.clipsToBounds = YES;
    }
    self.containerView = containerView;
    
    UIView *messageView = [self createMessageView];
    self.messageView = messageView;
    [containerView addSubview:messageView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *actionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    actionCollectionView.backgroundColor = [UIColor whiteColor];
    actionCollectionView.dataSource = self;
    actionCollectionView.delegate = self;
    [actionCollectionView registerClass:[MSAlertCollectionViewCell class]
             forCellWithReuseIdentifier:[MSAlertCollectionViewCell cellIdentifier]];
    [actionCollectionView registerClass:[UICollectionReusableView class]
             forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                    withReuseIdentifier:kMSAlertCollectionViewCellHeader];
    self.actionCollectionView = actionCollectionView;
    
    [containerView addSubview:actionCollectionView];
    [self.view addSubview:backgroundView];
    [self.view addSubview:containerView];
}

- (UIView *)createMessageView {
    UIView *containerView = [[UIView alloc] init];
    CGFloat margin = self.style == MSAlertControllerStyleAlert ? 15 : 10;
    
    UILabel *titleLabel = nil;
    if ([NSString isNotBlank:self.alertTitle]) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = self.alertTitle;
        titleLabel.numberOfLines = 0;
        if (self.style == MSAlertControllerStyleActionSheet) {
            titleLabel.textColor = [UIColor ms_grayColor];
            titleLabel.font = [UIFont ms_extraSmallBoldFont];
        } else {
            titleLabel.textColor = [UIColor ms_blackColor];
            titleLabel.font = [UIFont ms_normalBoldFont];
        }
        
        [containerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView).with.offset(margin);
            make.left.equalTo(@15);
            make.right.equalTo(@(-15));
        }];
    }
    
    UILabel *messageLabel = nil;
    if ([NSString isNotBlank:self.alertMessage]) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = self.alertMessage;
        messageLabel.numberOfLines = 0;
        if (self.style == MSAlertControllerStyleActionSheet) {
            messageLabel.textColor = [UIColor ms_grayColor];
            messageLabel.font = [UIFont ms_extraSmallFont];
        } else {
            messageLabel.textColor = [UIColor ms_blackColor];
            messageLabel.font = [UIFont ms_smallFont];
        }
        
        [containerView addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(@(-15));
            if (titleLabel) {
                make.top.equalTo(titleLabel.mas_bottom).with.offset(5);
            } else {
                make.top.equalTo(containerView).with.offset(margin);
            }
        }];
    }
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = [UIColor ms_separatorColor];
    separator.tag = 10003;
    
    [containerView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_bottom).with.offset(-0.5f);
        make.left.and.right.equalTo(containerView);
        if (messageLabel) {
            make.bottom.equalTo(messageLabel.mas_bottom).with.offset(margin);
        } else if (titleLabel) {
            make.bottom.equalTo(titleLabel.mas_bottom).with.offset(margin);
        } else {
            make.bottom.equalTo(containerView);
        }
    }];
    return containerView;
}

#pragma mark - Layout

- (void)setupConstraints {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UILabel *separator = [self.messageView viewWithTag:10003];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.left.and.right.equalTo(self.containerView);
        make.bottom.equalTo(separator.mas_bottom);
        if (self.style == MSAlertControllerStyleAlert) {
            make.height.greaterThanOrEqualTo(@(self.actionHeight));
        }
    }];
    
    [self.actionCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageView.mas_bottom);
        make.left.and.right.equalTo(self.containerView);
        CGFloat height = self.actionHeight * (self.actions.count + self.cancelAction.count);
        if (self.style == MSAlertControllerStyleActionSheet) {
            height += self.cancelAction.count > 0 ? actionSetionHeaderHeight : 0;
        } else {
            height = self.actions.count == 2 ? self.actionHeight : height;
        }
        make.height.equalTo(@(height));
        make.height.lessThanOrEqualTo(self.view).multipliedBy(0.7f);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.style == MSAlertControllerStyleActionSheet) {
            make.left.and.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.bottom.equalTo(self.actionCollectionView);
            make.height.lessThanOrEqualTo(self.view).with.offset(-20);
        } else {
            make.top.equalTo(self.messageView);
            make.center.equalTo(self.view);
            make.width.equalTo(self.view).multipliedBy(0.65f);
            make.bottom.equalTo(self.actionCollectionView);
            make.height.lessThanOrEqualTo(self.view).with.offset(-40);
        }
    }];
    [super updateViewConstraints];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.cancelAction.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return self.cancelAction.count;
    } else {
        return self.actions.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSAlertAction *action = nil;
    if (indexPath.section == 1) {
        action = [self.cancelAction objectAtIndex:indexPath.item];
    } else {
        action = [self.actions objectAtIndex:indexPath.item];
    }
    
    MSAlertCollectionViewCell *cell = [MSAlertCollectionViewCell cellWithCollectionView:collectionView IndexPath:indexPath];
    if (self.actions.count == 2 && indexPath.item == 0) {
        cell.showVerticalSeparator = YES;
    } else {
        cell.showVerticalSeparator = NO;
    }
    [cell configureCell:action];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMSAlertCollectionViewCellHeader forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor ms_backgroundColor];
    return headerView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSAlertAction *action = nil;
    if (indexPath.section == 1) {
        action = [self.cancelAction objectAtIndex:indexPath.item];
    } else {
        action = [self.actions objectAtIndex:indexPath.item];
    }
    
    if (![self.cancelAction containsObject:action] && self.preferredActionHandlerBlock) {
        self.preferredActionHandlerBlock(action);
    } else if (action.handler) {
        action.handler(action);
    }
    [self hideView];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.style == MSAlertControllerStyleActionSheet) { // 为Sheet样式，cell宽度为collectionView的宽度
        return CGSizeMake(collectionView.ms_width, self.actionHeight);
    }
    if (self.actions.count == 2) { // 为Alert样式且只有两个Action，cel的宽度为collectionView的宽度的一半
        return CGSizeMake(collectionView.ms_width * 0.5f, self.actionHeight);
    } else { // 为Alert样式且Action不等于两个时，cell宽度为collectionView的宽度
        return CGSizeMake(collectionView.ms_width, self.actionHeight);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(collectionView.ms_width, actionSetionHeaderHeight);
    }
}

#pragma mark - Event Handler

- (void)didTapBackground:(UITapGestureRecognizer *)gesture {
    [self hideView];
}

#pragma mark - Public Methods

- (void)addAction:(MSAlertAction *)action {
    if (action.style == MSAlertActionStyleCancel) {
        if (self.cancelAction.count > 0) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"不能包含两个取消类型的Action" userInfo:nil];
        }
        [self.cancelAction addObject:action];
    } else {
        [self.actions addObject:action];
    }
}

- (void)addActions:(MSAlertAction *)firstObj, ... {
    va_list list;
    va_start(list, firstObj);
    for (id obj = firstObj; obj != nil; obj = va_arg(list, id)) {
        [self addAction:obj];
    }
    va_end(list);
}

- (void)show {
    [self.alertWindow addSubview:self.view];
    [self.alertWindow makeKeyAndVisible];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.actionCollectionView reloadData];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self showView];
}

- (void)showWithActionTitles:(NSArray<NSString *> *)actionTitles {
    if (!actionTitles || actionTitles.count == 0) {
        return;
    }
    
    for (NSString *title in actionTitles) {
        [self addAction:[MSAlertAction actionWithTitle:title style:MSAlertActionStyleDefault handler:nil]];
    }
    [self showCancel:nil handler:nil];
}

- (void)showCancel:(NSString *)cancelTitle handler:(MSAlertActionBlock)handler {
    cancelTitle = [NSString isNotBlank:cancelTitle] ? cancelTitle : @"取消";
    [self addAction:[MSAlertAction actionWithTitle:cancelTitle style:MSAlertActionStyleCancel handler:nil]];
    [self show];
}

- (void)showDialog:(NSString *)cancelTitle actionTitle:(NSString *)actionTitle handler:(MSAlertActionBlock)handler {
    cancelTitle = [NSString isNotBlank:cancelTitle] ? cancelTitle : @"取消";
    if (self.style == MSAlertControllerStyleActionSheet) {
        [self addAction:[MSAlertAction actionWithTitle:actionTitle style:MSAlertActionStyleDefault handler:handler]];
        [self addAction:[MSAlertAction actionWithTitle:cancelTitle style:MSAlertActionStyleCancel handler:nil]];
    } else {
        [self addAction:[MSAlertAction actionWithTitle:cancelTitle style:MSAlertActionStyleDefault handler:nil]];
        [self addAction:[MSAlertAction actionWithTitle:actionTitle style:MSAlertActionStyleDestructive handler:handler]];
    }
    [self show];
}

#pragma mark - Show & Hide Animations

- (void)showView {
    if (self.style == MSAlertControllerStyleActionSheet) {
        [self slideInFromBottom];
    } else {
        [self slideInToCenter];
    }
}

- (void)hideView {
    if (self.style == MSAlertControllerStyleActionSheet) {
        [self slideOutToBottom];
    } else {
        [self slideOutToCenter];
    }
}

- (void)slideInToCenter {
    self.containerView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                           CGAffineTransformMakeScale(0.1f, 0.1f));
    self.view.alpha = 0.0f;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.containerView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                                                CGAffineTransformMakeScale(1.0f, 1.0f));
                         self.view.alpha = 1.0f;
                         self.backgroundView.alpha = 1.0f;
                     }
                     completion:^(BOOL completed) {
                         [UIView animateWithDuration:0.2f
                                          animations:^{
                                              self.containerView.center = self.backgroundView.center;
                                          }
                                          completion:^(BOOL finished) {
                                              if (_showAnimationCompletionBlock) {
                                                  self.showAnimationCompletionBlock();
                                              }
                                          }];
                     }];
}

- (void)slideInFromBottom {
    self.view.alpha = 0.0f;
    self.containerView.ms_top = self.view.ms_height;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.containerView.ms_top = self.view.ms_height - self.containerView.ms_height;
                         self.view.alpha = 1.0f;
                         self.backgroundView.alpha = 1.0f;
                     }
                     completion:^(BOOL completed) {
                         if (_showAnimationCompletionBlock) {
                             self.showAnimationCompletionBlock();
                         }
                     }];
}

- (void)slideOutToCenter {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.containerView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                                                CGAffineTransformMakeScale(0.1f, 0.1f));
                         self.view.alpha = 0.0f;
                         self.backgroundView.alpha = 0.0f;
                     }
                     completion:^(BOOL completed) {
                         [self fadeOut];
                     }];
}

- (void)slideOutToBottom {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.containerView.ms_top = self.view.ms_height;
                         self.backgroundView.alpha = 0.0f;
                     }
                     completion:^(BOOL completed) {
                         [self fadeOut];
                     }];
}

- (void)fadeOut {
    [self fadeOutWithDuration:0.3f];
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                     animations:^{
                         self.view.alpha = 0.0f;
                     }
                     completion:^(BOOL completed) {
                         [self.backgroundView removeFromSuperview];
                         [self.containerView removeFromSuperview];
                         
                         self.alertWindow.hidden = YES;
                         self.alertWindow = nil;
                         if (_dismissAnimationCompletionBlock) {
                             self.dismissAnimationCompletionBlock();
                         }
                     }];
}

#pragma mark - Getter

- (NSMutableArray<MSAlertAction *> *)actions {
    if (_actions == nil) {
        _actions = [[NSMutableArray alloc] init];
    }
    return _actions;
}

- (NSMutableArray<MSAlertAction *> *)cancelAction {
    if (_cancelAction == nil) {
        _cancelAction = [[NSMutableArray alloc] init];
    }
    return _cancelAction;
}

- (NSArray<MSAlertAction *> *)actionItems {
    NSMutableArray *actionItems = [[NSMutableArray alloc] init];
    [actionItems addObjectsFromArray:self.actions];
    [actionItems addObjectsFromArray:self.cancelAction];
    return actionItems;
}

@end
