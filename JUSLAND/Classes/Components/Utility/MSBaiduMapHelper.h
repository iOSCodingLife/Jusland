//
//  MSBaiduMapHelper.h
//  MIS
//
//  Created by Nie on 2017/3/14.
//  Copyright © 2017年 58. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduSDK.h"

@interface MSBaiduMapHelper : NSObject

/**
 *  根据经纬度 设置百度地图显示范围
 *
 *  @param centerLocation      中心点
 *  @param latData     纬度数组
 *  @param lonData     经度数组
 */
+ (void)configBaiduMapAnchorRange:(CLLocationCoordinate2D)centerLocation withLatData:(NSMutableArray*)latData withLonData:(NSMutableArray*)lonData withBaiMap:(BMKMapView*)mapView;
@end
