//
//  LoginViewController.h
//  Hiskor
//
//  Created by SuchyMac3 on 1/29/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)btnLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *fldUsername;
@property (strong, nonatomic) IBOutlet UITextField *fldPassword;

@end
