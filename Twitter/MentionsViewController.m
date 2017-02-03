//
//  MentionsViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/1/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "MentionsViewController.h"
#import "TwitterClient.h"
#import "TweetListViewController.h"

@interface MentionsViewController ()

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Mentions";
    NSLog(@"viewDidLoad: %@", self.tableView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchTweets {
    NSLog(@"Fetching mentions");
    TweetListFetcherCallback callback = ^(NSArray *tweets, NSError* error) {
        if (!error) {
            NSLog(@"Got tweets %@", tweets);
            self.tweets = tweets;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    };
    
    [[TwitterClient sharedInstance] getUserMentions:callback];
}

@end
