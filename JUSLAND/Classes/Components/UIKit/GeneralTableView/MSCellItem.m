//
//  MSCellItem.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/16.
//  Copyright © 2016年 58. All rights reserved.
//

#import "MSCellItem.h"

@implementation MSCellItem

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithType:MSCellItemTypeNone image:nil title:title subtitle:nil];
}

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title {
    return [self itemWithType:MSCellItemTypeNone image:image title:title subtitle:nil];
}

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    return [self itemWithType:MSCellItemTypeNone image:image title:title subtitle:subtitle];
}

+ (instancetype)itemWithType:(MSCellItemType)type image:(UIImage *)image title:(NSString *)title {
    return [self itemWithType:type image:image title:title subtitle:nil];
}

+ (instancetype)itemWithType:(MSCellItemType)type image:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    MSCellItem *item = [[MSCellItem alloc] init];
    item.type = type;
    item.image = image;
    item.title = title;
    item.subtitle = subtitle;
    return item;
}

@end
