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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
	
	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"tasky_pattern.png"]];
	
	
	UIImage *buttonImage = [[UIImage imageNamed:@"greyButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"greyButtonHighlight.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [self.registerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.registerButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
	
	self.inputTableView  = [[UITableView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 300) / 2, 60, 300, 400) style:UITableViewStyleGrouped];
    self.inputTableView.dataSource = self;
    self.inputTableView.delegate = self;

	self.inputTableView.backgroundView = nil;
	self.inputTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.inputTableView.scrollEnabled = NO;

	[self.view addSubview:self.inputTableView];
    [self.view sendSubviewToBack:self.inputTableView];
	
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
    
    NSString *firstName = self.firstNameCell.textField.text;
	NSString *lastName = self.lastNameCell.textField.text;
    NSString *email = self.emailCell.textField.text;
    NSString *confirmEmail = self.confirmEmailCell.textField.text;
    NSString *password = self.passwordCell.textField.text;
    NSString *confirmPassword = self.confirmPasswordCell.textField.text;
    NSString *type = @"register";
    
	if ([firstName isEqualToString:@""] || [lastName isEqualToString:@""] || [email isEqualToString:@""] || [confirmEmail isEqualToString:@""] || [password isEqualToString:@""] || [confirmPassword isEqualToString:@""]) {
		
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error During Registration" message:@"All fields are required" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[loginAlert show];
		return;
	}
	
	
    // Hashing Algorithm
    NSString *saltPassword = [password stringByAppendingString:salt];
    NSString *passwordMD5 = [self md5:saltPassword];
    
    if ([email isEqualToString:confirmEmail] && [password isEqualToString:confirmPassword]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                firstName, @"firstName",
								lastName, @"LastName",
                                passwordMD5, @"passwordMD5",
                                email, @"email",
                                type, @"type",
                                nil];
        
        NSLog(@"Params: %@", params);
        
		[NetworkingManager sendDictionary:params responseHandler:self];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
    if (textField == self.firstNameCell.textField) {
        [self.lastNameCell.textField becomeFirstResponder];
    }
	else if (textField == self.lastNameCell.textField) {
        [self.emailCell.textField becomeFirstResponder];
    }
	else if (textField == self.emailCell.textField) {
        [self.confirmEmailCell.textField becomeFirstResponder];
    }
	else if (textField == self.confirmEmailCell.textField) {
        [self.passwordCell.textField becomeFirstResponder];
    }
	else if (textField == self.passwordCell.textField) {
        [self.confirmPasswordCell.textField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordCell.textField) {
        [textField resignFirstResponder];
        [self btnRegister:nil];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	self.inputTableView.contentSize = CGSizeMake(self.inputTableView.frame.size.width, 4000);
	self.shouldScrollToTop = NO;

	if (textField == self.firstNameCell.textField) {
		[self.inputTableView scrollRectToVisible:CGRectMake(0, 0, self.inputTableView.frame.size.width, self.inputTableView.frame.size.height) animated:YES];
    }
	else if (textField == self.lastNameCell.textField) {
		[self.inputTableView scrollRectToVisible:CGRectMake(0, 0, self.inputTableView.frame.size.width, self.inputTableView.frame.size.height) animated:YES];
    }
	else if (textField == self.emailCell.textField) {
		[self.inputTableView scrollRectToVisible:CGRectMake(0, 48, self.inputTableView.frame.size.width, self.inputTableView.frame.size.height) animated:YES];
    }
	else if (textField == self.confirmEmailCell.textField) {
		[self.inputTableView scrollRectToVisible:CGRectMake(0, 96, self.inputTableView.frame.size.width, self.inputTableView.frame.size.height) animated:YES];
    }
	else if (textField == self.passwordCell.textField) {
		[self.inputTableView scrollRectToVisible:CGRectMake(0, 144, self.inputTableView.frame.size.width, self.inputTableView.frame.size.height) animated:YES];
    }
    else if (textField == self.confirmPasswordCell.textField) {
		[self.inputTableView scrollRectToVisible:CGRectMake(0, 144, self.inputTableView.frame.size.width, self.inputTableView.frame.size.height) animated:YES];
    }
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (self.shouldScrollToTop) {
		[self.inputTableView scrollRectToVisible:CGRectMake(0, 0, self.inputTableView.frame.size.width, self.inputTableView.frame.size.height) animated:YES];
	}
	self.shouldScrollToTop = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	self.shouldScrollToTop = YES;
}


#pragma mark - NetworkingResponseHandler Protocol Methods

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {
	
	NSLog(@"Email: %@", [response valueForKeyPath:@"email"]);
	NSLog(@"Status: %@", [response valueForKeyPath:@"status"]);

	if ([[message objectForKey:@"type"] isEqualToString:@"register"]) {
		if ([[response objectForKey:@"status"] isEqualToString:@"Registration Passed"]) {
			
			// Save username to keychain
			[Lockbox setString:[response valueForKeyPath:@"username"] forKey:kUserIDKeyString];
			
			// Save token to keychain
			[Lockbox setString:[response valueForKeyPath:@"token"] forKey:kTokenKeyString];
			
			// Save login status to keychain
			[Lockbox setString:@"TRUE" forKey:kLoggedinStatusKeyString];
			
			[self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
		}
		else {
			UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error During Registration" message:@"Please confirm all fields are filled out correctly" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			
			[loginAlert show];
		}
	}
}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
	
	UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error During Registration" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[loginAlert show];
	
	NSLog(@"Error with request");
	NSLog(@"%@", [error localizedDescription]);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:.874 green:.874 blue:.874 alpha:1];
    
    switch (indexPath.row) {
        case 0:
            
            self.firstNameCell = cell;
            self.firstNameCell.textField.placeholder = @"First Name";
            self.firstNameCell.textField.textColor = [UIColor blackColor];
            self.firstNameCell.textField.clearButtonMode  = UITextFieldViewModeWhileEditing;
            self.firstNameCell.textField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
			self.firstNameCell.textField.returnKeyType = UIReturnKeyNext;
            self.firstNameCell.textField.delegate = self;
            [cell.contentView addSubview:self.firstNameCell.textField];
            break;
		case 1:
            
            self.lastNameCell = cell;
            self.lastNameCell.textField.placeholder = @"Last Name";
            self.lastNameCell.textField.textColor = [UIColor blackColor];
            self.lastNameCell.textField.clearButtonMode  = UITextFieldViewModeWhileEditing;
            self.lastNameCell.textField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
			self.lastNameCell.textField.returnKeyType = UIReturnKeyNext;
            self.lastNameCell.textField.delegate = self;
            [cell.contentView addSubview:self.lastNameCell.textField];
            break;
		case 2:
            
            self.emailCell = cell;
            self.emailCell.textField.placeholder = @"Email";
            self.emailCell.textField.textColor = [UIColor blackColor];
            self.emailCell.textField.clearButtonMode  = UITextFieldViewModeWhileEditing;
            self.emailCell.textField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            self.emailCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
			self.emailCell.textField.returnKeyType = UIReturnKeyNext;
            self.emailCell.textField.delegate = self;
            [cell.contentView addSubview:self.emailCell.textField];
            break;
		case 3:
            
            self.confirmEmailCell = cell;
            self.confirmEmailCell.textField.placeholder = @"Confirm Email";
            self.confirmEmailCell.textField.textColor = [UIColor blackColor];
            self.confirmEmailCell.textField.clearButtonMode  = UITextFieldViewModeWhileEditing;
            self.confirmEmailCell.textField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            self.confirmEmailCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
			self.confirmEmailCell.textField.returnKeyType = UIReturnKeyNext;
            self.confirmEmailCell.textField.delegate = self;
            [cell.contentView addSubview:self.confirmEmailCell.textField];
            break;
        case 4:
            self.passwordCell = cell;
            self.passwordCell.textField.placeholder = @"Password";
            self.passwordCell.textField.textColor = [UIColor blackColor];
            self.passwordCell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.passwordCell.textField.secureTextEntry = YES;
            self.passwordCell.textField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            self.passwordCell.textField.returnKeyType = UIReturnKeyNext;
            self.passwordCell.textField.delegate = self;
            [cell.contentView addSubview:self.passwordCell.textField];
            
            break;
		case 5:
            self.confirmPasswordCell = cell;
            self.confirmPasswordCell.textField.placeholder = @"Confirm Password";
            self.confirmPasswordCell.textField.textColor = [UIColor blackColor];
            self.confirmPasswordCell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.confirmPasswordCell.textField.secureTextEntry = YES;
            self.confirmPasswordCell.textField.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            self.confirmPasswordCell.textField.returnKeyType = UIReturnKeyDone;
            self.confirmPasswordCell.textField.delegate = self;
            [cell.contentView addSubview:self.confirmPasswordCell.textField];
            
            break;
        default:
            break;
    }
    
    return cell;
}


@end