//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "TwitterClient.h"
#import "TweetTableViewCell.h"
#import "Tweet.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NavigationManager.h"

@interface TweetTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *replyButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) UIColor *defaultButtonTextColor;
@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Rounded corners
    self.profileImageView.layer.cornerRadius = 4.0;
    self.profileImageView.layer.masksToBounds = YES;
    self.defaultButtonTextColor = self.retweetButtonLabel.textColor;
    
    // Handle click on profile image
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage:)];
    [self.profileImageView addGestureRecognizer:imageTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    self.handleLabel.text = [@"@" stringByAppendingString:mainTweet.user.screenname];
    self.timestampLabel.text = [self getRelativeTimestamp:mainTweet.createdAt];
    self.contentLabel.text = mainTweet.text;

    // Action buttons
    self.retweetButtonLabel.text = [NSString stringWithFormat:@"%@", mainTweet.retweetCount];
    self.favoriteButtonLabel.text = [NSString stringWithFormat:@"%@", mainTweet.favoriteCount];
    if (mainTweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red-alt"] forState:UIControlStateNormal];
        self.favoriteButtonLabel.textColor = [UIColor redColor];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        self.favoriteButtonLabel.textColor = self.defaultButtonTextColor;
    }
    if (mainTweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        self.retweetButtonLabel.textColor = [UIColor colorWithRed:0.0 green:0.82 blue:0.52 alpha:1.0];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        self.retweetButtonLabel.textColor = self.defaultButtonTextColor;
    }
    [self setNeedsUpdateConstraints];
}

- (NSString *)getRelativeTimestamp:(NSDate *)date {
    NSString *relativeTime;
    NSTimeInterval secondsElapsed = [date timeIntervalSinceNow] * -1;
    
    if (secondsElapsed < 60) {
        // Seconds
        relativeTime = [NSString stringWithFormat:@"%.0fs", secondsElapsed];
    } else if (secondsElapsed < 3600) {
        // Minutes
        relativeTime = [NSString stringWithFormat:@"%.0fm", secondsElapsed / 60];
    } else if (secondsElapsed < 86400) {
        // Hours
        relativeTime = [NSString stringWithFormat:@"%.0fh", secondsElapsed / 3600];
    } else {
        // Previous days
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M/d/yy"];
        relativeTime = [dateFormatter stringFromDate:date];
    }
    
    return relativeTime;
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self reloadData];
}

- (IBAction)onFavorite:(UIButton *)sender {
    Tweet *favTweet = (self.tweet.retweet) ? self.tweet.retweet : self.tweet;
    TwitterClient *client = [TwitterClient sharedInstance];
    TweetFetcherCallback callback = ^(Tweet *tweet, NSError *error) {
        if (!error) {
            if (self.tweet.favorited) {
                self.tweet.favorited = NO;
                self.tweet.favoriteCount = [NSNumber numberWithInt:([self.tweet.favoriteCount intValue] - 1)];
                [self reloadData];
            } else {
                self.tweet.favorited = YES;
                self.tweet.favoriteCount = [NSNumber numberWithInt:([self.tweet.favoriteCount intValue] + 1)];
                [self reloadData];
            }
        } else {
            // error
            if (self.tweet.favorited) {
                NSLog(@"Unfavoriting tweet failed");
            } else {
                NSLog(@"Favoriting tweet failed");
            }
        }
    };
    
    if (favTweet.favorited) {
        [client unfavoriteTweet:favTweet callback:callback];
    } else {
        [client favoriteTweet:favTweet callback:callback];
    }
}

- (IBAction)onRetweet:(UIButton *)sender {
    Tweet *favTweet = (self.tweet.retweet) ? self.tweet.retweet : self.tweet;
    TwitterClient *client = [TwitterClient sharedInstance];
        
    if (favTweet.retweeted) {
        [client unretweetTweet:favTweet callback:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = NO;
                self.tweet.retweetCount = [NSNumber numberWithInt:([self.tweet.retweetCount intValue] - 1)];
                [self reloadData];
            } else {
                // error
                NSLog(@"Un-retweeting tweet failed");
            }
        }];
    } else {
        [client retweetTweet:favTweet callback:^(Tweet *tweet, NSError *error) {
            if (!error) {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount = [NSNumber numberWithInt:([self.tweet.retweetCount intValue] + 1)];
                [self reloadData];
            } else {
                // error
                NSLog(@"Retweeting tweet failed");
            }
        }];
    }
}

- (IBAction)onReply:(UIButton *)sender {
    Tweet *mainTweet = (self.tweet.retweet) ? self.tweet.retweet : self.tweet;

    [[NavigationManager sharedInstance] showTweet:mainTweet reply:YES];
}

- (void)onTapProfileImage:(UIGestureRecognizer *)gestureRecognizer{
    [self.delegate profileImageTapped:self];
}

@end
