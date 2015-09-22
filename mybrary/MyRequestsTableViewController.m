//
//  MyRequestsTableViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/21/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "MyRequestsTableViewController.h"
#import "MyRequestsTableViewCell.h"
#import "MBApiClient.h"

@interface MyRequestsTableViewController ()

@property (atomic, weak) NSMutableArray *bookRequests;

@end

@implementation MyRequestsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MBApiClient sharedClient] getMyRequestsWithScucessBlock:^(id responseObject) {
        self.bookRequests = responseObject[@"requests"];
        [self.tableView reloadData];
    } errorBlock:^(NSError *error) {
        NSLog(@"There was an error in getting requests");
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bookRequests count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRequestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myRequestCell" forIndexPath:indexPath];
    
    NSDictionary *bookRequest = [self.bookRequests objectAtIndex:indexPath.row];
    
    cell.bookRequestId = bookRequest[@"id"];
    cell.bookNameLabel.text = bookRequest[@"book_instance"][@"book"][@"name"];
    cell.userLabel.text = bookRequest[@"book_instance"][@"user"][@"name"];
    cell.statusLabel.text = @"Pending";
    
    [self setCellBackgroundWitchCell:cell indexPath:indexPath];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
