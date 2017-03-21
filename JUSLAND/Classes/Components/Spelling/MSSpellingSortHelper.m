//
//  MSSpellingSortHelper.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/24.
//  Copyright © 2016年 58. All rights reserved.
//

#import "MSSpellingSortHelper.h"
#import "SpellingCenter.h"

@implementation MSSpellingSortGroup

@end

@implementation MSSpellingSortHelper

+ (NSArray *)spellingSortWithList:(NSArray *)list key:(NSString *)key {
    // 进行首字母分组
    NSMutableDictionary *groupDataDict = [[NSMutableDictionary alloc] init];
    NSMutableOrderedSet *groupTitleSet = [[NSMutableOrderedSet alloc] init];
    for (id data in list) {
        NSString *value = nil;
        if ([data isKindOfClass:[NSString class]]) {
            value = data;
        } else {
            value = [data valueForKey:key];
        }
        NSString *firstLetter = [[SpellingCenter sharedCenter] firstLetter:value];
        if (firstLetter == nil || [@"0123456789#" containsString:firstLetter]) {
            firstLetter = @"#";
        }
        NSMutableArray *groupData = [groupDataDict objectForKey:firstLetter];
        if(groupData == nil) {
            groupData = [NSMutableArray array];
        }
        [groupTitleSet addObject:firstLetter];
        [groupData addObject:data];
        [groupDataDict setObject:groupData forKey:firstLetter];
    }
    
    // 对字母组进行排序
    [groupTitleSet sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isEqualToString:@"#"]) {
            return NSOrderedDescending;
        }
        if ([obj2 isEqualToString:@"#"]) {
            return NSOrderedAscending;
        }
        return [obj1 compare:obj2];
    }];
    
    // 对组数据进行全拼排序
    [groupDataDict enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull groupTitle, NSArray *_Nonnull list, BOOL *_Nonnull stop) {
        [list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *title1, *title2;
            if ([obj1 isKindOfClass:[NSString class]]) {
                title1 = obj1;
            } else {
                title1 = [obj1 valueForKey:key];
            }
            
            if ([obj2 isKindOfClass:[NSString class]]) {
                title2 = obj2;
            } else {
                title2 = [obj2 valueForKey:key];
            }
            
            NSString *spelling1 = [[SpellingCenter sharedCenter] spellingForString:title1].fullSpelling;
            NSString *spelling2 = [[SpellingCenter sharedCenter] spellingForString:title2].fullSpelling;
            return [spelling1 compare:spelling2];
        }];
    }];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *title in groupTitleSet) {
        MSSpellingSortGroup *group = [[MSSpellingSortGroup alloc] init];
        group.title = title;
        group.data = [groupDataDict objectForKey:title];
        [result addObject:group];
    }
    return result;
}

@end
