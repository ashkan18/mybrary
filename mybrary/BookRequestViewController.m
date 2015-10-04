//
//  BookRequestViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/18/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "BookRequestViewController.h"
#import "MBApiClient.h"
#import "MRProgress.h"

@interface BookRequestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation BookRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
    [[MBApiClient sharedClient] getBookInstanceById:self.bookInstanceId
                                       successBlock:^(id responseObject) {
                                           [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                           
                                           [self populateBookInstanceWithResponse:responseObject];
                                       } errorBlock:^(NSError *error) {
                                           [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                           
                                           NSLog(@"There was an error in getting response");
                                       }];
}

- (void)populateBookInstanceWithResponse: (id) responseObject
{
    self.bookNameLabel.text = responseObject[@"book"][@"name"];
    self.userNameLabel.text = responseObject[@"user"][@"name"];
    self.authorLabel.text = responseObject[@"book"][@"author"][@"name"];
    NSURL *url = [NSURL URLWithString:responseObject[@"book"][@"small_cover_url"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.coverImage.image = [UIImage imageWithData:data];
    
    switch ([responseObject[@"offer_type"] integerValue]) {
        case 1:
            self.typeLabel.text = @"Free";
            break;
        case 2:
            self.typeLabel.text = @"Rent";
            break;
        case 3:
            self.typeLabel.text = @"Sell";
            break;
        default:
            self.typeLabel.text = @"";
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)requestButtonPressed:(id)sender {
    [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];

    [[MBApiClient sharedClient] createBookRequestWithBookInstanceId:self.bookInstanceId
                                                               type:@1
                                                    successBlock:^(id responseObject) {
                                                        [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                        
                                                        [self dismissViewControllerAnimated:YES completion:nil];
                                                    } errorBlock:^(NSError *error) {
                                                        [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                        
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
