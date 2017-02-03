//
//  User.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *profileBgColor;
@property (nonatomic, strong) NSURL *profileBgImageUrl;
@property (nonatomic, assign) NSNumber *followersCount;
@property (nonatomic, assign) NSNumber *friendsCount;
@property (nonatomic, assign) NSNumber *favoritesCount;
@property (nonatomic, assign) NSNumber *tweetCount;


- (id)initWithDictionary:(NSDictionary *)dictionary;
@end
