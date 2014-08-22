//
//  GIM_GiftOfDayViewController.h
//  GiveItMobile
//
//  Created by Administrator on 02/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import "GIM_GiveGiftCard_SelectContactViewController.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"
#import "NSString+HTML.h"
@interface GIM_GiftOfDayViewController : UIViewController<GIM_UserServiceDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    UITextField *flagTextField;
    NSMutableDictionary *paymentDict;
}

-(void)loadGiftCard;
@property (strong, nonatomic) NSMutableDictionary *day_item;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *savingLabel;
@property (strong, nonatomic) IBOutlet UILabel *givitLabel;
@property (strong, nonatomic) IBOutlet UIImageView *GiftOfDayImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indc;
- (IBAction)buyButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *mTargetGiftCard;
@property (weak, nonatomic) IBOutlet UILabel *mDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *mDescriptionTextView;


@end
