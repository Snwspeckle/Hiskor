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
#import "AFJSONRequestOperation.h"
#import "Lockbox.h"
#import <CommonCrypto/CommonDigest.h>

#define kUsernameKeyString  @"UsernameKeyString"
#define kTokenKeyString     @"TokenKeyString"

#define kSaveAsString 0

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameField, passwordField;

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

- (IBAction)btnLogin:(id)sender {
    
    NSString *username = [usernameField text];
    NSString *password = [passwordField text];
    NSString *type = @"login";
    
    // Hashing Algorithm
    NSString *salt = @"FSF^D&*FH#RJNF@!$JH#@$";
    NSString *saltPassword = [password stringByAppendingString:salt];
    NSString *passwordMD5 = [self md5:saltPassword];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            passwordMD5, @"passwordMD5",
                            type, @"type",
                            nil];
    
    // Sends request to server to login, server sends response via JSON
    NSURL *url = [NSURL URLWithString:@"http://198.14.210.58/hiskor/"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"api.php" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"Working User: %@", [JSON valueForKeyPath:@"username"]);
            NSLog(@"Working Token: %@", [JSON valueForKeyPath:@"token"]);
            
            // Save username to keychain
            NSString *usernameKey = [JSON valueForKeyPath:@"username"];
            [Lockbox setString:usernameKey forKey:kUsernameKeyString];
            
            NSString *tokenKey = [JSON valueForKeyPath:@"token"];
            // Save token to keychain
            [Lockbox setString:tokenKey forKey:kTokenKeyString];
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"Error with request");
            NSLog(@"%@", [error localizedDescription]);
        }];
    
    [operation start];
    
}

// Keychain Checker Function
- (IBAction)btnKeychainChecker:(id)sender {
    
    NSLog(@"Keychain username: %@", [Lockbox stringForKey:kUsernameKeyString]);
    NSLog(@"Keychain token: %@", [Lockbox stringForKey:kTokenKeyString]);
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
