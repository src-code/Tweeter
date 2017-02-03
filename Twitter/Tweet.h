//
//  Tweet.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) bool retweeted;
@property (nonatomic, strong) NSNumber *retweetCount;
@property (nonatomic, assign) bool favorited;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Tweet *retweet;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;
@end
