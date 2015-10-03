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

- (void)viewWillAppear:(BOOL)animated
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


@end
