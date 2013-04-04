//
//  GamesTableViewCell.m
//  Hiskor
//
//  Created by SuchyMac3 on 2/28/13.
//  Copyright (c) 2013 ITP. All rights reserved.
//

#import "GamesTableViewCell.h"

@implementation GamesTableViewCell
@synthesize homeLabel, awayLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
