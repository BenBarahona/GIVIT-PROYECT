//
//  GIM_MyAccountViewController.h
//  GiveItMobile
//
//  Created by Administrator on 02/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"
#import "GIM_GiveGiftCard_SelectContactViewController.h"

@interface GIM_MyAccountViewController : UIViewController<GIM_UserServiceDelegate, UITextFieldDelegate, UIAlertViewDelegate,UIPickerViewDelegate>{
    UITextField *flagTextField;
    NSArray *cardNameArray;
    int flagDate;
    NSString *originalCardNo;
    NSDate *bDate;
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *button;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label;

@property (strong, nonatomic) IBOutlet UITextField *dobText;
@property (strong, nonatomic) IBOutlet UITextField *doaText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (strong, nonatomic) IBOutlet UITextField *nameOfCardText;
@property (strong, nonatomic) IBOutlet UITextField *cardNoText;
@property (strong, nonatomic) IBOutlet UITextField *cvvText;
@property (strong, nonatomic) IBOutlet UITextField *expiryDateText;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indc;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (weak, nonatomic) IBOutlet UIView *mPickerView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UITextField *mNameTextField;
- (IBAction)didTapToSelectDate:(id)sender;
- (IBAction)didTapToCancelDate:(id)sender;
- (IBAction)updateButton:(id)sender;
- (IBAction)didTapToaddBirthDate:(id)sender;
- (IBAction)didTapAddAneversary:(id)sender;
- (IBAction)didTapToSelectCardType:(id)sender;
- (IBAction)didTaptoSelectExpairyDate:(id)sender;

@end
