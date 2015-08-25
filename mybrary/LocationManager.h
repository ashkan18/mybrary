//
//  LocationManager.h
//  mybrary
//
//  Created by Ashkan Nasseri on 8/25/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LocationManager : CLLocationManager<CLLocationManagerDelegate>

+ (instancetype)sharedClient;

@end
