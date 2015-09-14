//
//  LocationManager.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/25/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+ (instancetype)sharedClient
{
    static LocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[LocationManager alloc] init];
        sharedManager.distanceFilter = kCLDistanceFilterNone;
        sharedManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([sharedManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [sharedManager requestWhenInUseAuthorization];
        }
        [sharedManager startMonitoringSignificantLocationChanges];
    });
    
    return sharedManager;
}

@end
