//
//  NavigationManager.h
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/1/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface NavigationManager : NSObject

+ (instancetype)sharedInstance;

- (UIViewController *)rootViewController;
- (void)showCompose;
- (void)dismissCompose;
- (void)showTweet:(Tweet *)tweet reply:(bool)reply;
- (void)showUser:(User *)user;
- (void)logIn;
- (void)logOut;

@end
