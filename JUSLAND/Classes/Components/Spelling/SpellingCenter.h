//
//  SpellingCenter.h
//  Pinyin
//
//  Created by Z on 14/6/21.
//  Copyright (c) 2014年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpellingUnit : NSObject<NSCoding>

@property (nonatomic, strong) NSString *fullSpelling;   // 全拼（小写）
@property (nonatomic, strong) NSString *shortSpelling;  // 拼音首字母（大写）

@end

@interface SpellingCenter : NSObject

@property (nonatomic, strong) NSMutableDictionary *spellingCache; // 全拼，简称cache
@property (nonatomic, strong) NSString *filepath;

+ (SpellingCenter *)sharedCenter;

- (NSString *)firstLetter:(NSString *)input;               // 首字母（大写）
- (SpellingUnit *)spellingForString:(NSString *)source;    // 全拼，简拼 (小写)
- (void)saveSpellingCache; // 写入缓存

@end
