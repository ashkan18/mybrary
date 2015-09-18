//
//  BookRequestTableViewCell.h
//  mybrary
//
//  Created by Ashkan Nasseri on 9/18/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookRequestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, atomic) NSNumber *bookRequestId;
@end
