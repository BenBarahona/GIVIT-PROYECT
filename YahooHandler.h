//
//  YahooHandler.h
//  SocialSample
//
//  Created by Arijit Chakraborty on 27/01/14.
//
//

#import <Foundation/Foundation.h>
#import "YOSSession.h"
#import "YOSRequestClient.h"
#import "NSString+SBJSONYAHOO.h"
#import "YOSUser.h"
#import "YOSUserRequest.h"

@protocol YahooOAuthDelegate <NSObject>

-(void)RequestTokenReceiveSuccessful;
-(void)RequestTokenReceiveFailed:(NSData*)error;
-(void)AccessTokenReceiveSuccessful;
-(void)AccessTokenReceiveFailed:(NSData*)error;
-(void)LoginSuccessful;
-(void)LoginFailed;
-(void)GetYahooContactsDidFinish:(NSMutableDictionary *)contacts;
-(void)GetYahooContactsDidFail:(NSData *)error;
-(void)GetYahooUserProfileDidFinish:(NSMutableDictionary *)contacts;
-(void)GetYahooUserProfileDidFail:(NSData *)error;
-(void)YahooMessagePostSuccessful;
-(void)YahooMessagePostFailed:(NSData *)error;
-(void)LogOutSuccessful;
-(void)LogOutFailed;
@end

@interface YahooHandler : NSObject{
    id delegate;
    SEL didFinishSelector;
    SEL didFailSelector;
}

@property(nonatomic,retain)id<YahooOAuthDelegate>delegate;


#pragma mark - public methods
+(YahooHandler *)SharedInstance;
-(void)Login:(BOOL)LogOutUserIfAlreadyLoggedIn delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector;
-(void)LogoutFromYahoo:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector;
- (void)getUserProfile:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector;
-(void)getUserContacts:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector;
-(YahooHandler *)initWithAPIKeysAndId:(NSString*)ConsumerKey ConsumerSecretKey:(NSString *)ConsumerSecretKey AppID:(NSString *)AppID CallbackURL:(NSString *)CallbackURL Delegate:(id)delegate;
-(void)HandleCallbackUrl:(NSURL *)url;

@end
