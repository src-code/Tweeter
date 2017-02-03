//
//  Tweet.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    //NSLog(@"dictionary: %@", dictionary);

    if (self) {
        self.tweetId = dictionary[@"id"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.retweetCount = dictionary[@"retweet_count"];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.favoriteCount = dictionary[@"favorite_count"];

        if (dictionary[@"retweeted_status"]) {
            self.retweet = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        }

        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAtString];
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }

    return tweets;
}

@end
