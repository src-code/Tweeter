 //
//  User.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.userId = dictionary[@"id_str"];
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.profileImageUrl = [NSURL URLWithString:dictionary[@"profile_image_url_https"]];
        self.tagline = dictionary[@"description"];
        self.profileBgColor = dictionary[@"profile_background_color"];
        if (dictionary[@"profile_banner_url"] != [NSNull null]) {
            self.profileBgImageUrl = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        }
        self.followersCount = dictionary[@"followers_count"];
        self.friendsCount = dictionary[@"friends_count"];
        self.favoritesCount = dictionary[@"favourites_count"];
        self.tweetCount = dictionary[@"statuses_count"];
    }
    return self;
}

@end
