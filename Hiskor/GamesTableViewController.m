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
#import "GamesTableViewCell.h"

@interface GamesTableViewController ()

@property (strong, nonatomic) GamesDetailTableViewController *nextViewController;
@property (nonatomic, strong) NSMutableArray *tableViewSections;

- (void)reloadTable;

@end

@implementation GamesTableViewController
@synthesize animateBOOL;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.games = [[NSMutableOrderedSet alloc] init];
	/*if ([[Lockbox stringForKey:@"LoggedinStatusKeyString"] isEqualToString:@"TRUE"]) {
        [self loadGames];
    }*/
	
	[self startLoading];

	[self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];

}

/*- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}*/

- (void)loadGames {
	NSLog(@"UserID: %@", [Lockbox stringForKey:kUserIDKeyString]);
	NSString *userID = [Lockbox stringForKey:kUserIDKeyString];
	NSString *type = @"clientGames";
	
	NSDictionary *parmas = [NSDictionary dictionaryWithObjectsAndKeys:
							userID, @"userID",
							type, @"type",
							nil];
	
	[NetworkingManager sendDictionary:parmas responseHandler:self];
}

- (void)reloadTable {
	
	self.tableViewSections = [[NSMutableArray alloc] init];
	
	if ([self.games count] > 0) {
		[self.games sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
			NSTimeInterval time1 = [[obj1 objectForKey:@"gameDate"] integerValue];
			NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
			NSTimeInterval time2 = [[obj2 objectForKey:@"gameDate"] integerValue];
			NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2];
			return [date1 compare:date2];
		}];
		[self.tableViewSections addObject:[[NSMutableArray alloc] init]];
		
		int section = 0;
		
		[[self.tableViewSections objectAtIndex:0] addObject:[self.games objectAtIndex:0]];
		
		for (int i = 1; i < [self.games count]; i++) {
			NSDictionary *game = [self.games objectAtIndex:i];
			
			// increment section date is deifferent from previous
			
			if ([self.tableViewSections count] < section) {
				
				[self.tableViewSections addObject:[[NSMutableArray alloc] init]];
			}
			[[self.tableViewSections objectAtIndex:section] addObject:game];
		}
	}
	[self.tableView reloadData];
}

/*- (void)refresh {
 
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
 }*/

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {
	
	[self stopLoading];
	
	if ([[response valueForKeyPath:@"message"] isEqualToString:@"Success"]) {
		
		[self navigationItem].rightBarButtonItem = nil;
		
		NSLog(@"Games recived:");
		NSLog(@"response: %@", response);
		
		[self.games addObjectsFromArray:[response objectForKey:@"games"]];
		[self reloadTable];
	}
	else {
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Game Data" message:@"Server denied request" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[loginAlert show];
		
	}
}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
	
	[self stopLoading];

	UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Game Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[loginAlert show];

	NSLog(@"Error with request");
	NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    [self performSelector:@selector(addItem) withObject:nil afterDelay:0.3];
}

- (void)addItem {
    // Add a new time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    [items insertObject:[NSString stringWithFormat:@"%@", now] atIndex:0];
    
    [self loadGames];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Header";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	UIView *view = nil;
	if (section >= [self numberOfSectionsInTableView:tableView] - 1) {
		view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
		view.backgroundColor = [UIColor whiteColor];
	}
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *game =  [self.games objectAtIndex:indexPath.row];
	
	//cell.textLabel.text = [[[game valueForKey:@"homeSchool"] stringByAppendingString:@" vs. "] stringByAppendingString:[game valueForKey:@"awaySchool"]];
	
	[[cell homeLabel] setText:[game valueForKey:@"homeSchool"]];
    [[cell awayLabel] setText:[game valueForKey:@"awaySchool"]];
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
