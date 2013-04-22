//
//  SportsTableViewController.m
//  Hiskor
//
//  Created by Landon on 4/21/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "SportsTableViewController.h"
#import "SportsTableViewCell.h"

@interface SportsTableViewController ()

@end

@implementation SportsTableViewController

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

    self.sports = [[NSMutableArray alloc] initWithObjects:@"Baseball", @"Basketball", @"Football", @"Volleyball", @"Wrestling", nil];
 
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - NetworkingResponseHandler Protocol Methods

- (void)networkingResponseReceived:(id)response ForMessage:(NSDictionary *)message {
	
	[self.sports stopLoading];
	
	if ([[response valueForKeyPath:@"message"] isEqualToString:@"Success"]) {
		
		NSLog(@"Games recived:");
		NSLog(@"response: %@", response);
		
		self.sports = [[response objectForKey:@"games"] mutableCopy];
		
	}
	else {
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
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	self.nextViewController = [segue destinationViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sports count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SportsTableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	((SportsTableViewCell *)cell).sportLabel.text = [self.sports objectAtIndex:indexPath.row];
	
    return cell;
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
    return view;
}

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
	self.nextViewController.sportType = [self.sports objectAtIndex:indexPath.row];
}

@end
