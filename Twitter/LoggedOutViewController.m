//
//  LoginViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 1/30/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "LoggedOutViewController.h"
#import "NavigationManager.h"

@interface LoggedOutViewController ()

@end

@implementation LoggedOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[NavigationManager sharedInstance] logIn];
}

@end
