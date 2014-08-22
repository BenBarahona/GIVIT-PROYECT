//
//  GiftCardCell.h
//  GiveItMobile
//
//  Created by Administrator on 23/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *mGiftCellImageView;
@property (strong, nonatomic) IBOutlet UILabel *mGiftCellGiftedByLabel;
@property (strong, nonatomic) IBOutlet UILabel *mGiftCardBalanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mGiftCellUserImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *mCardAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCardValue;
@property (weak, nonatomic) IBOutlet UILabel *mBalance;
@property (weak, nonatomic) IBOutlet UILabel *retailerNameLabel;

@end
