//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@protocol InviteLinkedinFriendDelegate <NSObject>

-(void)inviteAndSendMessage;

@end

@protocol OAuthDelegate <NSObject>

-(void)TokenReceiveSuccessful : (OAToken *) token;
-(void)TokenReceiveFailed:(NSData*)error;
-(void)LoginSuccessful;
-(void)LoginFailed;
-(void)GetLinkedInContactsDidFinish:(NSMutableDictionary *)contacts;
-(void)GetLinkedInContactsDidFail:(NSData *)error;
-(void)GetLinkedInUserProfileDidFinish:(NSMutableDictionary *)contacts;
-(void)GetLinkedInUserProfileDidFail:(NSData *)error;
-(void)LinkedInMessagePostSuccessful;
-(void)LinkedInPostSuccessful;
-(void)LinkedInMessagePostFailed:(NSData *)error;
-(void)LinkedInPostFailed:(NSData *)error;

@optional
-(void)LogOutSuccessful;
-(void)LogOutFailed;


@end

@interface OAuthLoginView : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *addressBar;
    IBOutlet UILabel *lbl_just;
    OAToken *requestToken;
    OAToken *accessToken;
    
//    NSDictionary *profile;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
    OAConsumer *consumer;
    id <InviteLinkedinFriendDelegate> inviteLinkedInFriend;
    id<OAuthDelegate>OAuthDelegate;
//    IBOutlet UIButton *login_Btn;
    IBOutlet UIButton *btnClose;
//    IBOutlet UIButton *playyIt_Btn;
    IBOutlet UILabel *lbl_message;
//    IBOutlet UILabel *lbl2_message;
//    IBOutlet UILabel *lbl_messageAfterLogin;
    CGRect screenBounds;
//    IBOutlet UIView *logInView;
//    IBOutlet UIView *OAuthView;
    
//    BOOL isFromSearchDetailsForBookMark;
    
//    IBOutlet UIButton *btn_Cancel;
//    IBOutlet UIButton *btn_Done;
//    IBOutlet UIImageView *img_TransparentBg;
//    IBOutlet UIImageView *img_WhiteBg;
//    IBOutlet UIImageView *img_PickerBg;
//    NSInteger selectedHomeLocationIndex;
//    NSMutableArray *arr_HomeLocation;
    NSString *MessageSubject;
}
//@property(nonatomic, readwrite)NSInteger selectedHomeLocationIndex;
//@property(nonatomic, retain) NSMutableArray *arr_HomeLocation;
@property(nonatomic, retain) OAToken *requestToken;
@property(nonatomic, retain) OAToken *accessToken;
//@property(nonatomic, retain) NSDictionary *profile;
@property(nonatomic, retain) id <InviteLinkedinFriendDelegate> inviteLinkedInFriend;
@property(nonatomic, retain) id <OAuthDelegate> OAuthDelegate;
//@property (retain, nonatomic) IBOutlet UIImageView *BG_Img;
//@property (retain, nonatomic) IBOutlet UIImageView *WhiteLogInBGImg;
//@property (retain, nonatomic) IBOutlet UIView *homeLocationView;
//@property (retain, nonatomic) IBOutlet UIImageView *homeLocationBGImgView;
//@property (retain, nonatomic) IBOutlet UIImageView *homeLocationWhiteBGImgView;
//@property (retain, nonatomic) IBOutlet UIButton *btnHomeLocation;
//@property(nonatomic, retain) UIView *logInView;
//@property(nonatomic, retain) UIView *OAuthView;
//@property(nonatomic, retain) IBOutlet UIImageView *smileyView;
//@property(nonatomic, retain) UILabel *lbl_messageAfterLogin;
//@property(nonatomic, retain) UIButton *playyIt_Btn;
//@property (nonatomic,readwrite) BOOL isFromSearchDetailsForBookMark;

@property (nonatomic, retain) NSString *MessageSubject;

#pragma Private properties
@property(nonatomic,retain)UIWindow *loginwindow;
@property(nonatomic,retain)UIWindow *oldKeyWindow;
@property(nonatomic,retain)NSString *apikey;
@property(nonatomic,retain)NSString *secretkey;
@property(nonatomic,retain)NSString *RequestTokenResultString;
@property(nonatomic,readwrite)BOOL IsLoginCalledDuringMessagePost;
@property(nonatomic,retain)NSString *PostMessage;
@property(nonatomic,retain)NSString *FriendId;


-(IBAction)CLICK_LOGIN:(id)sender;
-(IBAction)CLICK_PlayyIt:(id)sender;
-(IBAction)CLICK_CROSS:(id)sender;
- (void)postUpdateHERE :(NSDictionary *)param;
- (void)GetUserProfile;
- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;
- (void)testApiCall;
- (void)GetLinkedInContacts;
- (void)PostLinkedInMessage:(NSString *)subject message:(NSString *)textMessage FriendID:(NSString *)_friendId;
-(void)DISMISS_SELF_VIEW;

-(IBAction)CLICK_HomeLocation:(id)sender;
-(void)LogoutFromLinkedIn;

#pragma NEW METHODS
-(void)Login:(BOOL)LogOutUserIfAlreadyLoggedIn;
-(OAuthLoginView *)initWithAPIKeySecretKey:(NSString*)APIKey SecretKey:(NSString *)SecretKey Delegate:(id)delegate;
@end
