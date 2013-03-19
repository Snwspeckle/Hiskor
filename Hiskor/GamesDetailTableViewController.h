//
//  GamesDetailTableViewController.h
//  Hiskor
//
//  Created by Quandt Family on 3/14/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingManager.h"

@interface GamesDetailTableViewController : UITableViewController <NetworkingResponseHandler>

@property (strong, nonatomic) NSString *ticketData;
@property (strong, nonatomic) NSDictionary *gameData;
@property (assign, nonatomic) BOOL ticketLoaded;
@property (assign, nonatomic) BOOL ticketOwned;
@property (strong, nonatomic) UITableViewCell *showQRCodeCell;

@end
