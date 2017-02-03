//
//  TwitterClient.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"uf6LD28vfh8FSGLZxr1fjNuXU";
NSString * const kTwitterConsumerSecret = @"lwyB0L6fFsTWgmNsjleMT593YODNDMQNo0zQrdoKQFdi7RVmjX";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);
@property (nonatomic, strong) User *user;

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self deauthorize];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"stevetwitter://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got a request token!");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Successfully opened login page");
            } else {
                NSLog(@"Unable to open login page");
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get request token");
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access token!");
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            NSLog(@"user dictionary: %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            // Store the user id and screenname
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:user.userId forKey:@"userId"];
            [defaults setValue:user.screenname forKey:@"screenname"];
            [defaults synchronize];
            
            self.loginCompletion(user, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Failed to create user object");
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the access token");
        self.loginCompletion(nil, error);
    }];
}

- (void)getUser:(NSString *)screenname callback:(UserFetcherCallback)callback {
    NSString *url = [NSString stringWithFormat:@"1.1/users/show.json?screen_name=%@", screenname];
    [self GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        User *user = [[User alloc] initWithDictionary:responseObject];
        callback(user, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error fetching user %@", screenname);
        callback(nil, error);
    }];
}

- (void)getUserTweets:(TweetListFetcherCallback)callback {
    [self GET:@"1.1/statuses/home_timeline.json?count=50" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        callback(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error fetching tweets");
        callback(nil, error);
    }];
}

- (void)getUserTweets:(TweetListFetcherCallback)callback user:(User *)user {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@&count=50", user.screenname];
    [self GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        callback(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error fetching tweets");
        callback(nil, error);
    }];
}

- (void)favoriteTweet:(Tweet *)tweet callback:(TweetFetcherCallback)callback {
    NSString *url = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweet.tweetId];
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error favoriting tweet: %@", error);
        callback(nil, error);
    }];
}

- (void)unfavoriteTweet:(Tweet *)tweet callback:(TweetFetcherCallback)callback {
    NSString *url = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", tweet.tweetId];
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error unfavoriting tweet: %@", error);
        callback(nil, error);
    }];
}

- (void)retweetTweet:(Tweet *)tweet callback:(TweetFetcherCallback)callback {
    NSLog(@"retweet: %@", tweet.tweetId);
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.tweetId];
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error retweeting tweet: %@", error);
        callback(nil, error);
    }];
}

- (void)unretweetTweet:(Tweet *)tweet callback:(TweetFetcherCallback)callback {
    NSLog(@"unretweet: %@", tweet.tweetId);
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweet.tweetId];
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response from unretweet API: %@", responseObject);
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error unretweeting tweet: %@", error);
        callback(nil, error);
    }];
}

@end
