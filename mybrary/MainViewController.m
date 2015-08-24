//
//  ViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/24/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "MainViewController.h"
#import "MBApiClient.h"


@interface MainViewController()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
    CLLocation *location = self.locationManager.location;
    if (location) {
        [self getBooksWithLocation:location];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    
    [self getBooksWithLocation:crnLoc];
    
}

- (void)getBooksWithLocation:(CLLocation *)location
{
    [[MBApiClient sharedClient]getBookInstancesByLocation:location
                                             successBlock:^(id responseObject) {
                                                 NSLog(@"received response %@", responseObject);
                                             } errorBlock:^(NSError *error) {
                                                 NSLog(@"error baba");
                                                 
                                             }];
}

@end
