//
//  NewBookViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/25/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "NewBookViewController.h"
#import "MBApiClient.h"
#import "NewBookInstanceViewController.h"

@interface NewBookViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bookNameTextField;

@end

@implementation NewBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewBookInstance"]) {
        NewBookInstanceViewController *nbivc = segue.destinationViewController;
        nbivc.isbn = self.isbn;
        nbivc.bookName = self.bookNameTextField.text;
    }
    
}


- (IBAction)createBookPressed:(id)sender {
    [[MBApiClient sharedClient] createBookWithIsbn:self.isbn
                                              name:self.bookNameTextField.text
                                      successBlock:^(id responseObject) {
                                          // book submitted succesfuly go to next page
                                          NSLog(@"book submitted");
                                          [self performSegueWithIdentifier:@"NewBookInstance" sender:self];
                                      }
                                        errorBlock:^(NSError *error) {
                                            // there was an issue in submitting the book
                                            NSLog(@"There was an issue submitting the book");
                                        }];
}

@end
