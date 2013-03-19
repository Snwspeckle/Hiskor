//
//  HomeTableViewController.m
//  Hiskor
//
//  Created by Anthony on 2/1/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "GamesTableViewController.h"
#import "TabBarViewController.h"
#import "Lockbox.h"
#import "GamesDetailTableViewController.h"

@interface GamesTableViewController ()

@property (strong, nonatomic) GamesDetailTableViewController *nextViewController;

@end

@implementation GamesTableViewController
@synthesize animateBOOL;

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

    self.games = [[NSMutableOrderedSet alloc] init];
	[self refresh];
}

- (void)refresh {
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
    [activityIndicator startAnimating];
	
	NSLog(@"UserID: %@", [Lockbox stringForKey:kUserIDKeyString]);
	NSString *userID = [Lockbox stringForKey:kUserIDKeyString];
	NSString *type = @"clientGames";
	
	NSDictionary *parmas = [NSDictionary dictionaryWithObjectsAndKeys:
							userID, @"userID",
							type, @"type",
							nil];
	
	[NetworkingManager sendDictionary:parmas responseHandler:self];
}

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {

	if ([[response valueForKeyPath:@"message"] isEqualToString:@"Failed"]) {
		
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error logging in" message:@"Invalid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[loginAlert show];
		
	} else {

		[self navigationItem].rightBarButtonItem = nil;
		
		NSLog(@"Games recived:");
		NSLog(@"response: %@", response);
		
		[self.games addObjectsFromArray:[response objectForKey:@"games"]];
		[self.tableView reloadData];
	}
}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
	NSLog(@"Error with request");
	NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *game =  [self.games objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [[[game valueForKey:@"homeSchool"] stringByAppendingString:@" vs. "] stringByAppendingString:[game valueForKey:@"awaySchool"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.nextViewController.gameData = [self.games objectAtIndex:indexPath.row];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"QRTicket"]) {
		self.nextViewController = [segue destinationViewController];
	}
}

- (IBAction)btnLogout:(id)sender {
    
    self.animateBOOL = YES;
    [Lockbox setString:@"FALSE" forKey:kLoggedinStatusKeyString];
    [(TabBarViewController *)[self tabBarController] loginCheck:self.animateBOOL];
}
    
@end
