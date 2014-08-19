//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//
#import <Foundation/NSNotificationQueue.h>
#import "OAuthLoginView.h"
//#import "XMLParser.h"
#import "JSON.h"
//#import "Portfolio.h"
//#import "HomeLocationView.h"
/**/

//
// OAuth steps for version 1.0a:
//
//  1. Request a "request token"
//  2. Show the user a browser with the LinkedIn login page
//  3. LinkedIn redirects the browser to our callback URL
//  4  Request an "access token"
//
@implementation OAuthLoginView

@synthesize requestToken, accessToken, inviteLinkedInFriend;
//@synthesize BG_Img,WhiteLogInBGImg,logInView,OAuthView,smileyView,lbl_messageAfterLogin,playyIt_Btn;
//@synthesize isFromSearchDetailsForBookMark;
//@synthesize arr_HomeLocation,selectedHomeLocationIndex;
@synthesize OAuthDelegate;
@synthesize apikey,secretkey;

//CustomAlertView *_CustomAlertView_Login;

@synthesize MessageSubject;


#pragma OAuth
//
// OAuth step 1a:
//
// The first step in the the OAuth process to make a request for a "request token".
// Yes it's confusing that the work request is mentioned twice like that, but it is whats happening.
//
- (void)requestTokenFromProvider
{
    [activityIndicator startAnimating];
    OAMutableURLRequest *request =
    [[[OAMutableURLRequest alloc] initWithURL:requestTokenURL
                                     consumer:consumer
                                        token:nil
                                     callback:linkedInCallbackURL
                            signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter * scopeParameter=[OARequestParameter requestParameter:@"scope" value:@"r_fullprofile rw_nus r_network w_messages r_emailaddress"];
    
    [request setParameters:[NSArray arrayWithObject:scopeParameter]];
    
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenResult:didFinish:)
                  didFailSelector:@selector(requestTokenResult:didFail:)];
}

//
// OAuth step 1b:
//
// When this method is called it means we have successfully received a request token.
// We then show a webView that sends the user to the LinkedIn login page.
// The request token is added as a parameter to the url of the login page.
// LinkedIn reads the token on their end to know which app the user is granting access to.
//
- (void)requestTokenResult:(OAServiceTicket *)ticket didFinish:(NSData *)data 
{
    if (ticket.didSucceed == NO) 
        return;
        
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    //self.RequestTokenResultString=responseBody;
    self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    if([[self OAuthDelegate] respondsToSelector:@selector(TokenReceiveSuccessful:)]){
        [self.OAuthDelegate TokenReceiveSuccessful:self.requestToken];
    }
    
    [self allowUserToLogin];
    [responseBody release];
    //[requestToken release];
}

- (void)requestTokenResult:(OAServiceTicket *)ticket didFail:(NSData *)error 
{
    if([[self OAuthDelegate] respondsToSelector:@selector(TokenReceiveFailed:)]){
    [self.OAuthDelegate TokenReceiveFailed:error];
    }
    [self performSelector:@selector(DISMISS_SELF_VIEW) withObject:self afterDelay:3];
}

-(void)DISMISS_SELF_VIEW {
    [activityIndicator stopAnimating];
    lbl_message.text=@"Oops. Unable to connect to Linkedin at this time. Please try a little later.";
}
//
// OAuth step 2:
//
// Show the user a browser displaying the LinkedIn login page.
// They type username/password and this is how they permit us to access their data
// We use a UIWebView for this.
//
// Sending the token information is required, but in this one case OAuth requires us
// to send URL query parameters instead of putting the token in the HTTP Authorization
// header as we do in all other cases.
//
- (void)allowUserToLogin
{
    NSString *userLoginURLWithToken = [NSString stringWithFormat:@"%@?oauth_token=%@&auth_token_secret=%@", 
        userLoginURLString, self.requestToken.key, self.requestToken.secret];
    
    userLoginURL = [NSURL URLWithString:userLoginURLWithToken];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL: userLoginURL];
    [webView loadRequest:request];     
}


//
// OAuth step 3:
//
// This method is called when our webView browser loads a URL, this happens 3 times:
//
//      a) Our own [webView loadRequest] message sends the user to the LinkedIn login page.
//
//      b) The user types in their username/password and presses 'OK', this will submit
//         their credentials to LinkedIn
//
//      c) LinkedIn responds to the submit request by redirecting the browser to our callback URL
//         If the user approves they also add two parameters to the callback URL: oauth_token and oauth_verifier.
//         If the user does not allow access the parameter user_refused is returned.
//
//      Example URLs for these three load events:
//          a) https://www.linkedin.com/uas/oauth/authorize?oauth_token=<token value>
//
//          b) https://www.linkedin.com/uas/oauth/authorize/submit   OR
//             https://www.linkedin.com/uas/oauth/authenticate?oauth_token=<token value>&trk=uas-continue
//
//          c) hdlinked://linkedin/oauth?oauth_token=<token value>&oauth_verifier=63600     OR
//             hdlinked://linkedin/oauth?user_refused
//             
//
//  We only need to handle case (c) to extract the oauth_verifier value
//

#pragma Webview delegates
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType 
{
	NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
    
    addressBar.text = urlString;
   // [activityIndicator startAnimating];
    
    BOOL requestForCallbackURL = ([urlString rangeOfString:linkedInCallbackURL].location != NSNotFound);
    if ( requestForCallbackURL )
    {
        BOOL userAllowedAccess = ([urlString rangeOfString:@"user_refused"].location == NSNotFound);
        if ( userAllowedAccess )
        {            
            [self.requestToken setVerifierWithUrl:url];
            [self accessTokenFromProvider];
        }
        else
        {
            // User refused to allow our app access
            // Notify parent and close this view
            //logInView.hidden=NO;
            //OAuthView.hidden=YES;
//            [[NSNotificationCenter defaultCenter] 
//                    postNotificationName:@"loginViewDidFinish"
//                                  object:self 
//                                userInfo:nil];

//            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else
    {
        // Case (a) or (b), so ignore it
    }
    //lbl_just.hidden=YES;
    //[activityIndicator stopAnimating];
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
    lbl_message.hidden=YES;
    webView.hidden=NO;
}

//
// OAuth step 4:
//
- (void)accessTokenFromProvider
{ 
    OAMutableURLRequest *request = 
            [[[OAMutableURLRequest alloc] initWithURL:accessTokenURL
                                             consumer:consumer
                                                token:self.requestToken   
                                             callback:nil
                                    signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenResult:didFinish:)
                  didFailSelector:@selector(accessTokenResult:didFail:)];    
}

- (void)accessTokenResult:(OAServiceTicket *)ticket didFinish:(NSData *)data 
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    BOOL problem = ([responseBody rangeOfString:@"oauth_problem"].location != NSNotFound);
    [self RemoveLoginWindow];
    if ( problem )
    {
        if([[self OAuthDelegate] respondsToSelector:@selector(LoginFailed)]){
        [self.OAuthDelegate LoginFailed];
        }
    }
    else
    {
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [[NSUserDefaults standardUserDefaults] setObject:responseBody forKey:@"LnAccessToken"];
        if([[self OAuthDelegate] respondsToSelector:@selector(LoginSuccessful)]){
        [self.OAuthDelegate LoginSuccessful];
        }
//        [self GetUserProfile];
        if (self.IsLoginCalledDuringMessagePost) {
            [self PostLinkedInMessage:self.MessageSubject message:self.PostMessage FriendID:self.FriendId];
            self.IsLoginCalledDuringMessagePost=NO;
        }
        
    }
    [responseBody release];
   // [accessToken release];
}

- (void)accessTokenResult:(OAServiceTicket *)ticket didFail:(NSData *)data {
    if([[self OAuthDelegate] respondsToSelector:@selector(LoginFailed)]){
    [self.OAuthDelegate LoginFailed];
    }
}

#pragma mark-
#pragma mark User Details API

- (void)GetUserProfile
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people::(~,hks0NPUMZF):(id,first-name,last-name,headline,picture-url,email-address,formatted-name)"];
    OAMutableURLRequest *request = 
            [[OAMutableURLRequest alloc] initWithURL:url
                                            consumer:consumer
                                               token:self.accessToken
                                            callback:nil
                                    signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];

    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(GetUserProfileResult:didFinish:)
                  didFailSelector:@selector(GetUserProfileResult:didFail:)];    
    [request release];
}
//Get all details
- (void)GetUserProfileResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *user = [responseBody objectFromJSONString];
    [responseBody release];
    
    
    [self.OAuthDelegate GetLinkedInUserProfileDidFinish:user];
    
    // Notify parent and close this view
    /*
    [[NSNotificationCenter defaultCenter]
            postNotificationName:@"loginViewDidFinish"        
                          object:self
                        userInfo:self.profile];
    */
    if([[self OAuthDelegate] respondsToSelector:@selector(GetLinkedInUserProfileDidFinish:)]){
        [self.OAuthDelegate GetLinkedInUserProfileDidFinish:user];
    }
    

//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)GetUserProfileResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    if([[self OAuthDelegate] respondsToSelector:@selector(GetLinkedInUserProfileDidFail:)]){
        [self.OAuthDelegate GetLinkedInUserProfileDidFail:error];
    }
}


#pragma mark -
#pragma mark Connection API

- (void)GetLinkedInContacts
{
    if ([self RetrieveExistingToken] == YES) {

        NSString *LnAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"LnAccessToken"];
        
        OAConsumer *_consumer = [[OAConsumer alloc] initWithKey:self.apikey
                                                         secret:self.secretkey
                                                          realm:@"https://api.linkedin.com/"];
        
        OAToken *_token = [[OAToken alloc] initWithHTTPResponseBody:LnAccessToken];

        //https://api.linkedin.com/v1/people/~/connections:(id,first-name,last-name,industry,headline,email-address,picture-url,public-profile-url)
        
        NSURL *url = [NSURL URLWithString:@"https://api.linkedin.com/v1/people/~/connections:(id,email-address,picture-url,formatted-name)"];
       
        
        OAMutableURLRequest *request =
        [[OAMutableURLRequest alloc] initWithURL:url
                                        consumer:_consumer
                                           token:_token
                                        callback:nil
                               signatureProvider:nil];
        
        [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(GetLinkedInContactsResult:didFinish:)
                      didFailSelector:@selector(GetLinkedInContactsResult:didFail:)];
        [request release];
    }
   // [_consumer release];
   // [_token release];
}
//Get all details
- (void)GetLinkedInContactsResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    //self.profile = [responseBody objectFromJSONString];
    NSMutableDictionary *dictContact= [responseBody objectFromJSONString];
    
//    NSLog(@"%@",self.profile);
    
    // Notify parent and close this view
    /*
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"connectionDidFinish"
     object:self
     userInfo:self.profile];
     */
    [self.OAuthDelegate GetLinkedInContactsDidFinish:dictContact];
    [responseBody release];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)GetLinkedInContactsResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    [self.OAuthDelegate GetLinkedInContactsDidFail:error];
}


-(void)postUpdateHERE:(NSDictionary *)param
{
    OAConsumer *_consumer = [[OAConsumer alloc] initWithKey:self.apikey
                                                     secret:self.secretkey
                                                      realm:@"https://api.linkedin.com/"];
    
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/shares"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:_consumer
                                       token:self.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    NSString *updateString = [param JSONString];
    [request setHTTPBodyWithString:updateString];
    [request setHTTPMethod:@"POST"];
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(postUpdateApiCallResult:didFinish:)
                  didFailSelector:@selector(postUpdateApiCallResult:didFail:)];
    
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *dict= [responseBody objectFromJSONString];
    [responseBody release];
    
    //        if (self.inviteLinkedInFriend) {
    //            [self.inviteLinkedInFriend inviteAndSendMessage];
    //        }
    if ([[dict valueForKey:@"errorCode"] length]>0) {
        [self.OAuthDelegate LinkedInPostFailed:Nil];
    }
    else{
        [self.OAuthDelegate LinkedInPostSuccessful];
    }
    
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSString *jsonResponse = [[NSString alloc] initWithData:error
                                                   encoding:NSUTF8StringEncoding];
    //NSLog(@"LinkedIn JSON STRING ====== %@",jsonResponse);
    
    //NSLog(@"%@",[error description]);
    [jsonResponse release];
    
    [self.OAuthDelegate LinkedInPostFailed:error];
}

#pragma mark- 
#pragma mark Linkedin Message Post

- (void)PostLinkedInMessage:(NSString *)subject message:(NSString *)textMessage FriendID:(NSString *)_friendId
{
    //NSString *_apikey = @"ok0ktu3pdj67";//@"2uyyj047cluu";
    //NSString *_secretkey = @"GgEcT0AGuP7N75di";//@"8G9SUCCdcC01pSvQ";
    NSString *LnAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"LnAccessToken"];
    if ([LnAccessToken length]<=0) {
        self.IsLoginCalledDuringMessagePost=YES;
        self.FriendId=_friendId;
        self.PostMessage=textMessage;
        self.MessageSubject=subject;
        [self Login:YES];
        return;
    }
    
    OAConsumer *_consumer = [[OAConsumer alloc] initWithKey:self.apikey
                                                     secret:self.secretkey
                                                      realm:@"https://api.linkedin.com/"];
    
    OAToken *_token = [[OAToken alloc] initWithHTTPResponseBody:LnAccessToken];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.linkedin.com/v1/people/~/mailbox"]];
    
    
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:_consumer
                                       token:_token
                                    callback:nil
                           signatureProvider:nil];
    
    
    //NSString *msgString = [NSString stringWithFormat:@"{\"recipients\": {\"values\": [{\"person\": {\"_path\": \"/people/%@\"}}]},\"subject\": \"From PlayyIt.\",\"body\": \"%@\"}",_friendId,textMessage];
    
    
    NSString *msgString = [NSString stringWithFormat:@"{\"recipients\": {\"values\": [{\"person\": {\"_path\": \"/people/%@\"}}]},\"subject\": \"%@\",\"body\": \"%@\"}",_friendId,subject,textMessage];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBodyWithString:msgString];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(PostLinkedInMessage:didFinish:)
                  didFailSelector:@selector(PostLinkedInMessage:didFail:)];
    
    [request release];
    //[_token release];
    //[_consumer release];
}


- (void)PostLinkedInMessage:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    
        NSMutableDictionary *dict= [responseBody objectFromJSONString];
        [responseBody release];
        
//        if (self.inviteLinkedInFriend) {
//            [self.inviteLinkedInFriend inviteAndSendMessage];
//        }
    [self.OAuthDelegate LinkedInMessagePostSuccessful];
    
}

- (void)PostLinkedInMessage:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSString *jsonResponse = [[NSString alloc] initWithData:error
                                                   encoding:NSUTF8StringEncoding];
    //NSLog(@"LinkedIn JSON STRING ====== %@",jsonResponse);
    
    //NSLog(@"%@",[error description]);
    [jsonResponse release];
    
    [self.OAuthDelegate LinkedInMessagePostFailed:error];
}

- (void)initLinkedInApi
{
    //apikey = @"ok0ktu3pdj67";//@"2uyyj047cluu";
    //secretkey = @"GgEcT0AGuP7N75di";//@"8G9SUCCdcC01pSvQ";

    consumer = [[OAConsumer alloc] initWithKey:self.apikey
                                        secret:self.secretkey
                                         realm:@"http://api.linkedin.com/"];

    requestTokenURLString = @"https://api.linkedin.com/uas/oauth/requestToken";
    accessTokenURLString = @"https://api.linkedin.com/uas/oauth/accessToken";
    userLoginURLString = @"https://www.linkedin.com/uas/oauth/authorize";    
    linkedInCallbackURL = @"hdlinked://linkedin/oauth";
    
    requestTokenURL = [[NSURL URLWithString:requestTokenURLString] retain];
    accessTokenURL = [[NSURL URLWithString:accessTokenURLString] retain];
    userLoginURL = [[NSURL URLWithString:userLoginURLString] retain];
}

-(void)LogoutFromLinkedIn
{
    @try {
        
        self.requestToken = nil;
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"linkedin"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
        //Clear NSUserDefaults so that access token will not be found
        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"LnAccessToken"];
        if([[self OAuthDelegate] respondsToSelector:@selector(LogOutSuccessful)]){
            [self.OAuthDelegate LogOutSuccessful];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception: %@",exception);
        if([[self OAuthDelegate] respondsToSelector:@selector(LogOutFailed)]){
            [self.OAuthDelegate LogOutFailed];
        }
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
   /* if ([apikey length] < 64 || [secretkey length] < 64)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"OAuth Starter Kit"
                          message: @"You must add your apikey and secretkey.  See the project file readme.txt"
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        // Notify parent and close this view
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"loginViewDidFinish"        
         object:self
         userInfo:self.profile];
        
        [self dismissModalViewControllerAnimated:YES];
    }
*/

}
    
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark-

-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NSDictionary *profile = [notification userInfo];
    
//    appDelegate.objLogin.linkedinUserId=[[profile valueForKey:@"id"] retain];
//    
//    appDelegate.objLogin.userName=[NSString stringWithFormat:@"%@ %@",[profile valueForKey:@"firstName"],[profile valueForKey:@"lastName"]]; 
    
    //NSLog(@"linkedinUserId=%@",appDelegate.objLogin.linkedinUserId);
    //NSLog(@"linkedin User Name=%@",appDelegate.objLogin.userName);
    //_homeLocationView.hidden=NO;
//    if ([Common get_iPhone5ScreenSize:&(screenBounds)])
//    {
//        [_homeLocationBGImgView setImage:[UIImage imageNamed:@"MainMenuBg-568h@2x.png"]];
//        [_homeLocationWhiteBGImgView setImage:[UIImage imageNamed:@"MainMenuBgWhite-568h@2x.png"]];
//    }
    //OAuthView.hidden=YES;
}

#pragma mark -
#pragma mark Cross Button Click
-(IBAction)CLICK_CROSS:(id)sender
{
    [self RemoveLoginWindow];
}

- (void)viewDidUnload {
    //[self setWhiteLogInBGImg:nil];
    //[self setBG_Img:nil];
    //[self setHomeLocationView:nil];
    //[self setHomeLocationBGImgView:nil];
    //[self setHomeLocationWhiteBGImgView:nil];
    //[self setBtnHomeLocation:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
//    [arr_HomeLocation release];
    //[_homeLocationView release];
    //[_homeLocationBGImgView release];
    //[_homeLocationWhiteBGImgView release];
    //[_btnHomeLocation release];
    [super dealloc];
    //[WhiteLogInBGImg release];
    //[BG_Img release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma Public methods
-(OAuthLoginView *)initWithAPIKeySecretKey:(NSString*)APIKey SecretKey:(NSString *)SecretKey Delegate:(id)delegate{
    if (self=[super init]) {
        self.apikey=APIKey;
        self.secretkey=SecretKey;
        self.OAuthDelegate=delegate;
        [self initLinkedInApi];
        [self DesignLoginView];
    }
    return self;
}

-(void)Login:(BOOL)LogOutUserIfAlreadyLoggedIn{
    if (LogOutUserIfAlreadyLoggedIn) {
        [self LogoutFromLinkedIn];
        [self requestTokenFromProvider];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginViewDidFinish:)
                                                     name:@"loginViewDidFinish"
                                                   object:self];
        self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
//        if (!self.loginwindow) {
//            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//            window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//            window.opaque = NO;
//            window.windowLevel = UIWindowLevelAlert;
//            window.rootViewController = self;
//            self.loginwindow = window;
//        }
//        [self.loginwindow makeKeyAndVisible];
        [self.oldKeyWindow.rootViewController.view addSubview:self.view];
    }
    
    else{
        if (![self RetrieveExistingToken]) {
            
            [self requestTokenFromProvider];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(loginViewDidFinish:)
                                                         name:@"loginViewDidFinish"
                                                       object:self];
            self.oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
//            if (!self.loginwindow) {
//                UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//                window.opaque = NO;
//                window.windowLevel = UIWindowLevelAlert;
//                window.rootViewController = self;
//                self.loginwindow = window;
//            }
//            [self.loginwindow makeKeyAndVisible];
            [self.oldKeyWindow.rootViewController.view addSubview:self.view];
        }
        else{
            if([[self OAuthDelegate] respondsToSelector:@selector(LoginSuccessful)]){
            [self.OAuthDelegate LoginSuccessful];
            }
//            [self GetUserProfile];
        }
    }

}

#pragma Private Methods
-(BOOL)RetrieveExistingToken{
    NSString *LnAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"LnAccessToken"];
    if ([LnAccessToken length]<=0) {
        return NO;
    }
    consumer = [[OAConsumer alloc] initWithKey:self.apikey
                                                     secret:self.secretkey
                                                      realm:@"https://api.linkedin.com/"];
    
    self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:LnAccessToken];
    
    return YES;
}

-(void)DesignLoginView{
    screenBounds=[[UIScreen mainScreen]bounds];
    webView=[[UIWebView alloc]initWithFrame:screenBounds];
    [self.view addSubview:webView];
    webView.delegate=self;
    webView.hidden=YES;
    activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.color=[UIColor purpleColor];
    activityIndicator.frame=CGRectMake(([self.view bounds].size.width/2)-25, ([self.view bounds].size.height/2)-25, 50, 50);
    activityIndicator.hidden=NO;
    activityIndicator.backgroundColor=[UIColor clearColor];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
    lbl_message=[[UILabel alloc]initWithFrame:CGRectMake(33, ([self.view bounds].size.height/2)-38+25, 255, 76)];
    lbl_message.numberOfLines=3;
    lbl_message.textColor=[UIColor darkGrayColor];
    lbl_message.textAlignment=NSTextAlignmentCenter;
    lbl_message.font=[UIFont systemFontOfSize:13.0];
    lbl_message.backgroundColor=[UIColor clearColor];
    lbl_message.text=@"Just a minute - Connecting to Linkedin.";
    [self.view addSubview:lbl_message];
    
    btnClose=[UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame=CGRectMake(screenBounds.size.width-40, 10, 30, 30);
    [btnClose setTitle:@"X" forState:UIControlStateNormal];
    [btnClose.titleLabel setTextColor:[UIColor blackColor]];
    btnClose.backgroundColor=[UIColor clearColor];
    [btnClose addTarget:self action:@selector(CLICK_CROSS:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    //[addressBar setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
}

-(void)RemoveLoginWindow{
    //return;
    [self.loginwindow removeFromSuperview];
    self.loginwindow.hidden=YES;
    [self.view removeFromSuperview];
}

@end
