//
//  GIM_AppDelegate.h
//  GiveItMobile
//
//  Created by Administrator on 19/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "YOSSession.h"
#import "YOSRequestClient.h"
#import "YOSRequestToken.h"
#import "YOSTokenStore.h"
#import "YOSAuthRequest.h"
#import "YOSSocial.h"
#import "YOAuthRequest.h"
#import "YahooHandler.h"

@interface GIM_AppDelegate : UIResponder <UIApplicationDelegate,YOSRequestDelegate,UIAlertViewDelegate>{
    YahooHandler *yahoohandler;

}
@property(nonatomic,retain)YahooHandler *yahoohandler;
@property BOOL isGetPush;
@property BOOL isGetPushPayment;
@property BOOL isGetPushGOD;
@property BOOL isPaymentView;

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)NSString *deviceTokenString;
@property(nonatomic,strong) YOSAuthRequest *appdelegateRequestToken;
@property(nonatomic,strong) NSURL *authorizationUrl;


@property BOOL isBecomeactive;
@end
