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

- (void)setGameData:(NSDictionary *)gameData {
	if (gameData != _gameData) {
		_gameData = gameData;
		
		self.navigationItem.title = [[[self.gameData valueForKey:@"homeSchool"] stringByAppendingString:@" vs. "] stringByAppendingString:[self.gameData valueForKey:@"awaySchool"]];
		
		[self loadTicket];
		
		[self reloadData];
	}
}

- (void)reloadData {
	
	NSString *dateString = [self.gameData valueForKey:@"gameDate"];
	
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	self.dateLabel.text = [dateFormatter stringFromDate:date];
	
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
	[timeFormatter setDateStyle:NSDateFormatterNoStyle];
	[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	self.timeLabel.text = [timeFormatter stringFromDate:date];
	
	self.homeLabel.text = [self.gameData valueForKey:@"homeSchool"];
	self.awayLabel.text = [self.gameData valueForKey:@"awaySchool"];
	self.ticketsLeftLabel.text = [self.gameData valueForKey:@"numberOfTickets"];
}

- (void)loadTicket {
	
	self.ticketOwned = NO;
	self.ticketLoaded = NO;
	
	[self.activityIndicator startAnimating];
	
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
	
	[self.activityIndicator stopAnimating];
	
	if ([[message objectForKey:@"type"] isEqualToString:@"clientGameTickets"]) {
		if ([[response valueForKeyPath:@"message"] isEqualToString:@"None"]) {
			
			[self navigationItem].rightBarButtonItem = nil;
			
			NSLog(@"No Ticket Owned:");
			NSLog(@"Response: %@", response);
			
			self.ticketOwned = NO;
			self.ticketLoaded = YES;
			self.ticketData = @"";
			if ([self.gameData objectForKey:@"numberOfTickets"] > 0) {
				self.ticketLabel.text = @"Purchase Ticket";
			}
			else {
				self.ticketLabel.text = @"Sold Out";
			}
		}
		else if ([[response valueForKeyPath:@"message"] isEqualToString:@"Success"]) {
			
			[self navigationItem].rightBarButtonItem = nil;
			
			NSLog(@"Ticket Loaded");
			NSLog(@"Response: %@", response);
			self.ticketOwned = YES;
			self.ticketLoaded = YES;
			self.ticketData = [response objectForKey:@"ticket"];
			self.ticketLabel.text = @"Show Ticket";
			
		}
		else {
			
			if ([self.ticketLabel.text isEqualToString:@""] || [self.ticketLabel.text isEqualToString:@"Loading..."]) {
				
				self.ticketLabel.text = @"Ticket Not Loaded";
			}
			
			NSLog(@"Ticket Load Failed:");
			NSLog(@"Response: %@", response);
			
			UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Ticket Data" message:@"Server denied request" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			
			[loginAlert show];
			
		}
	}
	else if ([[message objectForKey:@"type"] isEqualToString:@"purchaseTicket"]) {
		if ([[response objectForKey:@"message"] isEqualToString:@"Success"]) {
			
			self.ticketData = [[response objectForKey:@"ticket"] objectForKey:@"ticketCode"];
			self.ticketOwned = YES;
			self.ticketLoaded = YES;
			self.ticketLabel.text = @"Show Ticket";
			[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
			
			NSMutableDictionary *tempGameData = [self.gameData mutableCopy];
			
			NSNumber *ticketsRemaining = [[NSNumberFormatter new] numberFromString:[tempGameData objectForKey:@"numberOfTickets"]];
			
			NSString *ticketsRemainingString = [[NSNumber numberWithInt:[ticketsRemaining intValue] - 1] stringValue];
			
			[tempGameData setObject:ticketsRemainingString forKey:@"numberOfTickets"];
			
			self.gameData = tempGameData;
			
			[self reloadData];
		}
		else {
			NSLog(@"Ticket Purchase Failed:");
			NSLog(@"Response: %@", response);
			
			UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Purchasing Ticket" message:@"Server denied request" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			
			[loginAlert show];
		}
	}
}

- (void)networkingResponseFailedForMessage:(NSDictionary *)message error:(NSError *)error {
	
	[self.activityIndicator stopAnimating];
	
	if ([self.ticketLabel.text isEqualToString:@""] || [self.ticketLabel.text isEqualToString:@"Loading..."]) {
		self.ticketLabel.text = @"Ticket Not Loaded";
	}
	
	UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Error Loading Ticket Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[loginAlert show];
	
	NSLog(@"Error with request");
	NSLog(@"%@", [error localizedDescription]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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
	}
    
    return cell;
}

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		
		[self.activityIndicator startAnimating];
		
		NSString *userID = [Lockbox stringForKey:kUserIDKeyString];
		NSString *type = @"purchaseTicket";
		NSString *gameID = [self.gameData objectForKey:@"gameID"];
		
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
								userID, @"userID",
								gameID, @"gameID",
								type, @"type",
								nil];
		[NetworkingManager sendDictionary:params responseHandler:self];
	}
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0 && indexPath.row == 0) {
		if (self.ticketLoaded) {
			if (self.ticketOwned) {
				QRCodeViewController *qrCodeViewController = [[QRCodeViewController alloc] initWithNibName:@"QRCodeView" bundle:nil dataString:self.ticketData];
				[self presentModalViewController:qrCodeViewController animated:YES];
			}
			else if ([self.gameData objectForKey:@"numberOfTickets"] > 0) {
				UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Confirm Purchase" message:@"Are you sure you would like to buy a ticket for $4.99" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
				
				[loginAlert show];
			}
		}
	}
}

@end
