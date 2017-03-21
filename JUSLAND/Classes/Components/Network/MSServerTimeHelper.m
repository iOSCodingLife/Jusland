//
//  MSServerTimeHelper.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/21.
//  Copyright © 2016年 58. All rights reserved.
//

#import "MSServerTimeHelper.h"

static NSString *kServerTimeKey = @"MSServerTimeKey";
static NSString *kServerTimeOffsetKey = @"MSServerTimeOffsetKey";

@implementation MSServerTimeHelper

+ (void)saveServerTimeInterval:(NSTimeInterval)timeInterval {
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:(timeInterval / 1000.0f)];
    //    NSDate *clientDate = [NSDate date];
    //    NSTimeInterval timeIntervalOffset = [clientDate timeIntervalSinceDate:serverDate];
    NSTimeInterval timeIntervalOffset = [[NSDate date] timeIntervalSinceDate:serverDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:serverDate forKey:kServerTimeKey];
    [defaults setObject:[NSNumber numberWithDouble:timeIntervalOffset] forKey:kServerTimeOffsetKey];
    [defaults synchronize];
}

+ (NSTimeInterval )timeIntervalOffset {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *offset = [defaults objectForKey:kServerTimeOffsetKey];
    if (offset && [offset isKindOfClass:[NSNumber class]]) {
        return offset.doubleValue;
    }
    return 0;
}

+ (NSTimeInterval )serverTimeInterval {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return (interval - [MSServerTimeHelper timeIntervalOffset]) * 1000;
}

@end

