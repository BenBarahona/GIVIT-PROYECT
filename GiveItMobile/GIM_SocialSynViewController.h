//
//  GIM_SocialSynViewController.h
//  GiveItMobile
//
//  Created by Administrator on 20/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"
#import "YOSSession.h"
#import "YOSRequestClient.h"
#import "LinkedINAPIFunction.h"
@protocol socialLoginDelegate <NSObject>

@optional
-(void)didFinishSync : (NSString *)ContactType;

@end

@interface GIM_SocialSynViewController : UIViewController<LinkedINAPIFunctionDelegates>{
    NSString *syncType;
}
@property (nonatomic, readwrite, retain) YOSSession *sessionYahoo;
@property (nonatomic, readwrite, retain) NSMutableDictionary *oauthResponse;
@property (nonatomic,strong) id <socialLoginDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *button;
@property (strong, nonatomic) IBOutlet UITextField *mGmailIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *mGmailPasswordTextField;
@property (strong, nonatomic) IBOutlet UIView *mGmailLoginView;

- (IBAction)btnContinue:(id)sender;
- (IBAction)didTapToFacebookLoggin:(id)sender;
- (IBAction)didTapToFetchLocalContacts:(id)sender;
- (IBAction)didTapToFetchLinkedInContacts:(id)sender;
- (IBAction)didTapToFetchYahooContact:(id)sender;
- (IBAction)didTapToFetchGmailContacts:(id)sender;
- (IBAction)didTapToSignInGmail:(id)sender;
- (IBAction)didTapToCancelGmailSign:(id)sender;

@end
