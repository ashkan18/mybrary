//
//  MyBooksTableViewController.m
//  mybrary
//
//  Created by Ashkan Nasseri on 10/3/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "MyBooksTableViewController.h"
#import "MBApiClient.h"
#import "BookTableViewcell.h"

@interface MyBooksTableViewController ()

@property (atomic, weak) NSMutableArray *myBooks;

@end


@implementation MyBooksTableViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[MBApiClient sharedClient] getMyBookInstancesWithScucessBlock:^(id responseObject) {
        self.myBooks = responseObject[@"book_instances"];
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
    return [self.myBooks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myBookCell" forIndexPath:indexPath];
    
    NSDictionary *bookRequest = [self.myBooks objectAtIndex:indexPath.row];
    
    cell.bookInstanceId = bookRequest[@"id"];
    cell.bookNameLabel.text = bookRequest[@"book"][@"name"];
    cell.authorLabel.text = bookRequest[@"book"][@"author"][@"name"];
    
    NSURL *url = [NSURL URLWithString:bookRequest[@"book"][@"small_cover_url"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.coverImage.image = [UIImage imageWithData:data];
    [self setCellBackgroundWitchCell:cell indexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [self confirmDeleteRowAtIndexPath:indexPath];
    }
}

- (void)confirmDeleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to delete this book from your offerings?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    confirmationAlert.popoverPresentationController.sourceView = self.view;
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Yes, remove!" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        BookTableViewCell *bookCell = [self.tableView cellForRowAtIndexPath:indexPath];
        [[MBApiClient sharedClient] deleteBookInstanceWithId:bookCell.bookInstanceId
                                                successBlock:^(id responseObject) {
                                                    [self.myBooks removeObjectAtIndex:indexPath.row];
                                                    //[tableView reloadData]; // tell table to refresh now
                                                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                                } errorBlock:^(NSError *error) {
                                                    if ([[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 403) {
                                                        NSLog(@"There was an error in deleting. existing requests");
                                                    }
 
                                                    NSLog(@"There was an error in deleting.");
                                                }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [confirmationAlert addAction:cancel];
    [confirmationAlert addAction:delete];
    
    [self presentViewController:confirmationAlert animated:YES completion:nil];
}


@end
