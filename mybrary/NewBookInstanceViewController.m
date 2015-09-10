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

@interface NewBookInstanceViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *giveOptions;
@property (strong, atomic) NSArray *givePossibleOptions;
@end

@implementation NewBookInstanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.giveOptions.delegate = self;
    self.giveOptions.dataSource = self;
    self.bookNameLabel.text = self.bookName;
    self.givePossibleOptions = @[@"Free", @"Rent", @"Sell"];
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
