//
//  GIM_Eventlist.h
//  GiveItMobile
//
//  Created by Bhaskar on 08/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_AddEvent.h"
#import "GIM_PayementViewController.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"

@interface GIM_Eventlist : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray *totalEvent,*totalTimeZone,*demoTimeZone;
    NSString *dateString;
}
@property (strong, nonatomic) NSMutableDictionary *paymentDict;
@property (strong, nonatomic) NSDate *currentDate;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mEventActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UITextField *mTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *mDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *mDurationTextField;
@property (weak, nonatomic) IBOutlet UITextField *mLocationTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *mAddEvent;
@property (weak, nonatomic) IBOutlet UIView *mAddEventView;
@property (weak, nonatomic) IBOutlet UITableView *mTimeZoneTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (weak, nonatomic) IBOutlet UIView *mPickerView;

- (IBAction)didTapToSelectDate:(id)sender;
- (IBAction)didTapToCancelDate:(id)sender;
- (IBAction)didTapToOpenDatePicker:(id)sender;
- (IBAction)didTapAddEvent:(id)sender;
- (IBAction)didTapClose:(id)sender;
-(void)gotoAddNewContact;
@end
