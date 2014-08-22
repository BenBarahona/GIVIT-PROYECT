//
//  GIM_SocialSynViewController.m
//  GiveItMobile
//
//  Created by Administrator on 20/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_SocialSynViewController.h"
#import "GmailSync.h"
@interface GIM_SocialSynViewController ()

@end

@implementation GIM_SocialSynViewController
@synthesize sessionYahoo;
@synthesize oauthResponse;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mGmailLoginView.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
    [self customNavigationButton];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"button.font"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    if ([tabHome isKindOfClass:[CustomButtonTabController class]]) {
        [tabHome setCustomNavigationViewFrame:tabHome.view.frame];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    if ([tabHome isKindOfClass:[CustomButtonTabController class]]) {
        [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
    }
}

- (IBAction)btnContinue:(id)sender {
    if (_delegate) {
        [_delegate didFinishSync:syncType];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToSingle" object:nil userInfo:nil];
    }];
    
    
}



- (IBAction)didTapToFacebookLoggin:(id)sender {
    //[self.view setUserInteractionEnabled:NO];
//    if (FBSession.activeSession.state == FBSessionStateOpen
//        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
//        
//        // Close the session and remove the access token from the cache
//        // The session state handler (in the app delegate) will be called automatically
////        [FBSession.activeSession closeAndClearTokenInformation];
//        [self saveFBFriendList];
//        // If the session state is not any of the two "open" states when the button is clicked
//    }
//    else {
//        // Open a session showing the user the login UI
//        // You must ALWAYS ask for basic_info permissions when opening a session
//        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
//                                           allowLoginUI:YES
//                                      completionHandler:
//         ^(FBSession *session, FBSessionState state, NSError *error) {
//             
//             [self sessionStateChanged:session state:state error:error];
//         }];
//    }
    [[FbMethods sharedManager] setDelegate:(id)self];
    [[FbMethods sharedManager] getFacebookFriendListwithDetail];
<<<<<<< HEAD
=======
    
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
>>>>>>> FETCH_HEAD
}

-(void)FacebookFriendList:(NSArray *)friendDetails withSuccess:(BOOL)isSuccess{
    if (isSuccess == YES) {
        [[NSUserDefaults standardUserDefaults] setValue:friendDetails forKey:@"FBContacts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showMessage:@"Contact synchronization completed" withTitle:@"Alert!"];
        syncType = @"FBContacts";
        [self.view setUserInteractionEnabled:YES];
<<<<<<< HEAD
        [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
=======
>>>>>>> FETCH_HEAD
    }
}

- (IBAction)didTapToFetchLocalContacts:(id)sender {
    //[self.view setUserInteractionEnabled:NO];
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                NSLog(@"Access granted!");
                [self addressBookLoader];
           } else {
                NSLog(@"Access denied!");
            }
        });
    }
    else{
        [self addressBookLoader];
    }
<<<<<<< HEAD
=======
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
>>>>>>> FETCH_HEAD
}

-(void)didTapToFetchLinkedInContacts:(id)sender{
    [[LinkedINAPIFunction sharedManager] setDelegate:(id)self];
    [[LinkedINAPIFunction sharedManager] didLinkedINLogin];
}
#pragma mark - LinkedIn Delegate methods
#pragma mark -------------------------------------------


-(void)LinkedINSuccessFull{
    [[LinkedINAPIFunction sharedManager] getLinkedINContactFetch];
}


-(void)LinkedINFriendList:(NSDictionary *)friendDetails{
    NSMutableArray *friend = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [[friendDetails valueForKey:@"_total"] intValue]; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[[friendDetails valueForKey:@"values"] objectAtIndex:i] valueForKey:@"formattedName"] forKey:@"name"];
        [dict setValue:[[[friendDetails valueForKey:@"values"] objectAtIndex:i] valueForKey:@"id"] forKey:@"username"];
        [dict setValue:[[[friendDetails valueForKey:@"values"] objectAtIndex:i] valueForKey:@"pictureUrl"] forKey:@"picture"];
        [friend addObject:dict];
    }
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                    ascending:YES selector:@selector(localizedStandardCompare:)] ;
    NSArray *sa = [friend sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [friend removeAllObjects];
    friend = Nil;
    friend = [[NSMutableArray alloc] initWithArray:sa];
    for (int i=0 ; i<friend.count ; ) {
        unichar ch = [[[friend objectAtIndex:i] valueForKey:@"name"] characterAtIndex:0];
        NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
        if (![letters characterIsMember:ch]) {
            [friend addObject:[[friend objectAtIndex:i] copy]];
            [friend removeObjectAtIndex:i];
        }
        else{
            break;
        }
    }
    [self showMessage:@"Contact synchronization completed" withTitle:@"Alert!"];
    syncType = @"LinkedInContacts";
    [[NSUserDefaults standardUserDefaults] setValue:friend forKey:@"LinkedInContacts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
<<<<<<< HEAD
    [self.view setUserInteractionEnabled:YES];
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
}
=======
    [self.view setUserInteractionEnabled:YES];}
>>>>>>> FETCH_HEAD

- (IBAction)didTapToFetchYahooContact:(id)sender {
    [[YahooHandler SharedInstance]Login:NO delegate:self didFinishSelector:@selector(LoginDidFinish:) didFailSelector:@selector(LoginDidFail:)];
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
}

- (IBAction)didTapToFetchGmailContacts:(id)sender {
    _mGmailLoginView.hidden = NO;
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
}

- (IBAction)didTapToSignInGmail:(id)sender {
    [_mGmailIdTextField resignFirstResponder];
    [_mGmailPasswordTextField resignFirstResponder];
    if (_mGmailIdTextField.text.length<=0) {
        [self showMessage:@"Email field can not be empty" withTitle:@"Alert!"];
        return;
    }
    else if (_mGmailPasswordTextField.text.length<=0) {
        [self showMessage:@"Password field can not be empty" withTitle:@"Alert!"];
        return;
    }
    else if ([self validatemailid:_mGmailIdTextField.text] == NO) {
        [self showMessage:@"EmailID not in correct format" withTitle:@"Alert!"];
        return;
    }
    else{
        //[self.view setUserInteractionEnabled:NO];
        NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:_mGmailIdTextField.text,@"userID",_mGmailPasswordTextField.text,@"password",nil];
        GmailSync *gmail = [[GmailSync alloc] init];
        [gmail checkLogin:value FetchContact:YES];
        gmail.delegate = (id)self;
        [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
    }
}


- (IBAction)didTapToCancelGmailSign:(id)sender {
    [_mGmailIdTextField resignFirstResponder];
    [_mGmailPasswordTextField resignFirstResponder];
    _mGmailIdTextField.text = nil;
    _mGmailPasswordTextField.text = nil;
    _mGmailLoginView.hidden = YES;
}

#pragma mark GmailSync delegate
#pragma mark -------------------------------------------

-(void)didFinishGmailSync{
    _mGmailLoginView.hidden = YES;
    [self showMessage:@"Contact synchronization completed" withTitle:@"Alert!"];
    syncType = @"GmailContacts";
    [self.view setUserInteractionEnabled:YES];
<<<<<<< HEAD
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
=======
>>>>>>> FETCH_HEAD
}
-(void)didGmailSignInError : (NSString *)error{
    [self showMessage:@"EmailID Password not match" withTitle:@"Welcome!"];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark ContactS Fetch
#pragma mark -------------------------------------------

-(void)addressBookLoader
{
    CFErrorRef *error = NULL;
    
    NSMutableArray *arrayofContacts =[[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,error);
    
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef sortedPeople =ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    
    //RETRIEVING THE FIRST NAME AND PHONE NUMBER FROM THE ADDRESS BOOK
    
    CFIndex number = CFArrayGetCount(sortedPeople);
    
    NSString *firstName;
    NSString *lastName;
    NSString *email ;
    
    for( int i=0;i<number;i++)
    {
        
        ABRecordRef person = CFArrayGetValueAtIndex(sortedPeople, i);
        firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        ABRecordRef personL = CFArrayGetValueAtIndex(sortedPeople, i);
        lastName = (__bridge NSString *)ABRecordCopyValue(personL, kABPersonLastNameProperty);
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        email = (__bridge NSString *) ABMultiValueCopyValueAtIndex(emails, 0);
        
        if(email != NULL)
        {
            if (lastName == Nil) {
                lastName = @"";
            }
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSString stringWithFormat:@"%@ %@",firstName,lastName] forKey:@"name"];
            [dict setValue:email forKey:@"username"];
            
            [arrayofContacts addObject:dict];
        }
    }
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                    ascending:YES selector:@selector(localizedStandardCompare:)] ;
    NSArray *sa = [arrayofContacts sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSLog(@"x=%@",arrayofContacts);
    [arrayofContacts removeAllObjects];
    arrayofContacts = Nil;
    arrayofContacts = [[NSMutableArray alloc] initWithArray:sa];
    for (int i=0 ; i<arrayofContacts.count ; ) {
        unichar ch = [[[arrayofContacts objectAtIndex:i] valueForKey:@"name"] characterAtIndex:0];
        NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
        if (![letters characterIsMember:ch]) {
            [arrayofContacts addObject:[[arrayofContacts objectAtIndex:i] copy]];
            [arrayofContacts removeObjectAtIndex:i];
        }
        else{
            break;
        }
    }
    [self showMessage:@"Contact synchronization completed" withTitle:@"Alert!"];
    syncType = @"LocalContacts";
    [[NSUserDefaults standardUserDefaults] setValue:arrayofContacts forKey:@"LocalContacts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.view setUserInteractionEnabled:YES];
<<<<<<< HEAD
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
=======
>>>>>>> FETCH_HEAD
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
    NSLog(@"yahoo:%@",data);
    [[YahooHandler SharedInstance]getUserContacts:self didFinishSelector:@selector(GetUserContactListDidFinish:) didFailSelector:@selector(GetUserContactListDidFail:)];
}
- (void)GetUserContactListDidFinish:(NSDictionary *)data{
    NSMutableArray *yahooTotalData = [NSMutableArray arrayWithArray:[[data valueForKey:@"contacts"] valueForKey:@"contact"]];
    NSMutableArray *yahooContact = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i=0; i<yahooTotalData.count; i++) {
        NSString *name = @"";
         NSString *email = @"";
        NSArray *fields =[NSArray arrayWithArray:[[yahooTotalData objectAtIndex:i] valueForKey:@"fields"]];
        for (int j=0; j<fields.count; j++) {
            if ([[[fields objectAtIndex:j] valueForKey:@"type"] isEqualToString:@"name"]) {
                name = [NSString stringWithFormat:@"%@ %@",[[[fields objectAtIndex:j] valueForKey:@"value"] valueForKey:@"givenName"],[[[fields objectAtIndex:j] valueForKey:@"value"] valueForKey:@"familyName"]];
            }
        }
        if (name.length>1) {
            for (int j=0; j<fields.count; j++) {
                if ([[[fields objectAtIndex:j] valueForKey:@"type"] isEqualToString:@"email"]) {
                    email = [[fields objectAtIndex:j] valueForKey:@"value"] ;
                    if (![self validatemailid:email]==YES) {
                        email = [NSString stringWithFormat:@"%@@yahoo.com",email] ;
                    }
                    
                }
            }
        }
        if (email.length>1 && name.length>1) {
            [dict setValue:name forKey:@"name"];
            [dict setValue:email forKey:@"username"];
            [yahooContact addObject:[dict copy]];
            [dict removeAllObjects];
        }
    }
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                    ascending:YES selector:@selector(localizedStandardCompare:)] ;
    NSArray *sa = [yahooContact sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [yahooContact removeAllObjects];
    yahooContact = Nil;
    yahooContact = [[NSMutableArray alloc] initWithArray:sa];
    for (int i=0 ; i<yahooContact.count ; ) {
        unichar ch = [[[yahooContact objectAtIndex:i] valueForKey:@"name"] characterAtIndex:0];
        NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
        if (![letters characterIsMember:ch]) {
            [yahooContact addObject:[[yahooContact objectAtIndex:i] copy]];
            [yahooContact removeObjectAtIndex:i];
        }
        else{
            break;
        }
    }
    [self showMessage:@"Contact synchronization completed" withTitle:@"Alert!"];
    syncType = @"YahooContacts";
    [[NSUserDefaults standardUserDefaults] setValue:yahooContact forKey:@"YahooContacts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
<<<<<<< HEAD
    [self performSegueWithIdentifier:@"ContactsSegue" sender:self];
=======
>>>>>>> FETCH_HEAD
}

- (void)GetUserContactListDidFail:(NSDictionary *)data{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YAHOO!" message:@"Not Found on Accelerator: social.yahooapis.com. Thank you for your patience. Our engineers are working quickly to resolve the issue." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
    NSLog(@"yahoo:%@",data);
    
}

- (void)GetUserDetailsDidFail:(NSDictionary *)data{
    ;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YAHOO!" message:@"Not Found on Accelerator: social.yahooapis.com. Thank you for your patience. Our engineers are working quickly to resolve the issue." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
    NSLog(@"yahoo:%@",data);
    
}


#pragma mark FacebookLogin
#pragma mark -------------------------------------------

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    [self.view setUserInteractionEnabled:YES];
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //[self.view setUserInteractionEnabled:NO];
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                [self.view setUserInteractionEnabled:YES];
               
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
            [self.view setUserInteractionEnabled:YES];
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    //    UIButton *loginButton = [self.customLoginViewController loginButton];
    //    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    //    UIButton *loginButton = self.customLoginViewController.loginButton;
    //    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    [self saveFBFriendList];
    // Welcome message
    
}

-(void)saveFBFriendList{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSMutableArray *friends = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", friends.count);
        for (int i=0; i<friends.count; i++) {
            NSString *username = [[friends objectAtIndex:i] valueForKey:@"username"];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[friends objectAtIndex:i]];
            [dict setValue:[NSString stringWithFormat:@"%@@facebook.com",username] forKey:@"username"];
            [friends replaceObjectAtIndex:i withObject:dict];
        }
        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                        ascending:YES selector:@selector(localizedStandardCompare:)] ;
        NSArray *sa = [friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [friends removeAllObjects];
        friends = Nil;
        friends = [[NSMutableArray alloc] initWithArray:sa];
        for (int i=0 ; i<friends.count ; ) {
            unichar ch = [[[friends objectAtIndex:i] valueForKey:@"name"] characterAtIndex:0];
            NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
            if (![letters characterIsMember:ch]) {
                [friends addObject:[[friends objectAtIndex:i] copy]];
                [friends removeObjectAtIndex:i];
            }
            else{
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setValue:friends forKey:@"FBContacts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showMessage:@"Contact synchronization completed" withTitle:@"Alert!"];
        syncType = @"FBContacts";
    }];
    [self.view setUserInteractionEnabled:YES];
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

#pragma mark Textfield Delegate
#pragma mark -------------------------------------------

-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL) validatemailid: (NSString *) candidate {
    NSString *numericRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}

-(void)customNavigationButton
{
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_next_arrow_01.png"] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"btn_next_arrow_02.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"btn_home_01.png"] forState:UIControlStateNormal];
    //[button1 setImage:[UIImage imageNamed:@"btn_home_02.png"] forState:UIControlStateHighlighted];
    button1.adjustsImageWhenDisabled = NO;
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, 30, 30);
    button1.frame = CGRectMake(0, 0, 30, 30);
    
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = customBarItem1;
}

-(IBAction)back:(id)sender{
    /*
    NSLog(@"%@", [self.navigationController viewControllers]);
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%@", [self.navigationController viewControllers]);
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%@", [self.navigationController viewControllers]);
     */
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
