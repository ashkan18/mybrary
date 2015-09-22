//
//  SignUpViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/1/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "SignUpViewController.h"
#import "MBApiClient.h"
#import "MRProgress.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property (weak, nonatomic) IBOutlet UISwitch *bookStoreSwitch;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
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
    self.messageLabel.text = @"";
    self.messageLabel.hidden = YES;
    
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        // password and confirmation don't match
        self.messageLabel.text = @"Passwords didn't match, try again.";
        self.messageLabel.hidden = NO;
        return ;
    }
    [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
    [[MBApiClient sharedClient] registerUserWithName:self.nameField.text
                                            userName:self.usernameField.text
                                            password:self.passwordField.text
                                         accountType:self.bookStoreSwitch.on ? @2 : @1
                                        successBlock:^(id responseObject) {
                                            [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } errorBlock:^(NSError *error) {
                                            [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                            self.messageLabel.text = @"There was an issue in signing up. Please try again.";
                                            self.messageLabel.hidden = NO;
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
