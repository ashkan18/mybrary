//
//  NewBookInstanceViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/25/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "NewBookInstanceViewController.h"
#import "MBApiClient.h"
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface NewBookInstanceViewController ()

@end

@implementation NewBookInstanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submtBookInstance:(id)sender {
    
    CLLocation *location = [[LocationManager sharedClient] location];
    [[MBApiClient sharedClient] createBookInstanceWithIsbn:self.isbn
                                                  location:location
                                              successBlock:^(id responseObject) {
                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                              } errorBlock:^(NSError *error) {
                                                  NSLog(@"There was an issue in submitting booking instance");
                                              }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
