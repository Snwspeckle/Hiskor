//
//  TextInputCell.m
//  Hiskor Admin
//
//  Created by SuchyMac3 on 3/8/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "TextInputCell.h"

@implementation TextInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[VerticallyCenteredTextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [_textField setFrame:CGRectMake(10, 0, frame.size.width - 30, frame.size.height)];
}

@end
