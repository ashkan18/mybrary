//
//  MBApiClient.h
//  mybrary
//
//  Created by Ashkan Nasseri on 8/24/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <CoreLocation/CoreLocation.h>

@interface MBApiClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (void)getBookInstancesByLocation: (CLLocation *)location
                      successBlock:(void(^)(id responseObject))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock;

- (void)getBookByIsbn:(NSString *)isbn
         successBlock:(void(^)(id responseObject))successBlock
           errorBlock:(void(^)(NSError *error))errorBlock;

@end
