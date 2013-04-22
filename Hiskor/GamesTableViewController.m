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

@end

@implementation GamesTableViewController
@synthesize animateBOOL;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.games = [[NSMutableOrderedSet alloc] init];
	
	if ([[Lockbox stringForKey:@"LoggedinStatusKeyString"] isEqualToString:@"TRUE"]) {
		
		self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[self.activityIndicator startAnimating];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];

		[self loadGames];
    }
}

- (void)refresh {
    [self performSelector:@selector(loadGames) withObject:nil afterDelay:0.3];
}

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
		
	for (int i = 0; i < [self.games count]; i++) {
		if (![[[self.games objectAtIndex:i] objectForKey:@"sportType"] isEqualToString:self.sportType]) {
			[self.games removeObjectAtIndex:i--];
		}
	}
		
	if ([self.games count] > 0) {

		[self.tableViewSections addObject:[[NSMutableArray alloc] init]];
		
		[self.games sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
			NSTimeInterval time1 = [[obj1 objectForKey:@"gameDate"] longLongValue];
			NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
			NSTimeInterval time2 = [[obj2 objectForKey:@"gameDate"] longLongValue];
			NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2];
			return [date1 compare:date2];
		}];
		
		int section = 0;
		
		[[self.tableViewSections objectAtIndex:0] addObject:[self.games objectAtIndex:0]];
		
		for (int i = 1; i < [self.games count]; i++) {
			NSDictionary *game = [self.games objectAtIndex:i];
							
			NSString *dateString = [game valueForKey:@"gameDate"];
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]];
			NSString *lastDateString = [[[self.tableViewSections objectAtIndex:[self.tableViewSections count] - 1] objectAtIndex:0] valueForKey:@"gameDate"];
			NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[lastDateString longLongValue]];
			NSCalendar *calander = [NSCalendar currentCalendar];
			NSDateComponents *components = [calander components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
			NSDateComponents *lastComponents = [calander components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:lastDate];
			if (!([components year] == [lastComponents year] && [components month] == [lastComponents month] && [components day] == [lastComponents day])) {
				[self.tableViewSections addObject:[[NSMutableArray alloc] init]];
				section++;
			}

			[[self.tableViewSections objectAtIndex:section] addObject:game];
		}
	}
	[self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetworkingResponseHandler Protocol Methods

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {
	
	[self stopLoading];
	[self.activityIndicator stopAnimating];

	if ([[response valueForKeyPath:@"message"] isEqualToString:@"Success"]) {
				
		NSLog(@"Games recived:");
		NSLog(@"response: %@", response);
		
		self.games = [[response objectForKey:@"games"] mutableCopy];
		
		[self reloadTable];
	}
	else {
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Game Data" message:@"Server denied request" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[loginAlert show];
		
	}
}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
	
	[self stopLoading];
	[self.activityIndicator stopAnimating];

	UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Game Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[loginAlert show];

	NSLog(@"Error with request");
	NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.tableViewSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.tableViewSections objectAtIndex:section] count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int rowNumber = [self.games indexOfObject:[[self.tableViewSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
	
    if (rowNumber % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *dateString = [[[self.tableViewSections objectAtIndex:section] objectAtIndex:0] valueForKey:@"gameDate"];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]];
	
	return [dateFormatter stringFromDate:date];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GamesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSDictionary *game = [[self.tableViewSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	//cell.textLabel.text = [[[game valueForKey:@"homeSchool"] stringByAppendingString:@" vs. "] stringByAppendingString:[game valueForKey:@"awaySchool"]];
	
	[[cell homeLabel] setText:[game valueForKey:@"homeSchool"]];
    [[cell awayLabel] setText:[game valueForKey:@"awaySchool"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.nextViewController.gameData = [[self.tableViewSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"QRTicket"]) {
		self.nextViewController = [segue destinationViewController];
	}
}
    
@end
