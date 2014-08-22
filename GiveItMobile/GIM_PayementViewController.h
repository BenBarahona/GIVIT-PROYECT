//
//  GIM_PayementViewController.h
//  GiveItMobile
//
//  Created by Administrator on 26/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserController.h"
#import "GIM_UserModel.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"

@interface GIM_PayementViewController : UIViewController<GIM_UserServiceDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
    NSArray *cardNameArray;
    BOOL isSelected;
    UITextField *flagTextField;
    NSString *originalCardNo;
    NSMutableDictionary *cardDetail;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (strong, nonatomic) NSMutableDictionary *paymentDict;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *label;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UILabel *mDueLabel;
@property (weak, nonatomic) IBOutlet UITextField *mCardTypeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *mCardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *mCvvNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *mExpiryDateTextField;
@property (weak, nonatomic) IBOutlet UIImageView *mCheckBoxImageView;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *mNameOnCard;


@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (weak, nonatomic) IBOutlet UIView *mPickerView;
- (IBAction)didTapToSelectDate:(id)sender;
- (IBAction)didTapToCancelDate:(id)sender;


- (IBAction)buyNsendButton:(id)sender;
- (IBAction)didTapToOpenCardNumber:(id)sender;
- (IBAction)didTapToOpenExpiaryDate:(id)sender;
- (IBAction)didTapToSelectCheckBox:(id)sender;

@end
