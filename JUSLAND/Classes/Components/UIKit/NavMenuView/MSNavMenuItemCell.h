//
//  MSNavMenuItemCell.h
//  MIS
//
//  Created by LIUZHEN on 2017/3/11.
//  Copyright © 2017年 58. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNavMenuItem.h"

@interface MSNavMenuItemCell : UICollectionViewCell

/** 
 *  类方法，快捷创建一个Cell 
 */
+ (MSNavMenuItemCell *)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

/** 
 *  Cell 重用ID 
 */
+ (NSString *)cellIdentifier;

/** 
 *  配置Cell 数据 
 */
- (void)configureCell:(MSNavMenuItem *)item;

@end
