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
#import "MRProgress.h"
#import "INTULocationManager.h"
#import "BookRequestViewController.h"
#import "UIColor+MBColors.h"


@interface MainViewController()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, atomic) NSArray *annotaions;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MyBrary";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonPressed:)];
    self.mapView.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupLocationManager];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)setupLocationManager {
    [[INTULocationManager sharedInstance] requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
                                                                     timeout:10
                                                        delayUntilAuthorized:YES
                                                                       block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                                           [self getBooksWithLocation:currentLocation query:[self getSearchString]];
                                                                       }];
//    [[INTULocationManager sharedInstance] subscribeToSignificantLocationChangesWithBlock:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
//        if (status == INTULocationStatusSuccess) {
//            [self getBooksWithLocation:currentLocation query:[self getSearchString]];
//            
//        }
//        else {
//            // An error occurred, more info is available by looking at the specific status returned. The subscription has been automatically canceled.
//        }
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreButtonPressed:(id)sender {
    UIAlertController *optionsController = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *myInqueries = [UIAlertAction actionWithTitle:@"My Inqueries" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSegueWithIdentifier:@"myInqueries" sender:self];
    }];
    
    UIAlertAction *myRequests = [UIAlertAction actionWithTitle:@"My Requests" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSegueWithIdentifier:@"myRequests" sender:self];
    }];
    
    UIAlertAction *myBooks = [UIAlertAction actionWithTitle:@"My Books" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self performSegueWithIdentifier:@"myBooks" sender:self];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [optionsController addAction:myInqueries];
    [optionsController addAction:myRequests];
    [optionsController addAction:myBooks];
    [optionsController addAction:cancel];
    
    [self presentViewController:optionsController animated:YES completion:nil];
}

- (IBAction)searchButtonPressed:(id)sender {
    [self resignFirstResponder];
    [self getBooksWithLocation:[[LocationManager sharedClient] location] query:[self getSearchString]];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    [self getBooksWithLocation:crnLoc query:[self getSearchString]];
    
}

- (NSString *)getSearchString
{
    if ([self.searchTextField.text length] > 3) {
        return self.searchTextField.text;
    }
    else {
        return nil;
    }
        
}

- (void)mapSetRegion:(CLLocation *)center
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    [self.mapView setRegion:MKCoordinateRegionMake(center.coordinate, span)];
}

- (void)getBooksWithLocation:(CLLocation *)location query:(NSString *)queryString
{
    [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
    [self mapSetRegion:location];
    [[MBApiClient sharedClient]getBooksByLocation:location
                                            query:queryString
                                      includeMine:[NSNumber numberWithBool:NO]
                                             successBlock:^(id responseObject) {
                                                 [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                 NSLog(@"received response %@", responseObject);
                                                 [self updateShowAnnotations:responseObject];
                                             } errorBlock:^(NSError *error) {
                                                 [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                 NSLog(@"error baba");
                                                 
                                             }];
}


- (void)updateShowAnnotations:(id) response
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (NSDictionary *bookDict in response[@"books"]) {
        for (NSDictionary *bookInstanceDict in bookDict[@"book_instances"]) {
            MBMapAnnotation *ann = [[MBMapAnnotation alloc] init];
            ann.title = bookDict[@"name"];
            ann.subtitle = bookDict[@"author"][@"name"];
            ann.bookInstanceId = bookInstanceDict[@"id"];
            
            CLLocationCoordinate2D coord = (CLLocationCoordinate2D){[bookInstanceDict[@"lat"] doubleValue], [bookInstanceDict[@"lon"] doubleValue]};
            ann.coordinate = coord;
            
            [self.mapView addAnnotation:ann];
            
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MBMapAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.image = [UIImage imageNamed:@"mapPin.png"];
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[MBMapAnnotation class]]) {
        NSNumber *bookInstanceId = ((MBMapAnnotation *)view.annotation).bookInstanceId;
        [self performSegueWithIdentifier:@"bookRequest" sender:bookInstanceId];
    }
}


- (void)postButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"showScanner" sender:self];
}
     
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showScanner"] && [segue.destinationViewController isKindOfClass:[PostViewController class]]) {
        NSLog(@"Goto scanner");
    } else if ([segue.identifier isEqualToString:@"bookRequest"]) {
        BookRequestViewController *brvc = segue.destinationViewController;
        brvc.bookInstanceId = sender;
    }
}

@end
