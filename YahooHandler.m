//
//  YahooHandler.m
//  SocialSample
//
//  Created by Arijit Chakraborty on 27/01/14.
//
//

#import "YahooHandler.h"

@interface YahooHandler(){
    YOSSession					*session;
	NSMutableDictionary			*oauthResponse;
    
}
@property (nonatomic, readwrite, retain) YOSSession *session;
@property (nonatomic, readwrite, retain) NSMutableDictionary *oauthResponse;
@property(nonatomic,retain)NSString *ConsumerKey;
@property(nonatomic,retain)NSString *ConsumerSecretKey;
@property(nonatomic,retain)NSString *AppID;
@property(nonatomic,retain)NSString *CallbackURL;

#pragma mark - private methods
-(BOOL)LoadSettingsfromPlist;

@end



@implementation YahooHandler
@synthesize session,oauthResponse;

+(YahooHandler *)SharedInstance{
    static YahooHandler *yahoohandler;
    if (yahoohandler==nil) {
        yahoohandler=[[YahooHandler alloc]init];
        //return yahoohandler;
        if ([yahoohandler LoadSettingsfromPlist]) {
            //settings loaded successfully from plist
        }
        
    }
    return yahoohandler;
}

-(YahooHandler *)initWithAPIKeysAndId:(NSString*)ConsumerKey ConsumerSecretKey:(NSString *)ConsumerSecretKey AppID:(NSString *)AppID CallbackURL:(NSString *)CallbackURL Delegate:(id)delegate{
    
    if (self=[super init]) {
    self.ConsumerKey=ConsumerKey;
    self.ConsumerSecretKey=ConsumerSecretKey;
    self.AppID=AppID;
    self.CallbackURL=CallbackURL;
    }
    return self;
}

-(void)Login:(BOOL)LogOutUserIfAlreadyLoggedIn delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector {
    delegate=aDelegate;
    didFinishSelector=finishSelector;
    didFailSelector=failSelector;
    [self CreateYahooSession];
}

-(void)LogoutFromYahoo:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector{
    delegate=aDelegate;
    didFinishSelector=finishSelector;
    didFailSelector=failSelector;
    [self.session clearSession];
    NSDictionary *dictResponse=[[NSDictionary alloc]initWithObjectsAndKeys:@"success",@"LogoutStatus", nil];
    [delegate performSelector:didFinishSelector withObject:dictResponse];
}

-(void)CreateYahooSession{
	// create session with consumer key, secret and application id
	// set up a new app here: https://developer.yahoo.com/dashboard/createKey.html
	// because the default values here won't work
	if (self.session==nil) {
        self.session = [YOSSession sessionWithConsumerKey:self.ConsumerKey
                                        andConsumerSecret:self.ConsumerSecretKey
                                         andApplicationId:self.AppID];
    }
	if(self.oauthResponse)
    {
		NSString *verifier = [self.oauthResponse valueForKey:@"oauth_verifier"];
        NSLog(@"Verifier in userdefaults is %@",verifier);
        
		[self.session setVerifier:verifier];
	}
	
	BOOL hasSession = [self.session resumeSession];
	
    
    NSLog(@"@@@@@@@@@@@@@@ Has Session is %c",hasSession);
	if(!hasSession)
    {
        // NSString *myString = [appDelegate.authorizationUrl absoluteString];
        //http://www.myappdemo.net/test/yredirect.php
        //http://www.yahoomail.com
        
        [self.session sendUserToAuthorizationWithCallbackUrl:self.CallbackURL];
        
	}
    else{
        NSLog(@"Login successful");
        NSDictionary *dictResponse=[[NSDictionary alloc]initWithObjectsAndKeys:@"success",@"LoginStatus", nil];
        [delegate performSelector:didFinishSelector withObject:dictResponse];
    }
}
    

-(void)HandleCallbackUrl:(NSURL *)url{
	//launchDefault = NO;
	
	if (!url)
    {
		//return NO;
	}
	
	NSArray *pairs = [[url query] componentsSeparatedByString:@"&"];
	NSMutableDictionary *response = [NSMutableDictionary dictionary];
	
	for (NSString *item in pairs)
    {
		NSArray *fields = [item componentsSeparatedByString:@"="];
		NSString *name = [fields objectAtIndex:0];
		NSString *value = [[fields objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		[response setObject:value forKey:name];
	}
	
	self.oauthResponse = response;
    
    NSString *tempStr=[self.oauthResponse valueForKey:@"oauth_verifier"];
    NSLog(@"oauthResponse in app delegate is %@",self.oauthResponse);
    
    [self CreateYahooSession];
}

-(void)getUserContacts:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
    //[self getUserProfile];
	// initialize the profile request with our user.
    delegate=aDelegate;
    didFinishSelector=finishSelector;
    didFailSelector=failSelector;
    NSLog(@"session in social view controller is  %@",self.session);
    
	YOSUserRequest *userRequest = [YOSUserRequest requestWithSession:self.session];
	
	// get the users profile
	//[userRequest fetchConnectionProfilesWithStart:0 andCount:10 withDelegate:self];
    [userRequest fetchUserContacts:self];
}

- (void)getUserProfile:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	// initialize the profile request with our user.
    delegate=aDelegate;
    didFinishSelector=finishSelector;
    didFailSelector=failSelector;
    YOSUserRequest *userRequest = [YOSUserRequest requestWithSession:self.session];
	// get the users profile
	[userRequest fetchProfileWithDelegate:self];
    // [userRequest fetchConnectionsWithStart:1 andCount:1 withDelegate:self];
    
}

- (void)requestDidFinishLoading:(YOSResponseData *)data
{
	NSDictionary *responsedata = [data.responseText JSONValue] ; //objectForKey:@"profile"];
    //NSLog(@"User Profile is %@",[userProfile description]);
	if(responsedata)
    {
		[delegate performSelector:didFinishSelector withObject:responsedata];//[viewController setUserProfile:userProfile];
	}
    else{
        [delegate performSelector:didFailSelector withObject:nil];
    }
}


-(BOOL)LoadSettingsfromPlist{
    NSString *plistpath=[[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dictPlistData=[[NSDictionary alloc]initWithContentsOfFile:plistpath];
    
    self.AppID=[NSString stringWithFormat:@"%@",[[dictPlistData objectForKey:@"YahooSettings"] valueForKey:@"AppID"]];
    self.ConsumerKey=[NSString stringWithFormat:@"%@",[[dictPlistData objectForKey:@"YahooSettings"] valueForKey:@"ConsumerKey"]];
    self.ConsumerSecretKey=[NSString stringWithFormat:@"%@",[[dictPlistData objectForKey:@"YahooSettings"] valueForKey:@"ConsumerSecretKey"]];
    self.CallbackURL=[NSString stringWithFormat:@"%@",[[dictPlistData objectForKey:@"YahooSettings"] valueForKey:@"CallbackURL"]];
    
    return YES;
}

@end
