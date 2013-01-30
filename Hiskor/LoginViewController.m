//
//  LoginViewController.m
//  Hiskor
//
//  Created by SuchyMac3 on 1/29/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize fldUsername, fldPassword;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLogin:(id)sender {
    
    /*id params = @{
                @"username": self.fldUsername.text,
                @"password": self.fldPassword.text
    };*/
    
    NSString *username = fldUsername.text;
    NSString *password = fldPassword.text;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"login[username]",
                            password, @"login[password]",
                            nil];
    
    NSURL *url = [NSURL URLWithString:@"http://198.14.215.131/hiskor"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient postPath:@"/api" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Response: %@", text);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    
}
@end
