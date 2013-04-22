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

@property (nonatomic, assign) BOOL animateBOOL;
@property (strong, nonatomic) NSMutableOrderedSet *games;
@property (nonatomic, strong) NSString *sportType;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (void)reloadTable;

@end
