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
#import "Lockbox.h"
#import <CommonCrypto/CommonDigest.h>

#define kUsernameKeyString          @"UsernameKeyString"
#define kTokenKeyString             @"TokenKeyString"
#define kLoggedinStatusKeyString    @"LoggedinStatusKeyString"
#define salt                        @"FSF^D&*FH#RJNF@!$JH#@$"

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
    NSString *type = @"register";
    
    // Hashing Algorithm
    NSString *saltPassword = [password stringByAppendingString:salt];
    NSString *passwordMD5 = [self md5:saltPassword];
    
    if ([email isEqualToString:confirmEmail] && [password isEqualToString:confirmPassword]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                username, @"username",
                                passwordMD5, @"passwordMD5",
                                email, @"email",
                                type, @"type",
                                nil];
        
        NSLog(@"Params: %@", params);
        
        // Sends request to server to login, server sends response via JSON
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/Hiskor_Admin"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"api.php" parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"Username: %@", [JSON valueForKeyPath:@"username"]);
                NSLog(@"Email: %@", [JSON valueForKeyPath:@"email"]);
                NSLog(@"Status: %@", [JSON valueForKeyPath:@"status"]);
                
                // Save username to keychain
                [Lockbox setString:[JSON valueForKeyPath:@"username"] forKey:kUsernameKeyString];
                
                // Save token to keychain
                [Lockbox setString:[JSON valueForKeyPath:@"token"] forKey:kTokenKeyString];
                
                // Save login status to keychain
                [Lockbox setString:@"TRUE" forKey:kLoggedinStatusKeyString];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"Error with request");
                NSLog(@"%@", [error localizedDescription]);
        }];
        
        [operation start];
    }
}

// MD5 Hashing Function
- (NSString *)md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}
@end