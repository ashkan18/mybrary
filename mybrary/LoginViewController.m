//
//  LoginViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/31/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "LoginViewController.h"
#import "MBApiClient.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginPressed:(id)sender {
    [[MBApiClient sharedClient] loginWithUserName:self.userNameField.text
                                         password:self.passwordField.text
                                     successBlock:^(id responseObject) {
                                         //set access token
                                         [MBApiClient sharedClient].accessToken = responseObject[@"access_token"];
                                         [[MBApiClient sharedClient].requestSerializer setValue:responseObject[@"access_token"] forHTTPHeaderField:@"X-Authtoken"];
                                         //[[MBApiClient sharedClient].requestSerializer setValue:responseObject[@"access_token"] forUndefinedKey:@"X-Authtoken" ];
                                         [self performSegueWithIdentifier:@"mainPage" sender:self];
                                         
                                     } errorBlock:^(NSError *error) {
                                         // show error
                                         NSLog(@"There was an error in login");
                                     }];
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
