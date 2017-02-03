//
//  TweetTableViewCell.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetCellDelegate <NSObject>
- (void)profileImageTapped:(UITableViewCell *)cell;
@end

@interface TweetTableViewCell : UITableViewCell
@property id <TweetCellDelegate> delegate;
@property (strong, nonatomic) Tweet *tweet;
@end
