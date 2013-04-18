//
//  SettingsViewController.h
//  Hiskor
//
//  Created by Quandt Family on 3/5/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingManager.h"

@interface SettingsViewController : UITableViewController <NetworkingResponseHandler>

- (IBAction)btnLogout:(id)sender;
@property (nonatomic, assign) BOOL animateBOOL;

@end
