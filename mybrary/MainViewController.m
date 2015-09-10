//
//  ViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/24/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "MainViewController.h"
#import "MBApiClient.h"
#import <MapKit/MKAnnotation.h>
#import "MBMapAnnotation.h"
#import "PostViewController.h"
#import "LocationManager.h"


@interface MainViewController()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MyBrary";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonPressed:)];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self setupLocationManager];
}

- (void)setupLocationManager {
    
    [LocationManager sharedClient].delegate = self;
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    [self mapSetRegion:crnLoc];
    [self getBooksWithLocation:crnLoc];
    
}

- (void)mapSetRegion:(CLLocation *)center
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    [self.mapView setRegion:MKCoordinateRegionMake(center.coordinate, span)];
}

- (void)getBooksWithLocation:(CLLocation *)location
{
    [[MBApiClient sharedClient]getBooksByLocation:location
                                             successBlock:^(id responseObject) {
                                                 NSLog(@"received response %@", responseObject);
                                                 [self updateShowAnnotations:responseObject];
                                             } errorBlock:^(NSError *error) {
                                                 NSLog(@"error baba");
                                                 
                                             }];
}


- (void)updateShowAnnotations:(id) response
{
    for (NSDictionary *bookDict in response[@"books"]) {
        for (NSDictionary *bookInstanceDict in bookDict[@"book_instances"]) {
            MBMapAnnotation *ann = [[MBMapAnnotation alloc] init];
            ann.title = bookDict[@"name"];
            ann.subtitle = bookDict[@"isbn"];
            CLLocationCoordinate2D coord = (CLLocationCoordinate2D){[bookInstanceDict[@"lat"] doubleValue], [bookInstanceDict[@"lon"] doubleValue]};
            ann.coordinate = coord;
            [self.mapView addAnnotation:ann];
        }
    }
}

- (void)postButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showScanner" sender:self];
}
     
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showScanner"] && [segue.destinationViewController isKindOfClass:[PostViewController class]]) {
        NSLog(@"Goto scanner");
    }
}

@end
