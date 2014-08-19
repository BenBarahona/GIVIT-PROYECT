//
//  GIM_SendContact.h
//  GiveItMobile
//
//  Created by Bhaskar on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GIM_SendContact : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *sendGiftCellImageView;
@property (strong, nonatomic) IBOutlet UILabel *sendGiftCardLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *sendCheckBoxImageView;

@end
