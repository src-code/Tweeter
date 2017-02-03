//
//  ComposeViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/1/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "ComposeViewController.h"
#import "NavigationManager.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClose:(UIButton *)sender {
    [[NavigationManager sharedInstance] dismissCompose];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
