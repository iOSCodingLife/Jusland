//
//  PinyinConverter.h
//  Pinyin
//
//  Created by Z on 14/06/21.
//  Copyright (c) 2014 Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinyinConverter : NSObject

+ (PinyinConverter *)sharedInstance;

- (NSString *)toPinyin:(NSString *)source;

@end
