//
//  GIM_MyGiftCardDetailsViewController.h
//  GiveItMobile
//
//  Created by Administrator on 21/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"

@interface GIM_MyGiftCardDetailsViewController : UIViewController
@property (nonatomic, strong) NSString *idd;
@property (strong, nonatomic) NSMutableDictionary *detailDict;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *boldLabel;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;@property (strong, nonatomic) IBOutlet UILabel *lblReceivedFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblAsOf;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Balance;
@property (weak, nonatomic) IBOutlet UIImageView *mBarCodeImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *mBarcodeNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *mDescriptionTextView;

- (IBAction)btn_HowToRedeem:(id)sender;
- (IBAction)btn_TermsNCondition:(id)sender;




@end
