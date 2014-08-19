//
//  GIM_ViewController.h
//  GiveItMobile
//
//  Created by Administrator on 19/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import "GIM_AppDelegate.h"
#import "GoogleOAuth.h"
#import <FacebookSDK/FacebookSDK.h>
#import "YOSSession.h"
#import "YOSRequestClient.h"

@interface GIM_ViewController : UIViewController <GIM_UserServiceDelegate, UITextFieldDelegate,GoogleOAuthDelegate,YOSRequestDelegate>{
    GIM_AppDelegate*appDelegate;
}

@property (nonatomic, strong) GoogleOAuth *googleOAuth;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIImageView *mCheckBoxImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indc;
@property (strong, nonatomic) IBOutlet UIView *mGmailLoginView;

@property (nonatomic, readwrite, retain) YOSSession *sessionYahoo;
@property (nonatomic, readwrite, retain) NSMutableDictionary *oauthResponse;
- (IBAction)btnKeepMeLoggedIn:(id)sender;
- (IBAction)btnForgotPassword:(id)sender;
- (IBAction)didTapGmailSignIn:(id)sender;
- (IBAction)didTapToCancelGmailSign:(id)sender;
- (IBAction)didTapToFBLogin:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)didTapNewRegistration:(id)sender;
-(NSString *) validateLogin;
- (IBAction)didTapYahooLogin:(id)sender;




@end
