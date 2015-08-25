//
//  MBApiClient.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/24/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "MBApiClient.h"

@implementation MBApiClient

+ (instancetype)sharedClient
{
    static MBApiClient *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.1.3:3000/"]];
        //sharedManager.responseSerializer = [MSJsonResponseSerailizerWithData serializer];
    });
    
    return sharedManager;
}

- (void)getBookByIsbn:(NSString *)isbn
         successBlock:(void(^)(id responseObject))successBlock
           errorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *path = @"api/books";
    [self GET:path
   parameters:@{@"isbn": isbn} success:^(NSURLSessionDataTask *task, id responseObject) {
       successBlock(responseObject);
       
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       errorBlock(error);
   }];
}

- (void)getBookInstancesByLocation:(CLLocation *)location successBlock:(void (^)(id))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSString *path = @"api/book_instances";
    [self GET:path
   parameters:@{@"lat": [NSNumber numberWithDouble:location.coordinate.latitude],
                @"lon": [NSNumber numberWithDouble:location.coordinate.longitude]}
      success:^(NSURLSessionDataTask *task, id responseObject) {
       successBlock(responseObject);
       
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       errorBlock(error);
   }];

}

- (void)createBookWithIsbn:(NSString *)isbn name:(NSString *)name successBlock:(void (^)(id))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSString *path = @"api/books";
    NSDictionary *params = @{@"isbn":isbn, @"name": name};
    
    [self POST:path
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject)  {
           successBlock(responseObject);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           errorBlock(error);
       }];
}

@end
