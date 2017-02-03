//
//  ProfileViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/1/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "TwitterClient.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    
    // Insert a profile table view cell
    if (self.user) {
        [self renderHeader:self.user];
    } else {
        // Logged-in user. Get the screenname from stored preferences
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [defaults stringForKey:@"userId"];
        [self fetchUserAndRenderHeader:userId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)renderHeader:(User *)user {
    NSLog(@"rendering profile header for user %@", user.name);
    UINib *nib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
    ProfileHeaderView *userHeader = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    userHeader.user = user;
    self.tableView.tableHeaderView = userHeader;
    [self.tableView reloadData];
}

- (void)fetchUserAndRenderHeader:(NSString *)screenname {
    [[TwitterClient sharedInstance] getUser:screenname callback:^(User *user, NSError* error) {
        if (!error) {
            //[self.refreshControl endRefreshing];
            [self renderHeader:user];
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    }];
}
@end
