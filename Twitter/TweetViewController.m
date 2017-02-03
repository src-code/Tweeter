//
//  TweetViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/2/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()

@end

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";
    
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
        //self.retweetLabel.text = [NSString stringWithFormat:@"@%@ Retweeted", self.tweet.user.name];
        //self.retweetContainerHeightConstraint.constant = 18;
    } else {
        mainTweet = self.tweet;
        //self.retweetLabel.text = @"";
        //self.retweetContainerHeightConstraint.constant = 0;
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
