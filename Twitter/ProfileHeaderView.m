//
//  ProfileHeaderView.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/2/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Colours/Colours.h>
#import "ProfileHeaderView.h"
#import "User.h"

@interface ProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *userInfoContainer;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@end

@implementation ProfileHeaderView

- (void)setUser:(User *)user {
    _user = user;

    self.profileImage.layer.cornerRadius = 4.0;
    self.profileImage.layer.masksToBounds = YES;
    self.userInfoContainer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9];
    self.userInfoContainer.layer.masksToBounds = YES;
    self.userInfoContainer.layer.cornerRadius = 9.0;
    
    self.username.text = user.name;
    self.screenname.text = [NSString stringWithFormat:@"@%@", user.screenname];
    [self.profileImage setImageWithURL:user.profileImageUrl];
    self.tweetCount.text = [NSString stringWithFormat:@"%@", user.tweetCount];
    self.followingCount.text = [NSString stringWithFormat:@"%@", user.friendsCount];
    self.followerCount.text = [NSString stringWithFormat:@"%@", user.followersCount];
    
    self.backgroundColor = [UIColor colorFromHexString:user.profileBgColor];
    if (user.profileBgImageUrl) {
        [self.bannerImage setImageWithURL:user.profileBgImageUrl];
    }
    //[self setNeedsUpdateConstraints];
}
@end
