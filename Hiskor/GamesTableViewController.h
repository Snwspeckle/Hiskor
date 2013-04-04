//
//  HomeTableViewController.h
//  Hiskor
//
//  Created by Anthony on 2/1/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingManager.h"
#import "PullRefreshTableViewController.h"

@interface GamesTableViewController : PullRefreshTableViewController <NetworkingResponseHandler>
{
	NSMutableArray *items;
}

- (IBAction)btnLogout:(id)sender;
- (void)refresh;

@property (nonatomic, assign) BOOL animateBOOL;
@property (strong, nonatomic) NSMutableOrderedSet *games;

@end
