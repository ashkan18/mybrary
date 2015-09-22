//
//  MBTableViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/22/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "MBTableViewController.h"
#import "UIColor+MBColors.h"

@interface MBTableViewController ()

@end

@implementation MBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor primaryColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCellBackgroundWitchCell:(UITableViewCell *)cell
                         indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor secondrayColor];
    } else {
        cell.backgroundColor = [UIColor thirdColor];
    }
}


@end
