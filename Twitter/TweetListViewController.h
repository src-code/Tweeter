//
//  TweetListViewController.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ComposeViewController.h"
#import "TweetTableViewCell.h"

@interface TweetListViewController : UIViewController <TweetCellDelegate, ComposeTweetDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
