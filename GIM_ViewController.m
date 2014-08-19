//
//  GIM_ViewController.m
//  GiveItMobile
//
//  Created by Administrator on 19/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_ViewController.h"
#import "NSString+SBJSONYAHOO.h"
#import "YOSUser.h"
#import "YOSUserRequest.h"
@interface GIM_ViewController ()

@end

@implementation GIM_ViewController
@synthesize email,password;
@synthesize sessionYahoo;
@synthesize oauthResponse;

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLinkedInLoginSuccess = NO;
    _mGmailLoginView.hidden = YES;
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:15] forKeyPath:@"buttons.font"];
	// Do any additional setup after loading the view, typically from a nib.
    [self.email setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    _googleOAuth = [[GoogleOAuth alloc] initWithFrame:CGRectMake(0, 0, 320, _mGmailLoginView.frame.size.height-120)];
    [_googleOAuth setGOAuthDelegate:(id)self];
    [_googleOAuth revokeAccessToken];
    [_googleOAuth revokeAccessToken];
    appDelegate=(GIM_AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [[LinkedINAPIFunction sharedManager] createLogINViewwithAPISecretKey:@"75ma6wrvk4fhfa" withSecretKey:@"vaFhqoAwhVfJRwx4"];
    [[LinkedINAPIFunction sharedManager]setDelegate:(id)self];

}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if ([[def valueForKey:@"remember"] isEqualToString:@"yes"]) {
        email.text = [def valueForKey:@"emailID"];
        password.text = [def valueForKey:@"password"];
        [_mCheckBoxImageView setImage:[UIImage imageNamed:@"btn_tickmark_02.png"]];
        if (email.text.length>0) {
            [self performSegueWithIdentifier:@"didLogin" sender:self];
        }
    }
    else{
        email.text = nil;
        password.text = nil;
        [_mCheckBoxImageView setImage:[UIImage imageNamed:@"btn_tickmark_02.png"]];
        [def setValue:@"yes" forKey:@"remember"];
    }
    [def synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------


-(void)didError:(NSString *)msg{
    [self.indc stopAnimating];
   [_indc stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)didLoggedIn:(NSDictionary *)dict isSuccess:(BOOL)isSuccess {
    [self.indc stopAnimating];
    [[NSUserDefaults standardUserDefaults] setValue:email.text forKey:@"Myemail"];
    [[NSUserDefaults standardUserDefaults] setValue:password.text forKey:@"Mypass"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (isSuccess) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if ([[def valueForKey:@"remember"] isEqualToString:@"yes"]) {
            [def setValue:[[dict valueForKey:@"item"] valueForKey:@"email"]forKey:@"emailID"];
            [def setValue:password.text forKey:@"password"];
        }
        else{
            [def setValue:@"" forKey:@"emailID"];
            [def setValue:@"" forKey:@"password"];
        }
        
        [self performSegueWithIdentifier:@"didLogin" sender:self];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dict valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        [self.view setUserInteractionEnabled:YES];
        [self.indc stopAnimating];
    }
    
    [self.indc stopAnimating];
    
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark IBAction Methods
#pragma mark -------------------------------------------


- (IBAction)loginAction:(id)sender {
    NSString *validationmsg = [self validateLogin];
    
    if ([validationmsg isEqualToString:@"1"] ){
        GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
        
        userModel.email = self.email.text;
        
        userModel.password = self.password.text;
        GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSLog(@"UserToken %@",appD.deviceTokenString);
        userModel.deviceToken = appD.deviceTokenString;
        
        GIM_UserController *userController = [[GIM_UserController alloc]init];
        
        userController.delegate = self;
        
        [userController login:userModel];
        
        [self.indc startAnimating];
        
        [self.view setUserInteractionEnabled:NO];
    }
    else {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}

- (IBAction)didTapNewRegistration:(id)sender {
    [self performSegueWithIdentifier:@"segueRegistration" sender:self];
}





-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



- (IBAction)btnKeepMeLoggedIn:(id)sender {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    if ([[def valueForKey:@"remember"] isEqualToString:@"yes"]) {
        [_mCheckBoxImageView setImage:[UIImage imageNamed:@"btn_tickmark_01.png"]];
        [def setValue:@"no" forKey:@"remember"];
    }
    else{
        [_mCheckBoxImageView setImage:[UIImage imageNamed:@"btn_tickmark_02.png"]];
        [def setValue:@"yes" forKey:@"remember"];
       
    }
    

}

- (IBAction)btnForgotPassword:(id)sender {
    
    [self performSegueWithIdentifier:@"didForgotPassword" sender:self];
    
}

- (IBAction)didTapGmailSignIn:(id)sender {
    [self.indc startAnimating];
    [_googleOAuth authorizeUserWithClienID:@"118052793139-trvujb5d8eldudv3csbupksss6amfn5b.apps.googleusercontent.com"
                           andClientSecret:@"tp1UdMtjm_ExEPnKKYGd55Al"
                             andParentView:_mGmailLoginView
                                 andScopes:[NSArray arrayWithObjects:@"https://www.googleapis.com/auth/userinfo.profile", nil]];
    [self.navigationController.navigationBar setHidden:YES];
    _mGmailLoginView.hidden = NO;
}
- (IBAction)didTapYahooLogin:(id)sender{
    [[YahooHandler SharedInstance]Login:NO delegate:self didFinishSelector:@selector(LoginDidFinish:) didFailSelector:@selector(LoginDidFail:)];
}

- (IBAction)didTapToCancelGmailSign:(id)sender {
    [self.indc stopAnimating];
    [self.navigationController.navigationBar setHidden:NO];
    _mGmailLoginView.hidden = YES;
}

- (IBAction)didTapToFBLogin:(id)sender {
    [self.indc startAnimating];
//   [FBSession.activeSession closeAndClearTokenInformation];
//    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         if (error) {
//             [self.indc stopAnimating];
//         }
//         [self sessionStateChanged:session state:state error:error];
//     }];
    [[FbMethods sharedManager] setDelegate:(id)self];
    [[FbMethods sharedManager] didFacebookLogin];
}

#pragma mark FbMethodsDelegates
#pragma mark +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-(void)FacebookLoginSuccessFull{
    [[FbMethods sharedManager] getPersonalDetails];
}

-(void)getFBdetail{
    
}

-(void)FacebookLoginFaliur{
    
}

-(void)FacebookProfileDetails:(NSDictionary *)profileDetails withSuccess:(BOOL)isSuccess{
    if (isSuccess == YES) {
        NSMutableDictionary *profileData = [[NSMutableDictionary alloc] init];
        [profileData setValue:[NSString stringWithFormat:@"%@",[profileDetails valueForKey:@"name"]] forKey:@"name"];
        [profileData setValue:[profileDetails valueForKey:@"email"] forKey:@"emailID"];
        [profileData setValue:[profileDetails valueForKey:@"id"] forKey:@"fbid"];
        [self loginFromSocialSite:(NSDictionary *)profileData];
        
    } else {
        
    }
}


- (IBAction)didTapToLinkedInLogin:(id)sender {
    [[LinkedINAPIFunction sharedManager] didLinkedINLogin];
}

#pragma mark - LinkedIn Delegate methods
#pragma mark -------------------------------------------


-(void)LinkedINSuccessFull{
    isLinkedInLoginSuccess =YES;
    [[LinkedINAPIFunction sharedManager] fetchUserProfileDetails];
}

-(void)LinkedINProfileDetails:(NSDictionary *)profileDetails{
    if (isLinkedInLoginSuccess == YES) {
        [self.indc stopAnimating];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setValue:[[[profileDetails valueForKey:@"values"] objectAtIndex:[[profileDetails valueForKey:@"values"] count]-1] valueForKey:@"formattedName"] forKey:@"name"];
        [userData setValue:[[[profileDetails valueForKey:@"values"] objectAtIndex:[[profileDetails valueForKey:@"values"] count]-1] valueForKey:@"emailAddress"] forKey:@"emailID"];
        [self loginFromSocialSite:(NSDictionary *)userData];
        NSLog(@"%@",profileDetails);
        isLinkedInLoginSuccess = NO;
    }
}

-(void)LinkedINNotSuccessFull{
    [self.indc stopAnimating];
//   NSLog(@"%@");
}

#pragma mark - GoogleOAuth Delegate methods
#pragma mark -------------------------------------------

-(void)authorizationWasSuccessful{
    [_googleOAuth callAPI:@"https://www.googleapis.com/oauth2/v1/userinfo"
           withHttpMethod:httpMethod_GET
       postParameterNames:nil postParameterValues:nil];
}


-(void)accessTokenWasRevoked{
}

-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData profileDetail:(NSMutableDictionary *)profileData{
    _mGmailLoginView.hidden = YES;
    [self.navigationController.navigationBar setHidden:NO];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
    [userData setValue:[profileData valueForKey:@"userName"] forKey:@"name"];
    [userData setValue:[profileData valueForKey:@"userId"] forKey:@"emailID"];
    [self loginFromSocialSite:(NSDictionary *)profileData];

}


-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails{
    [self.indc stopAnimating];
    NSLog(@"%@", errorShortDescription);
    NSLog(@"%@", errorDetails);
}


-(void)errorInResponseWithBody:(NSString *)errorMessage{
    [self.indc stopAnimating];
    NSLog(@"%@", errorMessage);
}

#pragma mark - Facebook Delegate methods
#pragma mark -------------------------------------------


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        FBRequest* friendsRequest = [FBRequest requestForMe];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            NSMutableDictionary *profileData = [[NSMutableDictionary alloc] init];
            [profileData setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"name"]] forKey:@"name"];
            [profileData setValue:[NSString stringWithFormat:@"%@@facebook.com",[result valueForKey:@"username"]] forKey:@"emailID"];
            [self loginFromSocialSite:(NSDictionary *)profileData];
        }];
       return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        [self.indc stopAnimating];
        // Show the user the logged-out UI
    }
    
    // Handle errors
    if (error){
        [self.indc stopAnimating];
        NSLog(@"Error");
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        } else {
            
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        }
    }
}
#pragma mark - Yahoo Delegate methods
#pragma mark -------------------------------------------

- (void)LoginDidFinish:(NSDictionary *)data{
    ;
    [[YahooHandler SharedInstance]getUserProfile:self didFinishSelector:@selector(GetUserDetailsDidFinish:) didFailSelector:@selector(GetUserDetailsDidFail:)];
}

- (void)LoginDidFail:(NSDictionary *)data{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YAHOO!" message:@"Not Found on Accelerator: social.yahooapis.com. Thank you for your patience. Our engineers are working quickly to resolve the issue." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
}
- (void)GetUserDetailsDidFinish:(NSDictionary *)data{
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
    [userData setValue: [NSString stringWithFormat:@"%@ %@",[[data valueForKey:@"profile"] valueForKey:@"givenName"],[[data valueForKey:@"profile"] valueForKey:@"familyName"]] forKey:@"name"];
    [userData setValue:[[[[data valueForKey:@"profile"] valueForKey:@"emails"] objectAtIndex:0] valueForKey:@"handle"]forKey:@"emailID"];
    [self loginFromSocialSite:(NSDictionary *)userData];
    NSLog(@"yahoo:%@",data);
}

- (void)GetUserDetailsDidFail:(NSDictionary *)data{
    [self.indc stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YAHOO!" message:@"Not Found on Accelerator: social.yahooapis.com. Thank you for your patience. Our engineers are working quickly to resolve the issue." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
    NSLog(@"yahoo:%@",data);
    
}


#pragma mark - Form Validation
#pragma mark -------------------------------------------


- (BOOL) validatemailid: (NSString *) candidate {
    NSString *numericRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}





-(NSString *) validateLogin{
    
    if(self.email.text.length<=0 )
    {
        return @"Email cannot be left blank";
        
    }
    
    if([self validatemailid:email.text] !=1)
        
    {
        
        return @"Email is not in correct format";
    }
    
    
    if(password.text.length <=0 )
    {
        return @"Password cannot be left blank";
        
    }
    
    return @"1";
}
#pragma mark - Registration With Social Login
#pragma mark -------------------------------------------

-(void)loginFromSocialSite : (NSDictionary *)profiledata{
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    
    userModel.name = [profiledata valueForKey:@"name"];
    
    userModel.email = [profiledata valueForKey:@"emailID"];
    userModel.fbid = [profiledata valueForKey:@"fbid"];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    userModel.deviceToken = appD.deviceTokenString;
    userModel.deviceType = @"I";
    userModel.userid = @"";
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    
    userController.delegate = self;
    
    [userController social_Login:userModel];
    
    [self.view setUserInteractionEnabled:NO];
    
    [self.indc startAnimating];
}

@end
