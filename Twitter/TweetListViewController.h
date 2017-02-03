//
//  TweetListViewController.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface TweetListViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *user;
@end
