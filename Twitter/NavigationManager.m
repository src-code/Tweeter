//
//  NavigationManager.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/1/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "NavigationManager.h"
#import "TwitterClient.h"
#import "LoggedOutViewController.h"
#import "TweetListViewController.h"
#import "ProfileViewController.h"
#import "MentionsViewController.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"

@interface NavigationManager ()
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, weak) TweetListViewController *tweetListViewController;
@end

@implementation NavigationManager

+ (instancetype)sharedInstance {
    static NavigationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NavigationManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIViewController *root = [TwitterClient sharedInstance].isAuthorized ? [self loggedInVC] : [self loggedOutVC];
        
        self.navigationController = [[UINavigationController alloc] init];
        self.navigationController.viewControllers = @[root];
        [self.navigationController setNavigationBarHidden:YES];
    }
    return self;
}


- (UIViewController *)rootViewController
{
    return self.navigationController;
}


- (UIViewController *)loggedInVC
{
    UIColor *twitterBlueColor = [UIColor colorWithRed:0.11 green:0.63 blue:0.95 alpha:1.0];

    // Create ViewControllers
    TweetListViewController *tweetListVC = [[TweetListViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
    tweetListVC.title = @"";
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
    MentionsViewController *mentionsVC = [[MentionsViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
    
    // Create tab items
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home-icon"] tag:0];
    tweetListVC.tabBarItem = homeTabBarItem;
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile-icon"] tag:0];
    profileVC.tabBarItem = profileTabBarItem;
    UITabBarItem *mentionsTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Mentions" image:[UIImage imageNamed:@"account-icon"] tag:0];
    mentionsVC.tabBarItem = mentionsTabBarItem;

    // Create navigation controllers
    UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:tweetListVC];
    homeNavController.navigationBar.tintColor = [UIColor whiteColor];
    homeNavController.navigationBar.barTintColor = twitterBlueColor;
    homeNavController.title = @"Home";
    UIBarButtonItem *signoutBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    tweetListVC.navigationItem.leftBarButtonItem = signoutBarButtonItem;
    UIBarButtonItem *tweetBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showCompose)];
    tweetListVC.navigationItem.rightBarButtonItem = tweetBarButtonItem;
    tweetListVC.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twiiter-logo-40-alt"]];
    
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profileVC];
    profileNavController.navigationBar.tintColor = [UIColor whiteColor];
    profileNavController.navigationBar.barTintColor = twitterBlueColor;
    profileNavController.title = @"Profile";
    
    UINavigationController *mentionsNavController = [[UINavigationController alloc] initWithRootViewController:mentionsVC];
    mentionsNavController.title = @"Mentions";
    mentionsNavController.navigationBar.tintColor = [UIColor whiteColor];
    mentionsNavController.navigationBar.barTintColor = twitterBlueColor;
    
    // Create tab bar view controller
    self.tabBarController = [[UITabBarController alloc] init];
    
    // Add navigation controllers to tab bar controller
    self.tabBarController.viewControllers = @[homeNavController, mentionsNavController, profileNavController];

    // Save this for later when delegating from compose tweet
    self.tweetListViewController = tweetListVC;
    
    return self.tabBarController;
}

- (UIViewController *)loggedOutVC
{
    LoggedOutViewController *vc = [[LoggedOutViewController alloc] initWithNibName:@"LoggedOutViewController" bundle:nil];
    
    return vc;
}

- (void)showCompose {
    ComposeViewController *composeVC = [[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:nil];
    composeVC.modalPresentationStyle = UIModalPresentationFullScreen;
    composeVC.delegate = self.tweetListViewController;
    [self.tabBarController.selectedViewController presentViewController:composeVC animated:YES completion:nil];
}

- (void)dismissCompose {
    [self.tabBarController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showTweet:(Tweet *)tweet reply:(bool)reply {
    TweetViewController *tweetVC = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    UIBarButtonItem *tweetBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showCompose)];
    tweetVC.navigationItem.rightBarButtonItem = tweetBarButtonItem;
    
    tweetVC.tweet = tweet;
    
    [((UINavigationController *)self.tabBarController.selectedViewController) pushViewController:tweetVC animated:YES];
}

- (void)showUser:(User *)user {
    ProfileViewController *profileVC = [[ProfileViewController alloc] initWithNibName:@"TweetListViewController" bundle:nil];
    profileVC.user = user;
    
    [((UINavigationController *)self.tabBarController.selectedViewController) pushViewController:profileVC animated:YES];
}

- (void)logIn
{
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"Welcome to %@", user.name);
            [self.navigationController setViewControllers:@[[self loggedInVC]]];
        } else {
            NSLog(@"Error logging in: %@", error);
        }
    }];
}


- (void)logOut
{
    [[TwitterClient sharedInstance] deauthorize];
    self.navigationController.viewControllers = @[[self loggedOutVC]];
}
@end
