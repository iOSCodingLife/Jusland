//
//  MSAlertCollectionViewCell.h
//  MIS
//
//  Created by LIUZHEN on 2017/2/19.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSAlertCollectionViewCell : UICollectionViewCell

/** 是否显示垂直分割线 */
@property (nonatomic, assign) BOOL showVerticalSeparator;

/** 类方法，快捷创建一个Cell */
+ (MSAlertCollectionViewCell *)cellWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath;

/** Cell 重用ID */
+ (NSString *)cellIdentifier;

/** 配置Cell 数据 */
- (void)configureCell:(MSAlertAction *)action;

@end
