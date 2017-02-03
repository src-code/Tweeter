//
//  ComposeViewController.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/1/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeTweetDelegate <NSObject>
- (void)tweetCreated:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController
@property id <ComposeTweetDelegate> delegate;
@end
