//
//  RegisterViewController.h
//  Hiskor
//
//  Created by SuchyMac3 on 1/30/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkingManager.h"
#import "TextInputCell.h"
@interface RegisterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NetworkingResponseHandler, UITextFieldDelegate>

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnRegister:(id)sender;

@property (nonatomic, assign) BOOL shouldScrollToTop;

@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *inputTableView;
@property (strong, nonatomic) TextInputCell *firstNameCell;
@property (strong, nonatomic) TextInputCell *lastNameCell;
@property (strong, nonatomic) TextInputCell *emailCell;
@property (strong, nonatomic) TextInputCell *confirmEmailCell;
@property (strong, nonatomic) TextInputCell *passwordCell;
@property (strong, nonatomic) TextInputCell *confirmPasswordCell;

@end
