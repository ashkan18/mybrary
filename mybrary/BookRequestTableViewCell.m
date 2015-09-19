//
//  BookRequestTableViewCell.m
//  mybrary
//
//  Created by Ashkan Nasseri on 9/18/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import "BookRequestTableViewCell.h"
#import "MBApiClient.h"

@implementation BookRequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rejectRequest:(id)sender {
    [[MBApiClient sharedClient] updateBookRequestWithBookInstanceId:self.bookRequestId
                                                               type:nil
                                                             status:@-1
                                                       successBlock:^(id responseObject) {
                                                           self.backgroundColor = [UIColor grayColor];
                                                       } errorBlock:^(NSError *error) {
                                                           NSLog(@"Error!!");
                                                       }];
}
- (IBAction)acceptRequest:(id)sender {
    [[MBApiClient sharedClient] updateBookRequestWithBookInstanceId:self.bookRequestId
                                                               type:nil
                                                             status:@1
                                                       successBlock:^(id responseObject) {
                                                           self.backgroundColor = [UIColor greenColor];
                                                       } errorBlock:^(NSError *error) {
                                                           NSLog(@"Error!!");
                                                       }];

}

@end
