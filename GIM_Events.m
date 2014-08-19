//
//  GIM_Events.m
//  GiveItMobile
//
//  Created by Bhaskar on 06/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_Events.h"
#import "GIM_Eventlist.h"
#import "RootViewController.h"
@interface GIM_Events ()

@end

@implementation GIM_Events
@synthesize totalEvent;
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
    calendar = [[VRGCalendarView alloc] init];
    [calendar setCenter:CGPointMake(self.view.frame.size.width/2, calendar.frame.size.height/2)];
    calendar.delegate=(id)self;
    calendar.tag = 100;
    [_mScrollView setContentSize:CGSizeMake(320, 420)];
    [_mScrollView addSubview:calendar];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"Events";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    
    userController.delegate = (id)self;
    
    [userController events_user:userModel];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    currentMonth = month;
    currentYear = [[calendarView currentMonth] year];
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < self.totalEvent.count; i++) {
        NSArray *bArr = [[[self.totalEvent objectAtIndex:i] valueForKey:@"date"] componentsSeparatedByString:@"-"];
        if (currentMonth == [[bArr objectAtIndex:1] intValue] && currentYear == [[bArr objectAtIndex:0] intValue]) {
            [dates addObject:[NSNumber numberWithInt:[[bArr objectAtIndex:2] intValue]]];
        }
    }
    NSMutableArray *fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBEvents"]];
    for (int i = 0 ; i < fbEvent.count; i++) {
        NSArray *bArr = [[[fbEvent objectAtIndex:i] valueForKey:@"date"] componentsSeparatedByString:@"-"];
        if (currentMonth == [[bArr objectAtIndex:1] intValue] && currentYear == [[bArr objectAtIndex:0] intValue] ) {
            [dates addObject:[NSNumber numberWithInt:[[bArr objectAtIndex:2] intValue]]];
        }
    }
    fbEvent = nil;
    fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"GmailEvents"]];
    for (int i = 0 ; i < fbEvent.count; i++) {
        NSArray *bArr = [[[fbEvent objectAtIndex:i] valueForKey:@"date"] componentsSeparatedByString:@"-"];
        if (currentMonth == [[bArr objectAtIndex:1] intValue] && currentYear == [[bArr objectAtIndex:0] intValue] ) {
            [dates addObject:[NSNumber numberWithInt:[[bArr objectAtIndex:2] intValue]]];
        }
    }
   [calendar markDates:dates];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    selectedDate = date;
    [self performSegueWithIdentifier:@"segueToEvent" sender:self];
}


#pragma mark Perform Segue
#pragma mark -------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueToEvent"]){
        GIM_Eventlist *event = [segue destinationViewController];
        event.currentDate = selectedDate;
        event.paymentDict = _paymentDict;
    }
}
#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------

-(void)didError:(NSString *)msg{
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



-(void)didTotalEvent:(NSArray *)msg isSuccess:(BOOL)isSuccess{
    [self.view setUserInteractionEnabled:YES];
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    if(isSuccess){
        self.totalEvent = [NSMutableArray arrayWithArray:msg];
        for (int i = 0 ; i < msg.count; i++) {
            NSArray *bArr = [[[msg objectAtIndex:i] valueForKey:@"date"] componentsSeparatedByString:@"-"];
            if (currentMonth == [[bArr objectAtIndex:1] intValue] && currentYear == [[bArr objectAtIndex:0] intValue] ) {
                [dates addObject:[NSNumber numberWithInt:[[bArr objectAtIndex:2] intValue]]];
            }
        }
        
    }
    NSMutableArray *fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBEvents"]];
    for (int i = 0 ; i < fbEvent.count; i++) {
        NSArray *bArr = [[[fbEvent objectAtIndex:i] valueForKey:@"date"] componentsSeparatedByString:@"-"];
        if (currentMonth == [[bArr objectAtIndex:1] intValue] && currentYear == [[bArr objectAtIndex:0] intValue] ) {
            [dates addObject:[NSNumber numberWithInt:[[bArr objectAtIndex:2] intValue]]];
        }
    }
    fbEvent = nil;
    fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"GmailEvents"]];
    for (int i = 0 ; i < fbEvent.count; i++) {
        NSArray *bArr = [[[fbEvent objectAtIndex:i] valueForKey:@"date"] componentsSeparatedByString:@"-"];
        if (currentMonth == [[bArr objectAtIndex:1] intValue] && currentYear == [[bArr objectAtIndex:0] intValue] ) {
            [dates addObject:[NSNumber numberWithInt:[[bArr objectAtIndex:2] intValue]]];
        }
    }
    [calendar markDates:dates];
}
- (IBAction)didTapTosyncFacebookEvent:(id)sender {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"friends_events",@"user_events"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             [self.view setUserInteractionEnabled:NO];
            [self sessionStateChanged:session state:state error:error];
         }];
    }
    else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"friends_events",@"user_events"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             [self.view setUserInteractionEnabled:NO];
            [self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (IBAction)didTapToSyncGoogleEvent:(id)sender {
    NSLog(@"Session opened %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"RememberGmail"]);
   
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"RememberGmail"]isEqualToString:@"Yes"]) {
        RootViewController *gmailEvent = [[RootViewController alloc] initWithCoder:nil];
        gmailEvent.gmailUserID = [[NSUserDefaults standardUserDefaults] valueForKey:@"GmailID"];
        gmailEvent.gmailPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"GmailPassword"];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"GmailPassword"],@"Password",[[NSUserDefaults standardUserDefaults] valueForKey:@"GmailID"],@"ID", nil];
        [gmailEvent syncCalander:dict];
    }
    else{
        [self performSegueWithIdentifier:@"seguegmailLogin" sender:self];
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
//        [self userLoggedIn];
        [self syncEvent];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        [self.view setUserInteractionEnabled:YES];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        } else {
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self.view setUserInteractionEnabled:YES];
    }
}


-(void)syncEvent{
    NSString *query =
    @"{"
    @"'event_info':'SELECT eid, venue, name, start_time, end_time, creator, host ,description, attending_count from event WHERE eid in (SELECT eid FROM event_member WHERE uid = me())',"
    @"'event_venue':'SELECT name, location, page_id FROM page WHERE page_id IN (SELECT venue.id FROM #event_info)',"
    @"}";
    NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                query, @"q", nil];
    
    [FBRequestConnection startWithGraphPath:@"/fql" parameters:queryParam
                                 HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection,
                                                                       id result, NSError *error) {
                                     if (error) {
                                         NSLog(@"Error: %@", [error localizedDescription]);
                                     } else {
                                         
                                         NSArray* data = [result objectForKey:@"data"];
                                         NSArray* events = [((NSDictionary*) data[0]) objectForKey:@"fql_result_set"];
                                         NSArray* venues = [((NSDictionary*) data[1]) objectForKey:@"fql_result_set"];
                                         NSMutableArray * fbEvent = [[NSMutableArray alloc] init];
                                         NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                         NSLog(@"Result: %@ ",events);
                                         NSLog(@"Result: %@ ",venues);
                                         for (int i= 0; i<events.count; i++) {
                                             NSLog(@"title %@",[[events objectAtIndex:i] valueForKey:@"name"]);
                                             NSLog(@"description %@",[[events objectAtIndex:i] valueForKey:@"description"]);
                                             NSLog(@"date %@",[[events objectAtIndex:i] valueForKey:@"start_time"]);
                                             [dict setValue:[[events objectAtIndex:i] valueForKey:@"name"] forKey:@"title"];
                                             [dict setValue:[[events objectAtIndex:i] valueForKey:@"description"] forKey:@"description"];
                                             [dict setValue:[[events objectAtIndex:i] valueForKey:@"start_time"] forKey:@"date"];
                                             if (venues.count>i) {
                                                 [dict setValue:[[venues objectAtIndex:i] valueForKey:@"name"] forKey:@"timezone"];
                                                 [dict setValue:[[venues objectAtIndex:i] valueForKey:@"name"] forKey:@"location"];
                                             }
                                             [fbEvent addObject:[dict copy]];
                                             [dict removeAllObjects];
                                         }
                                         NSLog(@"Result: %@ ",fbEvent);
                                         [[NSUserDefaults standardUserDefaults] setObject:fbEvent forKey:@"FBEvents"];
                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                         [self.view setUserInteractionEnabled:NO];
                                         GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
                                         userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
                                         GIM_UserController *userController = [[GIM_UserController alloc]init];
                                         
                                         userController.delegate = (id)self;
                                         
                                         [userController events_user:userModel];
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Facebook events sync completed" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                         [alert show];
                                     }        
                                 }];
}
@end
