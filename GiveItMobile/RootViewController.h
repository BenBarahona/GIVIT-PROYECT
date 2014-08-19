//
//  RootViewController.h
//  GoogleCalendar
//
//  Created by Dan Bourque on 4/26/09.
//  Copyright Dan Bourque 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataCalendar.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"

// These keys are used to lookup elements in our dictionaries.
#define KEY_CALENDAR @"calendar"
#define KEY_EVENTS @"events"
#define KEY_TICKET @"ticket"
#define KEY_EDITABLE @"editable"

// Forward declaration of the editing view controller's class for the compiler.
@class EditingViewController;

@protocol gmailEventSyncDelegate <NSObject>

@optional
-(void)gmailsSyncComplete;
@end

@interface RootViewController : UIViewController{
  UINavigationBar* navigationBar;
    NSMutableArray *data;
    NSMutableArray *arraylist;
    NSDictionary *eventListdictionary;
    NSString *str;
    int flag,completeFlag;
  GDataServiceGoogleCalendar *googleCalendarService;
  EditingViewController *editingViewController;
}

// We declare accessor for the googleCalendarService because we need to access it from the EditingViewController class.
@property (nonatomic, retain) GDataServiceGoogleCalendar *googleCalendarService;
@property (nonatomic, retain) NSString *gmailUserID;
@property (nonatomic, retain) NSString *gmailPassword;
@property (nonatomic,strong) id <gmailEventSyncDelegate> delegate;

- (void)refresh;
- (void)insertCalendarEvent:(GDataEntryCalendarEvent *)event toCalendar:(GDataEntryCalendar *)calendar;
- (void)updateCalendarEvent:(GDataEntryCalendarEvent *)event;
- (void)syncCalander : (NSDictionary *)detail;
@property (strong, nonatomic) IBOutlet UITextField *mGmailIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *mGmailPasswordTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
- (IBAction)didTapToSignInGmail:(id)sender;
- (IBAction)didTapToCancelGmailSign:(id)sender;
@end