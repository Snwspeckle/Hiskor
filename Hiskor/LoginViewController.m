//
//  LoginViewController.m
//  Hiskor
//
//  Created by SuchyMac3 on 1/29/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "LoginViewController.h"
#import "Lockbox.h"
#import <CommonCrypto/CommonDigest.h>

#define kUsernameKeyString          @"UsernameKeyString"
#define kTokenKeyString             @"TokenKeyString"
#define kLoggedinStatusKeyString    @"LoggedinStatusKeyString"
#define salt                        @"FSF^D&*FH#RJNF@!$JH#@$"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameField, passwordField;

- (IBAction)btnCHEAT:(id)sender
{
	[Lockbox setString:@"TRUE" forKey:kLoggedinStatusKeyString];

	[self dismissViewControllerAnimated:YES completion:nil];
}

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
    
    NSString *email = [usernameField text];
    NSString *password = [passwordField text];
    NSString *type = @"login";
    
    // Hashing Algorithm
    NSString *saltPassword = [password stringByAppendingString:salt];
    NSString *passwordMD5 = [self md5:saltPassword];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            email, @"email",
                            passwordMD5, @"passwordMD5",
                            type, @"type",
                            nil];
    
	[NetworkingManager sendDictionary:params responseHandler:self];
    
}

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {
	
	NSLog(@"Email: %@", [response valueForKeyPath:@"email"]);
	NSLog(@"Token: %@", [response valueForKeyPath:@"token"]);
	NSLog(@"Return Message: %@", [response valueForKeyPath:@"message"]);
	
	if ([[response valueForKeyPath:@"message"] isEqualToString:@"Failed"]) {
		
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error logging in" message:@"Invalid email or password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[loginAlert show];
		
	} else {
		
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Success" message:@"Proper login, thanks!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[loginAlert show];
		
		// Save username to keychain
		[Lockbox setString:[response valueForKeyPath:@"email"] forKey:kUsernameKeyString];
		
		// Save token to keychain
		[Lockbox setString:[response valueForKeyPath:@"token"] forKey:kTokenKeyString];
		
		// Save login status to keychain
		[Lockbox setString:@"TRUE" forKey:kLoggedinStatusKeyString];
		
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
	
	NSLog(@"Error with request");
	NSLog(@"%@", [error localizedDescription]);
}

// Keychain Checker Function
- (IBAction)btnKeychainChecker:(id)sender {
    
    NSLog(@"Keychain email: %@", [Lockbox stringForKey:kUsernameKeyString]);
    NSLog(@"Keychain token: %@", [Lockbox stringForKey:kTokenKeyString]);
    NSLog(@"Keychain login status: %@", [Lockbox stringForKey:kLoggedinStatusKeyString]);

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
