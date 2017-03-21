//
//  MSBaiduMapHelper.m
//  MIS
//
//  Created by Nie on 2017/3/14.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSBaiduMapHelper.h"

@implementation MSBaiduMapHelper

+ (void)configBaiduMapAnchorRange:(CLLocationCoordinate2D)centerLocation withLatData:(NSMutableArray*)latData withLonData:(NSMutableArray*)lonData withBaiMap:(BMKMapView*)mapView {
    
    if (centerLocation.latitude > 0 && [latData count] > 0) {
        NSMutableArray *absoluteLat = [NSMutableArray array];
        NSMutableArray *absolutelon = [NSMutableArray array];
        for (int i = 0; i < [lonData count]; i ++) {
            double tempLat = [[latData objectAtIndex:i] doubleValue];
            double tempLon = [[lonData objectAtIndex:i] doubleValue];
            [absoluteLat addObject:@(fabs(tempLat - centerLocation.latitude))];
            [absolutelon addObject:@(fabs(tempLon - centerLocation.longitude))];
        }
        
        NSNumber * maxLat = [absoluteLat valueForKeyPath:@"@max.self"];
        NSNumber * maxLon = [absolutelon valueForKeyPath:@"@max.self"];
        NSMutableArray *latAndLon = [NSMutableArray array];
        [latAndLon addObject:maxLon];
        [latAndLon addObject:maxLat];
        
        NSNumber *mix = [latAndLon valueForKeyPath:@"@max.self"];
        BMKCoordinateSpan span_p = BMKCoordinateSpanMake(2.3*[mix doubleValue] , 2.3*[mix doubleValue]);
        BMKCoordinateRegion region;
        region.span = span_p;
        region.center = centerLocation;
        [mapView setRegion:region];
    } else {
        NSAssert(NO, @"centerLocation and data can not be nil");
    }
}

@end
