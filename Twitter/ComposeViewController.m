//
//  ComposeViewController.m
//  Twitter
//
//  Created by  Steve Carlson (Media Engineering) on 2/1/17.
//  Copyright © 2017 Steve Carlson. All rights reserved.
//

#import "ComposeViewController.h"
#import "NavigationManager.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "TwitterClient.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextBox;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UILabel *lengthCounter;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTextBox.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    self.profileImageView.layer.cornerRadius = 4.0;
    self.profileImageView.layer.masksToBounds = YES;
    
    // For now, we'll get the profile image from preferences. TODO: purge the
    // cache if the user changes their profile image
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *profileImageURL = [defaults URLForKey:@"profileImageURL"];
    [self.profileImageView setImageWithURL:profileImageURL];
    
    //self.tweetTextBox.placeholder = @"What's happening?";
    //self.tweetTextBox.placeholderColor = [UIColor lightGrayColor];
    [self.tweetTextBox becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClose:(UIButton *)sender {
    [self close];
}

- (IBAction)onSendTweet:(UIButton *)sender {
    [[TwitterClient sharedInstance] sendTweet:self.tweetTextBox.text callback:^(Tweet *tweet, NSError* error) {
        if (!error) {
            [self.delegate tweetCreated:tweet];
            [self close];
        } else {
            NSLog(@"An error occurred: %@", error.description);
        }
    }];
}

- (void)close {
    [[NavigationManager sharedInstance] dismissCompose];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return ([textView.text length] <= 140) ? YES : NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    long count = (unsigned long)[textView.text length];
    self.lengthCounter.text = [NSString stringWithFormat:@"%ld", 140 - count];
}
@end
