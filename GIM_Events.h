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

@interface GIM_Events : UIViewController{
    NSDate *selectedDate;
    VRGCalendarView *calendar;
    int currentMonth,currentYear;
}
@property (strong, nonatomic) NSMutableArray *totalEvent;
@property (strong, nonatomic) NSMutableDictionary *paymentDict;
@property (strong, nonatomic) IBOutlet UIScrollView *mScrollView;

- (IBAction)didTapTosyncFacebookEvent:(id)sender;
- (IBAction)didTapToSyncGoogleEvent:(id)sender;

@end
