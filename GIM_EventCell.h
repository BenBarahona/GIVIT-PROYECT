//
//  GIM_EventCell.h
//  GiveItMobile
//
//  Created by Bhaskar on 08/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GIM_EventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *mCheckButton;
@end
