//
//  SettingsViewController.h
//  Hiskor
//
//  Created by Quandt Family on 3/5/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingManager.h"

@interface SettingsViewController : UITableViewController <NetworkingResponseHandler, UIPickerViewDelegate, UIPickerViewDataSource>

- (IBAction)btnLogout:(id)sender;

- (IBAction)stayLoggedInSwitchChanged;

@property (nonatomic, assign) BOOL schoolsLoaded;
@property (nonatomic, strong) IBOutlet UISwitch *stayLoggedInSwitch;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *schools;

@end
