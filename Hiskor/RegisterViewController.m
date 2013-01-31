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
    NSString *salt = @"FSF^D&*FH#RJNF@!$JH#@$";
    NSString *saltPassword = [password stringByAppendingString:salt];
    NSString *passwordMD5 = [self md5:saltPassword];
    
    if ([email isEqualToString:confirmEmail] && [password isEqualToString:confirmPassword]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                username, @"username",
                                passwordMD5, @"passwordMD5",
                                email, @"email",
                                type, @"type",
                                nil];
        
        // Sends request to server to login, server sends response via JSON
        NSURL *url = [NSURL URLWithString:@"http://198.14.210.58/hiskor/"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"register.php" parameters:params];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"Working User: %@", [JSON valueForKeyPath:@"username"]);
                NSLog(@"Working Token: %@", [JSON valueForKeyPath:@"token"]);
                                                                                                
                // Save username to keychain
                //NSString *usernameKey = [JSON valueForKeyPath:@"username"];
                //[Lockbox setString:usernameKey forKey:kUsernameKeyString];
                                                                                                
                //NSString *tokenKey = [JSON valueForKeyPath:@"token"];
                // Save token to keychain
                //[Lockbox setString:tokenKey forKey:kTokenKeyString];
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