//
//  MSSpellingSortHelper.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/24.
//  Copyright © 2016年 58. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  拼音排序组
 */
@interface MSSpellingSortGroup : NSObject

/**
 *  组标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  组数据
 */
@property (nonatomic, strong) NSArray *data;

@end

@interface MSSpellingSortHelper : NSObject

/**
 *  根据指定key，对数据源进行拼音分组排序
 *
 *  list中为模型数据时，必须指定根据模型中的属性key进行拼音分组
 *  list中为字符串时，key值为nil
 *  @param list 待分组数据
 *  @param key  根据模型中的那个属性key进行拼音分组
 *
 *  @return 分组数据
 */
+ (NSArray <MSSpellingSortGroup *> *)spellingSortWithList:(NSArray *)list key:(NSString *)key;

@end
