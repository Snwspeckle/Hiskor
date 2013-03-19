//
//  QRCodeViewController.h
//  Hiskor
//
//  Created by Quandt Family on 3/14/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

@property (strong, nonatomic) NSString *dataString;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataString:(NSString *)data;
- (IBAction)doneButtonPressed;

@end
