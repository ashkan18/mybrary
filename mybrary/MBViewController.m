//
//  MBViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/22/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "MBViewController.h"
#import "UIColor+MBColors.h"

@interface MBViewController ()

@end

@implementation MBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont    fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor primaryColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor primaryColor];
    
    //self.view.backgroundColor = [UIColor primaryColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
