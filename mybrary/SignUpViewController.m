//
//  SignUpViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/1/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "SignUpViewController.h"
#import "MBApiClient.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpPressed:(id)sender {
    [[MBApiClient sharedClient] registerUserWithName:self.nameField.text
                                            userName:self.usernameField.text
                                            password:self.passwordField.text
                                        successBlock:^(id responseObject) {
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } errorBlock:^(NSError *error) {
                                            NSLog(@"Error in signup");
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
