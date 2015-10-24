//
//  LoginViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/31/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "LoginViewController.h"
#import "MBApiClient.h"
#import "MRProgress.h"
#import "AppDelegate.h"

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
    [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
    [[MBApiClient sharedClient] loginWithUserName:self.userNameField.text
                                         password:self.passwordField.text
                                     successBlock:^(id responseObject) {
                                         [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                         
                                         [self loginWithToken:responseObject[@"access_token"]];
                                         
                                         
                                     } errorBlock:^(NSError *error) {
                                         // show error
                                         [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                     }];
}


- (void)loginWithToken:(NSString *)token
{
    [MBApiClient sharedClient].accessToken = token;
    [[MBApiClient sharedClient].requestSerializer setValue:token forHTTPHeaderField:@"X-Authtoken"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"AccessToken"];
    [defaults synchronize];
    
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
}


- (IBAction)signupPressed:(id)sender {
    [self performSegueWithIdentifier:@"signUp" sender:self];
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
