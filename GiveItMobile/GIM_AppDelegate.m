//
//  GIM_AppDelegate.m
//  GiveItMobile
//
//  Created by Administrator on 19/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_AppDelegate.h"

@implementation GIM_AppDelegate
@synthesize deviceTokenString;
@synthesize yahoohandler;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    if (launchOptions) {
        NSLog(@"Lanch optionssssssssssssssssss %@", [[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"]);
        if ([[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"]) {
            NSMutableArray *message = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"myMessage"]];
            if (!message) {
                message = [[NSMutableArray alloc] init];
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if ([[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg"] length]>0) {
                [dict setObject:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg"]forKey:@"message"];
            }
            else{
                [dict setObject:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"alert"]forKey:@"message"];
            }
            if ([[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg_date"]) {
                [dict setObject:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg_date"]forKey:@"messagedate"];
            }
            else{
                [dict setObject:@""forKey:@"messagedate"];
            }
            [dict setValue:@"unread" forKey:@"status"];
            
//            
//            
//            if ([[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg"] length]>0) {
//                [dict setObject:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg"]forKey:@"message"];
//                [dict setObject:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg_date"]forKey:@"messagedate"];
//                [dict setValue:@"unread" forKey:@"status"];
//            }else{
//                [dict setObject:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"alert"]forKey:@"message"];
//                [dict setObject:[[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] valueForKey:@"msg_date"]forKey:@"messagedate"];
//                [dict setValue:@"unread" forKey:@"status"];
//            }
            [message addObject:dict];
            [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"myMessage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            
            
        }
    }
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:170.0/255.0 blue:72.0/255.0 alpha:1]];
    [[UILabel appearance] setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    [[UITextField appearance] setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    [[UITextView appearance] setFont:[UIFont fontWithName:@"Droid Sans" size:12]];
    [FBSession.activeSession closeAndClearTokenInformation];
//    for (int i = 0; i<4; i++) {
//        [self testdata:@"unread"];
//        [self testdata:@"read"];
//        [self testdata:@"unread"];
//    }
    return YES;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"Recxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx %@",userInfo);
   
    if (userInfo) {
        if ([userInfo objectForKey:@"aps"]) {
            NSMutableArray *message = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"myMessage"]];
            if (!message) {
                message = [[NSMutableArray alloc] init];
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if ([[userInfo objectForKey:@"aps"] valueForKey:@"msg"] != [NSNull null]) {
                [dict setObject:[[userInfo objectForKey:@"aps"] valueForKey:@"msg"]forKey:@"message"];
            }
            else{
                if ([[userInfo objectForKey:@"aps"] valueForKey:@"alert"] != [NSNull null]) {
                    [dict setObject:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]forKey:@"message"];
                }
                else{
                    [dict setObject:@""forKey:@"message"];
                }
            }
            if ([[[userInfo objectForKey:@"aps"] valueForKey:@"msg_date"] length]>0) {
                [dict setObject:[[userInfo objectForKey:@"aps"] valueForKey:@"msg_date"]forKey:@"messagedate"];
            }
            else{
                [dict setObject:@""forKey:@"messagedate"];
            }
            [dict setValue:@"unread" forKey:@"status"];
            [message insertObject:dict atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"myMessage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            self.isGetPush = YES;
            self.isGetPushPayment =YES;
            if (self.isPaymentView == NO) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Givit Mobile" message:@"You have a New Message Want to see?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
                [alert show];
            }
        } else {
            
            
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"viewcontrollers %@",[(UINavigationController *)self.window.rootViewController viewControllers]);
        [(UINavigationController *)self.window.rootViewController popToViewController:[[(UINavigationController *)self.window.rootViewController viewControllers] objectAtIndex:1] animated:YES];
    }
    else{
        self.isGetPush = NO;
        self.isGetPushPayment =NO;
    }
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation

{
  
    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    
    NSArray* urlArray = [urlstr componentsSeparatedByString: @":"];
    NSString* urlstr1 = [urlArray objectAtIndex: 0];
    NSLog(@"%@",urlstr1);
    NSString *checkUrl=@"com-isis-giveit";
    
    if ([checkUrl isEqualToString:urlstr1]) {
//        NSURL *url2 = [NSURL URLWithString:urlstr1];

        [[YahooHandler SharedInstance]HandleCallbackUrl:url];

    }
    else{
     [FBSession.activeSession handleOpenURL:url];

    }
    return YES;

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	if (!url)
    {
		return NO;
	}
    
	//[self.yahoohandler HandleCallbackUrl:url];
    [[YahooHandler SharedInstance]HandleCallbackUrl:url];
	return YES;
}


-(void)testdata : (NSString *)status{
    NSMutableArray *message = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"myMessage"]];
    if (!message) {
        message = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"I get the appropriate response back from Facebook, which includes the request ID and the ID's of the users who were invited. No one ever receives the invites, and when I check the request ID in the FB graph, I get returned 'false'." forKey:@"message"];
    [dict setObject:@"22/03/2014" forKey:@"messagedate"];
    [dict setValue:status forKey:@"status"];
    [message addObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"myMessage"];
}

@end
