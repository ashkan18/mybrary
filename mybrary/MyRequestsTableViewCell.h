//
//  MyRequestsTableViewCell.h
//  mybrary
//
//  Created by Ashkan Nasseri on 9/21/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRequestsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) NSNumber *bookRequestId;

@end
