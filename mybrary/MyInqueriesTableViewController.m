//
//  MyRequestsTableViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/18/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "MyInqueriesTableViewController.h"
#import "MBApiClient.h"
#import "BookRequestTableViewCell.h"
#import "MRProgress.h"

@interface MyInqueriesTableViewController ()

@property (atomic, weak) NSMutableArray *bookRequests;

@end

@implementation MyInqueriesTableViewController


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
    
    [[MBApiClient sharedClient] getMyInqueriesWithScucessBlock:^(id responseObject) {
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
    BookRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInqueryCell" forIndexPath:indexPath];
    
    NSDictionary *bookRequest = [self.bookRequests objectAtIndex:indexPath.row];
    
    
    cell.leftUtilityButtons = [self leftButtons];
    //cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    cell.bookRequestId = bookRequest[@"id"];
    cell.bookNameLabel.text = bookRequest[@"book_instance"][@"book"][@"name"];
    cell.userLabel.text = bookRequest[@"user"][@"name"];
    [self setCellBackgroundWitchCell:cell indexPath:indexPath];
    
    return cell;
}


- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"reject.png"]];
    
    return leftUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(BookRequestTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            // accepted
            [self acceptBookRequestWithCell:cell];
            break;
        case 1:
            // rejected
            [self rejectBookRequestWithCell:cell];
            break;
        default:
            break;
    }
}

- (void)rejectBookRequestWithCell: (BookRequestTableViewCell *)cell
{
    UIAlertController *optionsController = [UIAlertController alertControllerWithTitle:@"Confirm?" message:@"Are you sure you want to reject this request?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
        [[MBApiClient sharedClient] updateBookRequestWithBookInstanceId:cell.bookRequestId
                                                                   type:nil
                                                                 status:@-1
                                                           successBlock:^(id responseObject) {
                                                               [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                               cell.alpha = .5;
                                                           } errorBlock:^(NSError *error) {
                                                               [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                               NSLog(@"Error!!");
                                                           }];

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [optionsController addAction:rejectAction];
    [optionsController addAction:cancel];
    
    [self presentViewController:optionsController animated:YES completion:nil];
    
}


- (void)acceptBookRequestWithCell: (BookRequestTableViewCell *)cell
{
    UIAlertController *optionsController = [UIAlertController alertControllerWithTitle:@"Confirm?" message:@"Please confirm that you want to accept this request. Once you accept we will contact both side so you can manage the process." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Lets do this!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [MRProgressOverlayView showOverlayAddedTo:self.view.window animated:YES];
        [[MBApiClient sharedClient] updateBookRequestWithBookInstanceId:cell.bookRequestId
                                                                   type:nil
                                                                 status:@2
                                                           successBlock:^(id responseObject) {
                                                               [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                               cell.alpha = .5;
                                                           } errorBlock:^(NSError *error) {
                                                               [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
                                                               NSLog(@"Error!!");
                                                           }];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [optionsController addAction:acceptAction];
    [optionsController addAction:cancel];
    
    [self presentViewController:optionsController animated:YES completion:nil];

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
