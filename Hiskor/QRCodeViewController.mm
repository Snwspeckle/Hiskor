//
//  QRCodeViewController.m
//  Hiskor
//
//  Created by Quandt Family on 3/14/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "QRCodeViewController.h"
#import <QREncoder.h>
#import <DataMatrix.h>

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataString:(NSString *)data {
	
   	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		
		self.dataString = data;
	}
	return self;
}

- (void)viewDidLoad {
	
	int size = self.qrCodeImageView.frame.size.height;
	
	//first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
	DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:self.dataString];
	
	//then render the matrix
	UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:size];
	
	//put the image into the view
	self.qrCodeImageView.image = qrcodeImage;
	CGRect parentFrame = self.view.frame;
	CGRect toolbarFrame = self.toolbar.frame;
	
	//center the image
	CGFloat x = (parentFrame.size.width - size) / 2.0;
	CGFloat y = (parentFrame.size.height - size - toolbarFrame.size.height) / 2.0;
	CGRect qrcodeImageViewFrame = CGRectMake(x, y, size, size);
	[self.qrCodeImageView setFrame:qrcodeImageViewFrame];
	
	self.label.text = self.dataString;
}

- (IBAction)doneButtonPressed {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
