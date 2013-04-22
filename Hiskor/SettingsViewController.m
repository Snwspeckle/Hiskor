//
//  SettingsViewController.m
//  Hiskor
//
//  Created by Quandt Family on 3/5/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "SettingsViewController.h"
#import "TabBarViewController.h"
#import "Lockbox.h"

@interface SettingsViewController ()

@property (nonatomic, strong) UITextField *hiddenHomeSchoolTextField;

@end

@implementation SettingsViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.hiddenHomeSchoolTextField = [[UITextField alloc] init];
	self.hiddenHomeSchoolTextField.hidden = YES;
	[self.tableView addSubview:self.hiddenHomeSchoolTextField];
	
	self.pickerView = [[UIPickerView alloc] init];
	
	self.pickerView.showsSelectionIndicator = YES;
	self.pickerView.dataSource = self;
	self.pickerView.delegate = self;

	self.hiddenHomeSchoolTextField.inputView = self.pickerView;
	
	UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	accessoryView.barStyle = UIBarStyleBlackTranslucent;
	
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
	
	accessoryView.items = [NSArray arrayWithObjects:space,done, nil];
	
	self.hiddenHomeSchoolTextField.inputAccessoryView = accessoryView;	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.stayLoggedInSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"stayLoggedInPreference"] boolValue];

	[self loadSchools];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnLogout:(id)sender {
    
    [Lockbox setString:@"FALSE" forKey:kLoggedinStatusKeyString];
	[Lockbox setString:kUserIDKeyStringLoggedOut forKey:kUserIDKeyString];
	[Lockbox setString:@"" forKey:kTokenKeyString];
    [(TabBarViewController *)[self tabBarController] loginCheck:YES];
}

- (IBAction)stayLoggedInSwitchChanged {
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.stayLoggedInSwitch.on] forKey:@"stayLoggedInPreference"];
}


- (void)loadSchools {
	
	self.schoolsLoaded = false;
	
	[self.activityIndicator startAnimating];

	NSLog(@"UserID: %@", [Lockbox stringForKey:kUserIDKeyString]);
	NSString *userID = [Lockbox stringForKey:kUserIDKeyString];
	NSString *type = @"schools";
	
	NSDictionary *parmas = [NSDictionary dictionaryWithObjectsAndKeys:
							userID, @"userID",
							type, @"type",
							nil];
	
	[NetworkingManager sendDictionary:parmas responseHandler:self];
}


- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {
	
	[self.activityIndicator stopAnimating];
	
	NSLog(@"Schools recived:");
	NSLog(@"response: %@", response);
	
	if ([[response valueForKeyPath:@"message"] isEqualToString:@"Success"]) {
		
		self.schools = [[response objectForKey:@"schools"] mutableCopy];
		[self.pickerView reloadAllComponents];
		
		NSDictionary *selectedSchool = [[NSUserDefaults standardUserDefaults] objectForKey:@"homeSchoolPreference"];
		if (selectedSchool) {
			NSUInteger index = [self.schools indexOfObject:selectedSchool];
			
			if (index == NSNotFound) {
				index = 0;
			}
			
			[self.pickerView selectRow:index inComponent:0 animated:NO];
		}
		self.schoolsLoaded = YES;
	}
	else {
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Schools" message:@"Server denied request" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[loginAlert show];
	}
}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
		
	[self.activityIndicator stopAnimating];
	
	
	NSLog(@"Error with request");
	NSLog(@"%@", [error localizedDescription]);
	
	UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Schools" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[loginAlert show];
	
}

- (void)doneEditing {
	[self.hiddenHomeSchoolTextField resignFirstResponder];
	int index = [self.pickerView selectedRowInComponent:0];
	[[NSUserDefaults standardUserDefaults] setObject:[self.schools objectAtIndex:index] forKey:@"homeSchoolPreference"];
	[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.schoolsLoaded && indexPath.row == 1) {
		return indexPath;
	}
	else {
		return nil;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1 && self.schoolsLoaded) {
		[self.hiddenHomeSchoolTextField becomeFirstResponder];
	}
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	UIView *view = nil;
	if (section >= [self numberOfSectionsInTableView:tableView] - 1) {
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
		view.backgroundColor = [UIColor whiteColor];
	}
	else {
		view = [UIView new];
	}
    return view;
}

#pragma mark -
#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.schools count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate Methods

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return pickerView.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 66;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[self.schools objectAtIndex:row] objectForKey:@"schoolName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
}

@end
