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
#import "MRProgress.h"


@interface NewBookInstanceViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *offerTypeButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceAmountText;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;


@property (weak, nonatomic) IBOutlet UIPickerView *giveOptions;
@property (strong, atomic) NSArray *givePossibleOptions;
@property (strong, atomic) NSNumber *selectedOption;

@end

@implementation NewBookInstanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.giveOptions.delegate = self;
    self.giveOptions.dataSource = self;
    
    self.bookNameLabel.text = self.bookData[@"name"];
    
    NSURL *url = [NSURL URLWithString:self.bookData[@"small_cover_url"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.coverImage.image = [UIImage imageWithData:data];
    
    self.authorLabel.text = self.bookData[@"author"][@"name"];
    
    self.givePossibleOptions = @[@"Free", @"Rent", @"Sell"];
    self.selectedOption = @1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)offerTypePressed:(id)sender {
    [self.priceAmountText resignFirstResponder];
    self.giveOptions.hidden = false;
    [self.giveOptions becomeFirstResponder];
}

- (IBAction)submtBookInstance:(id)sender {
    
    CLLocation *location = [[LocationManager sharedClient] location];
    [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
    [[MBApiClient sharedClient] createBookInstanceWithIsbn:self.isbn
                                                      type:self.selectedOption
                                                     price:nil
                                                  location:location
                                              successBlock:^(id responseObject) {
                                                  [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                              } errorBlock:^(NSError *error) {
                                                  [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                  NSLog(@"There was an issue in submitting booking instance");
                                              }];
}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.givePossibleOptions.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.givePossibleOptions[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    self.selectedOption = [NSNumber numberWithInteger:row + 1];
    self.offerTypeButton.titleLabel.text = self.givePossibleOptions[row];
    if (row == 2) {
        // it's sell
        self.priceLabel.hidden = NO;
        self.priceAmountText.hidden = NO;
    } else {
        self.priceLabel.hidden = YES;
        self.priceAmountText.hidden = YES;
    }
    self.giveOptions.hidden = YES;
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
