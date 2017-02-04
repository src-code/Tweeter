//
//  TweetViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/2/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "TweetViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NavigationManager.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.profileImageView.layer.cornerRadius = 4.0;
    self.profileImageView.layer.masksToBounds = YES;
    
    // Handle click on profile image
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage:)];
    [self.profileImageView addGestureRecognizer:imageTap];

    
    // Do any additional setup after loading the view from its nib.
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTweet:(Tweet *)tweet {
    NSLog(@"Updating tweet: %@", tweet.tweetId);
    _tweet = tweet;
    [self reloadData];
}

- (void)reloadData {
    Tweet *mainTweet;
    
    if (self.tweet.retweet) {
        mainTweet = self.tweet.retweet;
        self.retweetLabel.text = [NSString stringWithFormat:@"@%@ Retweeted", self.tweet.user.name];
        self.retweetContainerHeightConstraint.constant = 18;
    } else {
        mainTweet = self.tweet;
        self.retweetLabel.text = @"";
        self.retweetContainerHeightConstraint.constant = 0;
    }

    self.nameLabel.text = mainTweet.user.name;
    [self.profileImageView setImageWithURL:mainTweet.user.profileImageUrl];
    self.screennameLabel.text = [@"@" stringByAppendingString:mainTweet.user.screenname];
    self.tweetTextView.text = mainTweet.text;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%@", mainTweet.retweetCount];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%@", mainTweet.favoriteCount];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy h:mm a"];
    self.timestampLabel.text = [dateFormatter stringFromDate:mainTweet.createdAt];
}

- (void)onTapProfileImage:(UIGestureRecognizer *)gestureRecognizer{
    [[NavigationManager sharedInstance] showUser:self.tweet.user];
}

@end
