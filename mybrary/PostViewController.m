//
//  PostViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 8/25/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import "PostViewController.h"
#import "MTBBarcodeScanner.h"
#import "MBApiClient.h"
#import "NewBookViewController.h"
#import "NewBookInstanceViewController.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UIView *scannerView;
@property (strong, nonatomic) MTBBarcodeScanner *scanner;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scan";
    // Do any additional setup after loading the view.
    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.scannerView];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found code: %@", code.stringValue);
                
                [self.scanner stopScanning];
                [[MBApiClient sharedClient] getBookByIsbn:code.stringValue
                                             successBlock:^(id responseObject) {
                                                 [self handleKnownBarcode:responseObject];
                                             } errorBlock:^(NSError *error) {
                                                 [self handleUnKnownBarcode:code.stringValue];
                                             }];
            }];
            
        } else {
            // The user denied access to the camera
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleKnownBarcode:(id )response
{
    [self performSegueWithIdentifier:@"NewBookInstance" sender:response];
}

- (void)handleUnKnownBarcode:(NSString *)barcode
{
    // we didn't recognize this barcode,
    // show modal to fill info and submit
    [self performSegueWithIdentifier:@"NewBook" sender:barcode];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewBook"] && [segue.destinationViewController isKindOfClass:[NewBookViewController class]]) {
        NewBookViewController *nbvc = segue.destinationViewController;
        nbvc.isbn = sender;
    }
    else if ([segue.identifier isEqualToString:@"NewBookInstance"] && [segue.destinationViewController isKindOfClass:[NewBookInstanceViewController class]]) {
        NewBookInstanceViewController *nbivc = segue.destinationViewController;
        nbivc.isbn = sender[@"isbn"];
        nbivc.bookName = sender[@"name"];
    }
}

@end
