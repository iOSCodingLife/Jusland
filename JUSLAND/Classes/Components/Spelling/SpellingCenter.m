//
//  SpellingCenter.m
//  Pinyin
//
//  Created by Z on 14/6/21.
//  Copyright (c) 2014年 Z. All rights reserved.
//

#import "SpellingCenter.h"
#import "PinyinConverter.h"

#define SPELLING_UNIT_FULLSPELLING          @"f"
#define SPELLING_UNIT_SHORTSPELLING         @"s"
#define SPELLING_CACHE                      @"sc"

#pragma mark - SpellingUnit

@implementation SpellingUnit

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_fullSpelling forKey:SPELLING_UNIT_FULLSPELLING];
    [aCoder encodeObject:_shortSpelling forKey:SPELLING_UNIT_SHORTSPELLING];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.fullSpelling = [aDecoder decodeObjectForKey:SPELLING_UNIT_FULLSPELLING];
        self.shortSpelling= [aDecoder decodeObjectForKey:SPELLING_UNIT_SHORTSPELLING];
    }
    return self;
}

@end

@interface SpellingCenter ()

- (SpellingUnit *)calcSpellingOfString: (NSString *)source;

@end

#pragma mark - SpellingCenter

@implementation SpellingCenter

+ (SpellingCenter *)sharedCenter {
    static SpellingCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SpellingCenter alloc]init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *appDocumentPath= [[NSString alloc] initWithFormat:@"%@/",[paths objectAtIndex:0]];
        _filepath = [appDocumentPath stringByAppendingPathComponent:SPELLING_CACHE];
        _spellingCache = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filepath]) {
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:_filepath];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                _spellingCache = [[NSMutableDictionary alloc]initWithDictionary:dict];
            }
        }
        if (!_spellingCache) {
            _spellingCache = [[NSMutableDictionary alloc]init];
        }
    }
    return self;
}

- (void)saveSpellingCache {
    static const NSInteger kMaxEntriesCount = 5000;
    @synchronized(self) {
        NSInteger count = [_spellingCache count];
        if (count >= kMaxEntriesCount) {
            [_spellingCache removeAllObjects];
        }
        if (_spellingCache) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_spellingCache];
            [data writeToFile:_filepath atomically:YES];
        }
    }
}

- (SpellingUnit *)spellingForString:(NSString *)source {
    if ([source length] == 0) {
        return nil;
    }
    SpellingUnit *spellingUnit = nil;
    @synchronized(self) {
        SpellingUnit *unit = [_spellingCache objectForKey:source];
        if (!unit) {
            unit = [self calcSpellingOfString:source];
            if ([unit.fullSpelling length] && [unit.shortSpelling length]) {
                [_spellingCache setObject:unit forKey:source];
            }
        }
        spellingUnit = unit;
    }
    return spellingUnit;
}

- (NSString *)firstLetter:(NSString *)input {
    SpellingUnit *unit = [self spellingForString:input];
    NSString *spelling = [unit.fullSpelling uppercaseString];
    return [spelling length] ? [spelling substringWithRange:NSMakeRange(0, 1)] : nil;
}

- (SpellingUnit *)calcSpellingOfString:(NSString *)source {
    NSMutableString *fullSpelling = [[NSMutableString alloc]init];
    NSMutableString *shortSpelling= [[NSMutableString alloc]init];
    for (NSInteger i = 0; i < [source length]; i++) {
        NSString *word = [source substringWithRange:NSMakeRange(i, 1)];
        NSString *pinyin = [[PinyinConverter sharedInstance] toPinyin:word];
        
        if ([pinyin length]) {
            [fullSpelling appendString:pinyin];
            [shortSpelling appendString:[pinyin substringToIndex:1]];
        }
    }
    
    SpellingUnit *unit = [[SpellingUnit alloc]init];
    unit.fullSpelling = [fullSpelling lowercaseString];
    unit.shortSpelling= [shortSpelling uppercaseString];
    return unit;
}

@end
