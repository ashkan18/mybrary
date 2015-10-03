//
//  BookTableViewCell.h
//  mybrary
//
//  Created by Ashkan Nasseri on 10/3/15.
//  Copyright © 2015 uook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) NSNumber *bookInstanceId;

@end
