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

@property NSString *accessToken;

- (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
             successBlock:(void(^)(id responseObject))successBlock
               errorBlock:(void(^)(NSError *error))errorBlock;

- (void)registerUserWithName:(NSString *)name
                    userName:(NSString *)userName
                    password:(NSString *)password
                successBlock:(void(^)(id responseObject))successBlock
                  errorBlock:(void(^)(NSError *error))errorBlock;


- (void)getBooksByLocation:(CLLocation *)location
                     query:(NSString *)query
               includeMine:(NSNumber *)includeMine
              successBlock:(void(^)(id responseObject))successBlock
                errorBlock:(void(^)(NSError *error))errorBlock;

- (void)getBookByIsbn:(NSString *)isbn
         successBlock:(void(^)(id responseObject))successBlock
           errorBlock:(void(^)(NSError *error))errorBlock;

- (void)getBookInstanceById:(NSNumber *)bookInstanceId
               successBlock:(void(^)(id responseObject))successBlock
                 errorBlock:(void(^)(NSError *error))errorBlock;

- (void)createBookWithIsbn:(NSString *)isbn
                      name:(NSString *)name
              successBlock:(void(^)(id responseObject))successBlock
                errorBlock:(void(^)(NSError *error))errorBlock;

- (void)createBookInstanceWithIsbn:(NSString *)isbn
                              type:(NSNumber *)giveType
                             price:(NSNumber *)price
                          location:(CLLocation *)location
                      successBlock:(void(^)(id responseObject))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock;

- (void)createBookRequestWithBookInstanceId:(NSNumber *)bookInstanceId
                                       type:(NSNumber *)transactionType
                               successBlock:(void(^)(id responseObject))successBlock
                                 errorBlock:(void(^)(NSError *error))errorBlock;

- (void)getMyRequestsWithScucessBlock:(void(^)(id responseObject))successBlock
                           errorBlock:(void(^)(NSError *error))errorBlock;

- (void)getMyInqueriesWithScucessBlock:(void (^)(id))successBlock
                            errorBlock:(void (^)(NSError *))errorBlock;


- (void)updateBookRequestWithBookInstanceId:(NSNumber *)bookInstanceId
                                       type:(NSNumber *)requestType
                                     status:(NSNumber *)status
                               successBlock:(void(^)(id responseObject))successBlock
                                 errorBlock:(void(^)(NSError *error))errorBlock;



@end
