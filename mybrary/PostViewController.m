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
#import "MRProgress.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UIView *scannerView;
@property (strong, nonatomic) MTBBarcodeScanner *scanner;
@property (nonatomic, strong) NSMutableDictionary *overlayViews;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scan";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            [self startScanning];
            
        } else {
            // The user denied access to the camera
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.scanner stopScanning];
    [super viewWillDisappear:animated];
}

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:_scannerView];
    }
    return _scanner;
}

- (void)startScanning {
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        [self drawOverlaysOnCodes:codes];
        AVMetadataMachineReadableCodeObject *code = [codes firstObject];
        NSLog(@"Found code: %@", code.stringValue);
        
        [self.scanner stopScanning];
        [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
        [[MBApiClient sharedClient] getBookByIsbn:code.stringValue
                                     successBlock:^(id responseObject) {
                                         [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                         [self handleKnownBarcode:responseObject];
                                     } errorBlock:^(NSError *error) {
                                         [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                         [self handleUnKnownBarcode:code.stringValue];
                                     }];
    }];
    
}

- (void)drawOverlaysOnCodes:(NSArray *)codes {
    // Get all of the captured code strings
    NSMutableArray *codeStrings = [[NSMutableArray alloc] init];
    for (AVMetadataMachineReadableCodeObject *code in codes) {
        if (code.stringValue) {
            [codeStrings addObject:code.stringValue];
        }
    }
    
    // Remove any code overlays no longer on the screen
    for (NSString *code in self.overlayViews.allKeys) {
        if ([codeStrings indexOfObject:code] == NSNotFound) {
            // A code that was on the screen is no longer
            // in the list of captured codes, remove its overlay
            [self.overlayViews[code] removeFromSuperview];
            [self.overlayViews removeObjectForKey:code];
        }
    }
    
    for (AVMetadataMachineReadableCodeObject *code in codes) {
        UIView *view = nil;
        NSString *codeString = code.stringValue;
        
        if (codeString) {
            if (self.overlayViews[codeString]) {
                // The overlay is already on the screen
                view = self.overlayViews[codeString];
                
                // Move it to the new location
                view.frame = code.bounds;
                
            } else {
                // First time seeing this code
                BOOL isValidCode = [self isValidCodeString:codeString];
                
                // Create an overlay
                UIView *overlayView = [self overlayForCodeString:codeString
                                                          bounds:code.bounds
                                                           valid:isValidCode];
                self.overlayViews[codeString] = overlayView;
                
                // Add the overlay to the preview view
                [self.scannerView addSubview:overlayView];
                
            }
        }
    }
}

- (BOOL)isValidCodeString:(NSString *)codeString {
    return YES;
}

- (UIView *)overlayForCodeString:(NSString *)codeString bounds:(CGRect)bounds valid:(BOOL)valid {
    UIColor *viewColor = valid ? [UIColor greenColor] : [UIColor redColor];
    UIView *view = [[UIView alloc] initWithFrame:bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    
    // Configure the view
    view.layer.borderWidth = 5.0;
    view.backgroundColor = [viewColor colorWithAlphaComponent:0.75];
    view.layer.borderColor = viewColor.CGColor;
    
    // Configure the label
    label.font = [UIFont boldSystemFontOfSize:12];
    label.text = codeString;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    
    // Add constraints to label to improve text size?
    
    // Add the label to the view
    [view addSubview:label];
    
    return view;
}

- (NSMutableDictionary *)overlayViews {
    if (!_overlayViews) {
        _overlayViews = [[NSMutableDictionary alloc] init];
    }
    return _overlayViews;
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
