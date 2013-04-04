//
//  VerticallyCenteredTextField.m
//  Hiskor Admin
//
//  Created by SuchyMac3 on 3/8/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "VerticallyCenteredTextField.h"

@implementation VerticallyCenteredTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, 0, self.frame.size.height / 4);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds, 0, self.frame.size.height / 4);
}

@end
