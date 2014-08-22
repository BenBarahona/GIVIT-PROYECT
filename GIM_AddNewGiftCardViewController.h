//
//  GIM_AddNewGiftCardViewController.h
//  GiveItMobile
//
//  Created by Administrator on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserController.h"
#import "GIM_UserModel.h"
#import "NSString+HTML.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"


@interface GIM_AddNewGiftCardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GIM_UserServiceDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *itemGiftCardDetails,*otherGiftCardDetails;
    NSString *re_id;
    int dateFlag;
    UITextField *flagTextField;
    NSDate *purchaseDate,*expairyDate;
}

@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
- (IBAction)checkBox:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *ckeckBoxTableView;

@property (nonatomic, strong) NSString *idd;
@property (strong, nonatomic) NSMutableDictionary *detailDict;
@property (strong, nonatomic) IBOutlet UILabel *demoLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *couponNoText;
- (IBAction)submitButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *retailerNameText;
@property (strong, nonatomic) IBOutlet UITextField *cardCodeText;
@property (strong, nonatomic) IBOutlet UITextField *purchaseDateText;
@property (strong, nonatomic) IBOutlet UITextField *expiryDateText;
@property (strong, nonatomic) IBOutlet UITextField *amountText;
@property (weak, nonatomic) IBOutlet UIButton *mSubmitButton;
@property (weak, nonatomic) IBOutlet UIView *otherRetailerFormView;
//@property (weak, nonatomic) IBOutlet UIDatePicker *mDtePicker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (weak, nonatomic) IBOutlet UIView *mPickerView;
- (IBAction)didTapToSelectDate:(id)sender;
- (IBAction)didTapToCancelDate:(id)sender;

- (IBAction)scanBarCodeButton:(id)sender;

-(NSString *) validateOtherCoupon;
- (IBAction)didTapToEnterPurchaseDate:(id)sender;
- (IBAction)didTapToEnterExpairyDate:(id)sender;


@end
