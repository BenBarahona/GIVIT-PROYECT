//
//  GIM_Events.h
//  GiveItMobile
//
//  Created by Bhaskar on 06/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "NSDate+convenience.h"
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"
#import "FbMethods.h"
@interface GIM_Events : UIViewController<FbMethodsDelegate>{
    NSDate *selectedDate;
    VRGCalendarView *calendar;
    int currentMonth,currentYear;
    NSString *dateString;
}
@property (strong, nonatomic) NSMutableArray *totalEvent;
@property (strong, nonatomic) NSMutableDictionary *paymentDict;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;

- (IBAction)didTapTosyncFacebookEvent:(id)sender;
- (IBAction)didTapToSyncGoogleEvent:(id)sender;
-(void)gotoAddNewEvent;
@property (strong, nonatomic) IBOutlet UIImageView *mAddEvent;
@property (strong, nonatomic) IBOutlet UIView *mAddEventView;
@property (strong, nonatomic) IBOutlet UITableView *mTimeZoneTableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (strong, nonatomic) IBOutlet UIView *mPickerView;
@property (strong, nonatomic) IBOutlet UITextField *mTitleTextField;
@property (strong, nonatomic) IBOutlet UITextField *mDescriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *mDurationTextField;
@property (strong, nonatomic) IBOutlet UITextField *mLocationTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;

- (IBAction)didTapToSelectDate:(id)sender;
- (IBAction)didTapToCancelDate:(id)sender;
- (IBAction)didTapToOpenDatePicker:(id)sender;
- (IBAction)didTapAddEvent:(id)sender;
- (IBAction)didTapClose:(id)sender;

@end
