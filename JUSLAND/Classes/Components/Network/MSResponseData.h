//
//  MSResponseData.h
//  MIS
//
//  Created by LIUZHEN on 2017/3/7.
//  Copyright © 2017年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  列表数据通用模板
 */
@interface MSResponseData : NSObject

/**
 *  扩展数据
 */
@property (nonatomic, strong) id extData;

/**
 *  列表总数
 */
@property (nonatomic, strong) NSNumber *total;

/**
 *  列表数据
 */
@property (nonatomic, strong) NSArray *list;

@end
