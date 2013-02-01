//
//  TabBarViewController.m
//  Hiskor
//
//  Created by SuchyMac3 on 1/29/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "Lockbox.h"

#define kUsernameKeyString          @"UsernameKeyString"
#define kTokenKeyString             @"TokenKeyString"
#define kLoggedinStatusKeyString    @"LoggedinStatusKeyString"

#define kSaveAsString 0

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loginCheck];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginCheck
{
    NSLog(@"Method being ran");
    UIStoryboard *mainstoryboard = self.storyboard;
    LoginViewController* loginViewController = [mainstoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    if ([[Lockbox stringForKey:kLoggedinStatusKeyString] isEqualToString:@"FALSE"]) {
        [self presentViewController:loginViewController animated:NO completion:nil];
    }
}

@end
