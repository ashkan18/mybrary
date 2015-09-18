//
//  ViewController.h
//  mybrary
//
//  Created by Ashkan Nasseri on 8/24/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MainViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

