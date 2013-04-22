//
//  GamesDetailTableViewController.h
//  Hiskor
//
//  Created by Quandt Family on 3/14/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingManager.h"

@interface GamesDetailTableViewController : UITableViewController <NetworkingResponseHandler, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *ticketData;
@property (strong, nonatomic) NSDictionary *gameData;
@property (assign, nonatomic) BOOL ticketLoaded;
@property (assign, nonatomic) BOOL ticketOwned;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *ticketLabel;

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *homeLabel;
@property (nonatomic, strong) IBOutlet UILabel *awayLabel;
@property (nonatomic, strong) IBOutlet UILabel *ticketsLeftLabel;

@end
