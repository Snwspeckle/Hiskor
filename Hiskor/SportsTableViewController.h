//
//  SportsTableViewController.h
//  Hiskor
//
//  Created by Landon on 4/21/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingManager.h"
#import "GamesTableViewController.h"

@interface SportsTableViewController : UITableViewController //<NetworkingResponseHandler>

@property (nonatomic, strong) NSMutableArray *sports;
@property (nonatomic, strong) GamesTableViewController *nextViewController;
@end
