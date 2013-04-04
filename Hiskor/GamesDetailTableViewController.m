//
//  GamesDetailTableViewController.m
//  Hiskor
//
//  Created by Quandt Family on 3/14/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "GamesDetailTableViewController.h"
#import "QRCodeViewController.h"
#import "Lockbox.h"

@interface GamesDetailTableViewController ()

@end

@implementation GamesDetailTableViewController

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.ticketOwned = NO;
	self.ticketLoaded = NO;
	self.navigationItem.title = [[[self.gameData valueForKey:@"homeSchool"] stringByAppendingString:@" vs. "] stringByAppendingString:[self.gameData valueForKey:@"awaySchool"]];
	//self.navigationItem.backBarButtonItem.
	//NSLog(@"Ticket: %@", _ticketData);
	[self loadTicket];
	
}

- (void)loadTicket {
	
	NSString *userID = [Lockbox stringForKey:kUserIDKeyString];
	NSString *type = @"clientGameTickets";
	NSString *gameID = [self.gameData objectForKey:@"gameID"];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
							userID, @"userID",
							gameID, @"gameID",
							type, @"type",
							nil];
	
	[NetworkingManager sendDictionary:params responseHandler:self];

}

/*- (void)refresh {
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
    [activityIndicator startAnimating];
	
	
	NSString *userID = [Lockbox stringForKey:kUserIDKeyString];
	NSString *type = @"clientGameTickets";
	NSString *gameID = [self.gameData objectForKey:@"gameID"];
	
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
							userID, @"userID",
							gameID, @"gameID",
							type, @"type",
							nil];
	
	[NetworkingManager sendDictionary:params responseHandler:self];
}*/

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {
	
	if ([[response valueForKeyPath:@"message"] isEqualToString:@"None"]) {
		
		[self navigationItem].rightBarButtonItem = nil;

		NSLog(@"No Ticket Owned:");
		NSLog(@"Response: %@", response);
		
		self.ticketOwned = NO;
		self.ticketLoaded = YES;
		self.ticketData = @"";
		[self.tableView reloadData];
	}
	else if ([[response valueForKeyPath:@"message"] isEqualToString:@"Success"]) {
		
		[self navigationItem].rightBarButtonItem = nil;
		
		NSLog(@"Ticket Loaded");
		NSLog(@"Response: %@", response);
		self.ticketOwned = YES;
		self.ticketLoaded = YES;
		self.ticketData = [response objectForKey:@"ticket"];
		[self.tableView reloadData];

	}
	else {
		
		NSLog(@"Ticket Load Failed:");
		NSLog(@"Response: %@", response);
		
		UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Game Data" message:@"Server denied request" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[loginAlert show];
		
	}

}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
	
	
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GamesDetailTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	// Customize cell
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		if (self.ticketLoaded) {
			if (self.ticketOwned) {
				cell.textLabel.text = @"Show QR Code";
			}
			else {
				cell.textLabel.text = @"Buy Ticket";
			}
		}
		else {
			UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(30, 0, 20, 20)];
			cell.accessoryView = activityIndicator;
		}
		self.showQRCodeCell = cell;
	}
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0 && self.ticketOwned) {
		if (self.ticketLoaded && self.ticketOwned) {
			QRCodeViewController *qrCodeViewController = [[QRCodeViewController alloc] initWithNibName:@"QRCodeView" bundle:nil dataString:self.ticketData];
			[self presentModalViewController:qrCodeViewController animated:YES];
		}
		else {
			
		}
	}
}

@end
