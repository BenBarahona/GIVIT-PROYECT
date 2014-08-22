//
//  GIM_MyMessageCell.m
//  GiveItMobile
//
//  Created by Bhaskar on 09/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_MyMessageCell.h"

@implementation GIM_MyMessageCell

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

- (IBAction)didTapCheckButton:(id)sender {
    if (self.delegate) {
        [self.delegate checkButtonClickedwithTag:[(UIButton *)sender tag]];
    }
}

- (IBAction)didTapGotoButton:(id)sender {
    if (self.delegate) {
        [self.delegate gotoButtonClickedwithTag:[(UIButton *)sender tag]];
    }
}
@end
