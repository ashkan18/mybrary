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
        //sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://mybrary.herokuapp.com/"]];
        sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:3000/"]];
        
        //sharedManager.responseSerializer = [MSJsonResponseSerailizerWithData serializer];
    });
    
    return sharedManager;
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password successBlock:(void (^)(id))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSString *path = @"api/auth";
    
    [self POST:path
    parameters:@{@"email": userName, @"password": password}
       success:^(NSURLSessionDataTask *task, id responseObject) {
           successBlock(responseObject);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           errorBlock(error);
       }];
}

- (void)registerUserWithName:(NSString *)name userName:(NSString *)userName password:(NSString *)password successBlock:(void (^)(id))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSString *path = @"api/users";
    
    [self POST:path
    parameters:@{@"name": name,
                 @"email":userName,
                 @"password":password,
                 @"type": @1}
       success:^(NSURLSessionDataTask *task, id responseObject) {
           successBlock(responseObject);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           errorBlock(error);
       }];
}

- (void)getBookByIsbn:(NSString *)isbn
         successBlock:(void(^)(id responseObject))successBlock
           errorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *path = [NSString stringWithFormat:@"api/books/%@" ,isbn];
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          successBlock(responseObject);
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          errorBlock(error);
      }];
}

- (void)getBooksByLocation:(CLLocation *)location
                     query:(NSString *)query
               includeMine:(NSNumber *)includeMine
              successBlock:(void(^)(id responseObject))successBlock
                errorBlock:(void(^)(NSError *error))errorBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"lat": [NSNumber numberWithDouble:location.coordinate.latitude],
                                                                                  @"lon": [NSNumber numberWithDouble:location.coordinate.longitude]}];
    if (query) {
        params[@"query"] = query;
    }
    
    if (includeMine) {
        params[@"include_mine"] = includeMine;
    }
    
    NSString *path = @"api/books";
    [self GET:path
   parameters:params
      success:^(NSURLSessionDataTask *task, id responseObject) {
          successBlock(responseObject);
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          errorBlock(error);
      }];
    
}

- (void)getBookInstanceById:(NSNumber *)bookInstanceId successBlock:(void (^)(id))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSString *path = [NSString stringWithFormat:@"api/book_instances/%@", bookInstanceId];
    [self GET:path
   parameters:nil
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

- (void)createBookInstanceWithIsbn:(NSString *)isbn
                              type:(NSNumber *)giveType
                             price:(NSNumber *)price
                          location:(CLLocation *)location
                      successBlock:(void(^)(id responseObject))successBlock
                        errorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *path = @"api/book_instances";
    NSDictionary *params = @{@"isbn":isbn,
                             @"offer_type":giveType,
                             @"location": @{@"lat": [NSNumber numberWithDouble:location.coordinate.latitude],
                                            @"lon": [NSNumber numberWithDouble:location.coordinate.longitude]}};
    
    [self POST:path
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject)  {
           successBlock(responseObject);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           errorBlock(error);
       }];
    
}


- (void)createBookRequestWithBookInstanceId:(NSNumber *)bookInstanceId
                                       type:(NSNumber *)requestType
                               successBlock:(void(^)(id responseObject))successBlock
                                 errorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *path = @"api/book_requests";
    NSDictionary *params = @{@"book_instance_id":bookInstanceId,
                             @"req_type":requestType};
    
    [self POST:path
    parameters:params
       success:^(NSURLSessionDataTask *task, id responseObject)  {
           successBlock(responseObject);
       } failure:^(NSURLSessionDataTask *task, NSError *error) {
           errorBlock(error);
       }];
}


- (void)getMyRequestsWithScucessBlock:(void (^)(id))successBlock errorBlock:(void (^)(NSError *))errorBlock
{
    NSString *path = @"api/users/me/requests";
    [self GET:path
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          successBlock(responseObject);
          
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          errorBlock(error);
      }];
    
}


@end
