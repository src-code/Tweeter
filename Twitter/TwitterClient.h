//
//  TwitterClient.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "Tweet.h"
#import "User.h"

typedef void (^UserFetcherCallback)(User *user, NSError* error);
typedef void (^TweetListFetcherCallback)(NSArray *tweets, NSError* error);
typedef void (^TweetFetcherCallback)(Tweet *tweet, NSError* error);

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *) sharedInstance;

- (void)loginWithCompletion:(UserFetcherCallback)completion;
- (void)openURL:(NSURL *)url;

- (void)getUser:(NSString *)screenname callback:(UserFetcherCallback)callback;
- (void)getUserTweets:(TweetListFetcherCallback)callback;
- (void)getUserTweets:(TweetListFetcherCallback)callback user:(User *)user;
- (void)getUserMentions:(TweetListFetcherCallback)callback;
- (void)favoriteTweet:(Tweet *)tweet callback:(TweetFetcherCallback) callback;
- (void)unfavoriteTweet:(Tweet *)tweet callback:(TweetFetcherCallback) callback;
- (void)retweetTweet:(Tweet *)tweet callback:(TweetFetcherCallback) callback;
- (void)unretweetTweet:(Tweet *)tweet callback:(TweetFetcherCallback) callback;
- (void)sendTweet:(NSString *)tweetText callback:(TweetFetcherCallback)callback;
- (void)sendTweet:(NSString *)tweetText replyTo:(NSString *)replyTo callback:(TweetFetcherCallback)callback;

@end
