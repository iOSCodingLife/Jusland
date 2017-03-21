//
//  MSCellGroup.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/16.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSCellItem.h"

@interface MSCellGroup : NSObject

/**
 *  Cell header显示的内容
 */
@property (nonatomic, copy) NSString *header;

/**
 *  Cell footer显示的内容
 */
@property (nonatomic, copy) NSString *footer;

/**
 *  一组Cell
 */
@property (nonatomic, strong) NSArray <MSCellItem *> *items;

@end
