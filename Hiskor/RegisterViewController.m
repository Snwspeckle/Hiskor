//
//  RegisterViewController.m
//  Hiskor
//
//  Created by SuchyMac3 on 1/30/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize usernameField, emailField, confirm_emailField, passwordField, confirm_passwordField;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnRegister:(id)sender {
    
    NSString *username = usernameField.text;
    NSString *email = emailField.text;
    NSString *confirmEmail = confirm_emailField.text;
    NSString *password = passwordField.text;
    NSString *confirmPassword = confirm_passwordField.text;
    
    if ([email isEqualToString:confirmEmail] && [password isEqualToString:confirmPassword]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", email, @"email", nil];
        
        NSURL *url = [NSURL URLWithString:@"http://localhost/"];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient defaultValueForHeader:@"Accept"];
        
        //[httpClient setParameterEncoding:AFJSONParameterEncoding];
        
        [httpClient postPath:@"register.php" parameters:params
                     success:^(AFHTTPRequestOperation *operation, id response) {
                         NSLog(@"Working: %d", [operation.response statusCode]);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error with Request");
                         NSLog(@"%@", [error localizedDescription]);
                     }];
    } else {
        NSLog(@"Email or password doesn't match, try again!");
    }
}
@end
