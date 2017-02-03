//
//  TweetListViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "TweetListViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterClient.h"
#import "NavigationManager.h"

@interface TweetListViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TweetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TweetTableViewCell"];
    
    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    [self fetchTweets];
}

- (void)fetchTweets {
    NSLog(@"Fetching tweets");
    TweetListFetcherCallback callback = ^(NSArray *tweets, NSError* error) {
        if (!error) {
            self.tweets = tweets;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    };
    
    if (self.user) {
        [[TwitterClient sharedInstance] getUserTweets:callback user:self.user];
    } else {
        [[TwitterClient sharedInstance] getUserTweets:callback];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell" forIndexPath:indexPath];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.tweet = tweet;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];

    [[NavigationManager sharedInstance] showTweet:tweet reply:NO];
}

#pragma mark - TweetCellDelegate

-(void)profileImageTapped:(TweetTableViewCell *)cell {
    [[NavigationManager sharedInstance] showUser:cell.tweet.user];
}


@end
