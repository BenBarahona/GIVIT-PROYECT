//
//  GIM_BuyGiftCardUploadViewController.h
//  GiveItMobile
//
//  Created by Administrator on 26/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_PayementViewController.h"
#import "GIM_Eventlist.h"


@interface GIM_BuyGiftCardUploadViewController : UIViewController<UITextViewDelegate,customTabControlDelegate>
@property (strong, nonatomic) NSMutableDictionary *paymentDict;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
- (IBAction)continueButton:(id)sender;
- (IBAction)didTapToUpload:(id)sender;
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapGivitLater:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet UITextView *messageTextField;

@end
