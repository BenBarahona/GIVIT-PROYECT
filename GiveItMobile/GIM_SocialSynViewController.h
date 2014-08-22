//
//  GIM_SocialSynViewController.h
//  GiveItMobile
//
//  Created by Administrator on 20/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FbMethods.h"
#import <AddressBook/AddressBook.h>
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"
#import "YOSSession.h"
#import "YOSRequestClient.h"
#import "LinkedINAPIFunction.h"

enum SYNC_OPTIONS
{
    SYNC_CONTACTS = 1,
    SYNC_FACEBOOK = 2,
    SYNC_LINKEDIN = 3,
    SYNC_GMAIL = 4,
    SYNC_YAHOO = 5
};
@protocol socialLoginDelegate <NSObject>

@optional
-(void)didFinishSync : (NSString *)ContactType;

@end

@interface GIM_SocialSynViewController : UIViewController<LinkedINAPIFunctionDelegates,FbMethodsDelegate>{
    NSString *syncType;
}
@property (nonatomic, readwrite, retain) YOSSession *sessionYahoo;
@property (nonatomic, readwrite, retain) NSMutableDictionary *oauthResponse;
@property (nonatomic,strong) id <socialLoginDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *button;
@property (strong, nonatomic) IBOutlet UITextField *mGmailIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *mGmailPasswordTextField;
@property (strong, nonatomic) IBOutlet UIView *mGmailLoginView;

@property (nonatomic, assign) enum SYNC_OPTIONS selectedOption;

- (IBAction)btnContinue:(id)sender;
- (IBAction)didTapToFacebookLoggin:(id)sender;
- (IBAction)didTapToFetchLocalContacts:(id)sender;
- (IBAction)didTapToFetchLinkedInContacts:(id)sender;
- (IBAction)didTapToFetchYahooContact:(id)sender;
- (IBAction)didTapToFetchGmailContacts:(id)sender;
- (IBAction)didTapToSignInGmail:(id)sender;
- (IBAction)didTapToCancelGmailSign:(id)sender;

@end
