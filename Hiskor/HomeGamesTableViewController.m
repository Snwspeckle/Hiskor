//
//  HomeGameTableViewController.m
//  Hiskor
//
//  Created by Landon on 4/21/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "HomeGamesTableViewController.h"

@interface HomeGamesTableViewController ()

@end

@implementation HomeGamesTableViewController

- (void)reloadTable {
	
	NSString *homeSchool = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeSchoolPreference"] objectForKey:@"schoolName"];
	
	for (int i = 0; i < [self.games count]; i++) {
		NSString *gameHomeSchool = [[self.games objectAtIndex:i] objectForKey:@"homeSchool"];
		if (![gameHomeSchool isEqualToString:homeSchool]) {
			[self.games removeObjectAtIndex:i--];
		}
	}
	[super reloadTable];
}

@end
