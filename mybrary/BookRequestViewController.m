//
//  BookRequestViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/18/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "BookRequestViewController.h"
#import "MBApiClient.h"

@interface BookRequestViewController ()

@end

@implementation BookRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[MBApiClient sharedClient] getBookInstanceById:self.bookInstanceId
                                       successBlock:^(id responseObject) {
                                           [self populateBookInstanceWithResponse:responseObject];
                                       } errorBlock:^(NSError *error) {
                                           NSLog(@"There was an error in getting response");
                                       }];
}

- (void)populateBookInstanceWithResponse: (id) responseObject
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)requestButtonPressed:(id)sender {
    [[MBApiClient sharedClient] createBookRequestWithBookInstanceId:self.bookInstanceId
                                                               type:@1
                                                    successBlock:^(id responseObject) {
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    } errorBlock:^(NSError *error) {
                                                        NSLog(@"There was an issue!");
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
