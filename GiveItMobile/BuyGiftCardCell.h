//
//  BuyGiftCardCell.h
//  GiveItMobile
//
//  Created by Administrator on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface BuyGiftCardCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *buyGiftCellImageView;
@property (strong, nonatomic) IBOutlet UILabel *buyGiftCardLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;

@end
