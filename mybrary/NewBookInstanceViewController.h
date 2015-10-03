//
//  NewBookInstanceViewController.h
//  mybrary
//
//  Created by Ashkan Nasseri on 8/25/15.
//  Copyright (c) 2015 uook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBViewController.h"

@interface NewBookInstanceViewController : MBViewController

@property (strong, atomic) NSString *isbn;
@property (strong, atomic) NSDictionary *bookData;

@end
