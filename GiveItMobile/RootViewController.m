//
//  RootViewController.m
//  GoogleCalendar
//
//  Created by Dan Bourque on 4/26/09.
//  Copyright Dan Bourque 2009. All rights reserved.
//

#import "RootViewController.h"

//#import "DetailCell.h"

@implementation RootViewController

@synthesize googleCalendarService;

- (id)initWithCoder:(NSCoder *)aCoder{
  if( self=[super initWithCoder:aCoder] ){
    googleCalendarService = [[GDataServiceGoogleCalendar alloc] init];
    [googleCalendarService setUserAgent:@"DanBourque-GTUGDemo-1.0"];
    // We'll follow the links ourselves, so that we can show progress to our users between each batch.
    [googleCalendarService setServiceShouldFollowNextLinks:NO];
    data = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad{
  [super viewDidLoad];
	if (!eventListdictionary) {
        eventListdictionary=[[NSDictionary alloc] init];
    }
    if (!arraylist) {
        arraylist = [[NSMutableArray alloc] init];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.view.frame];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
}


#pragma mark Utility methods for searching index paths.

- (NSDictionary *)dictionaryForIndexPath:(NSIndexPath *)indexPath{
  if( indexPath.section<[data count] )
    return [data objectAtIndex:indexPath.section];
  return nil;
}

- (NSMutableArray *)eventsForIndexPath:(NSIndexPath *)indexPath{
  NSDictionary *dictionary = [self dictionaryForIndexPath:indexPath];
  if( dictionary )

    return [dictionary valueForKey:KEY_EVENTS];
  return nil;
}

- (GDataEntryCalendarEvent *)eventForIndexPath:(NSIndexPath *)indexPath{
  NSMutableArray *events = [self eventsForIndexPath:indexPath];
  if( events && indexPath.row<[events count] )
    return [events objectAtIndex:indexPath.row];
  return nil;
}

#pragma mark Google Data APIs

- (void)refresh{
  // Note: The next call returns a ticket, that could be used to cancel the current request if the user chose to abort early.
  // However since I didn't expose such a capability to the user, I don't even assign it to a variable.
  [data removeAllObjects];
//
  [googleCalendarService fetchCalendarFeedForUsername:self.gmailUserID
                                             delegate:self
                                    didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error: )];
    
    
    


}

- (void)handleError:(NSError *)error{
  NSString *title, *msg;
    [self.view setUserInteractionEnabled:YES];
    [_mActivityIndicator startAnimating];
  if( [error code]==kGDataBadAuthentication ){

    title = @"Authentication Failed";
    msg = @"Invalid username/password";
  }else{
    // some other error authenticating or retrieving the GData object or a 304 status
    // indicating the data has not been modified since it was previously fetched
    title = @"Unknown Error";
    msg = [error localizedDescription];
  }

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:msg
                                                 delegate:nil
                                        cancelButtonTitle:@"Ok"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
    [_mActivityIndicator stopAnimating];
}

- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error{
  if( !error ){
    int count = [[feed entries] count];
      NSMutableDictionary *dictionary;
      flag = count;
      completeFlag = 0;
    for( int i=0; i<count; i++ ){
      GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];

      // Create a dictionary containing the calendar and the ticket to fetch its events.
      dictionary = [[NSMutableDictionary alloc] init];
      [data addObject:dictionary];

      [dictionary setObject:calendar forKey:KEY_CALENDAR];
      [dictionary setObject:[[NSMutableArray alloc] init] forKey:KEY_EVENTS];


      NSURL *feedURL = [[calendar alternateLink] URL];
      if( feedURL ){
        GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];

        // Currently, the app just shows calendar entries from 15 days ago to 31 days from now.
        // Ideally, we would instead use similar controls found in Google Calendar web interface, or even iCal's UI.
        NSDate *minDate = [NSDate date];  // From right now...
        NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*365];  // ...to 90 days from now.

        [query setMinimumStartTime:[GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]]];
        [query setMaximumStartTime:[GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]]];
        [query setOrderBy:@"starttime"];  // http://code.google.com/apis/calendar/docs/2.0/reference.html#Parameters
        [query setIsAscendingOrder:YES];
        [query setShouldExpandRecurrentEvents:YES];

        GDataServiceTicket *ticket = [googleCalendarService fetchFeedWithQuery:query
                                                                      delegate:self
                                                             didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];
        // I add the service ticket to the dictionary to make it easy to find which calendar each reply belongs to.
        [dictionary setObject:ticket forKey:KEY_TICKET];
      }
        
               }
      
    
  }else
    [self handleError:error];
  

    
}

- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithEntries:(GDataFeedCalendarEvent *)feed error:(NSError *)error{
  if( !error ){    NSMutableDictionary *dictionary;
    for( int section=0; section<[data count]; section++ ){
      NSMutableDictionary *nextDictionary = [data objectAtIndex:section];
      GDataServiceTicket *nextTicket = [nextDictionary objectForKey:KEY_TICKET];
            if( nextTicket==ticket ){		// We've found the calendar these events are meant for...
        dictionary = nextDictionary;
        break;
      }

    }

    if( !dictionary )
      return;		// This should never happen.  It means we couldn't find the ticket it relates to.

    int count = [[feed entries] count];

    NSMutableArray *events = [dictionary objectForKey:KEY_EVENTS];
    for( int i=0; i<count; i++ )
      [events addObject:[[feed entries] objectAtIndex:i]];
      
      GDataEntryCalendar *calendar = [dictionary objectForKey:KEY_CALENDAR];
      GDataEntryCalendarEvent *event;
      int count1=[events count] ;
      NSMutableArray *titlearray=[[NSMutableArray alloc] init];
      [titlearray addObject:[NSString stringWithFormat:@"%@ (%i)", [[calendar title] stringValue], count]];
      NSMutableArray *eventtitlearray=[[NSMutableArray alloc] init];
      NSMutableArray *date_timeearray=[[NSMutableArray alloc] init];

      NSMutableDictionary *subtitledictionary = [[NSMutableDictionary alloc] init];
      NSMutableDictionary *datetimeedictionary = [[NSMutableDictionary alloc] init];

      for( int j=0; j<count1; j++ ){

         event = [events objectAtIndex:j];
          
      
      
          GDataWhen *when = [[event objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];

          if( when ){
            NSDate *date = [[when startTime] date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [eventtitlearray addObject:[dateFormatter stringFromDate:date]];
          }
//          GDataWhere *addr = [[event locations] objectAtIndex:0];
          [eventtitlearray addObject:[[event title] stringValue]];
          [eventtitlearray addObject:[[event content] stringValue]];

          
//          if( addr ){
//              
//          }
//          [subtitlearray addObject:[addr stringValue]];

          [subtitledictionary setObject:eventtitlearray forKey:@"event"];
          
          NSMutableArray* array1 = [subtitledictionary objectForKey:@"event"];
          if(!array1) {
              array1 = [NSMutableArray array];
              [subtitledictionary setObject:array1 forKey:@"event"];
          }
          [array1 addObject:datetimeedictionary];
      }
      NSMutableDictionary *maindictionary = [[NSMutableDictionary alloc] init];
      [maindictionary setObject:titlearray forKey:@"Title"];
      
      NSMutableArray* array= [maindictionary objectForKey:@"Title"];
      if(!array) {
          array = [NSMutableArray array];
          [maindictionary setObject:array forKey:@"Title"];
      }
      [array addObject:subtitledictionary];
      
      
      eventListdictionary=maindictionary;
    NSURL *nextURL = [[feed nextLink] URL];
    if( nextURL ){    // There are more events in the calendar...  Fetch again.
      GDataServiceTicket *newTicket = [googleCalendarService fetchFeedWithURL:nextURL
                                                                     delegate:self
                                                            didFinishSelector:@selector( eventsTicket:finishedWithEntries:error: )];   // Right back here...
      [dictionary setObject:newTicket forKey:KEY_TICKET];
    }

 

  }else{
    [self handleError:error];
}
    [self restoreEvent:[[[eventListdictionary valueForKey:@"Title"] objectAtIndex:1] valueForKey:@"event"]];
 
}

-(void)restoreEvent : (NSMutableArray *)dataEvent{
    NSLog(@"method call");
    completeFlag++;
    if (!arraylist) {
        arraylist = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (int i=0; i<[dataEvent count]; i+=4) {
        [dict setValue:[dataEvent objectAtIndex:i] forKey:@"date"];
        [dict setValue:[dataEvent objectAtIndex:i+1] forKey:@"title"];
        [dict setValue:[dataEvent objectAtIndex:i+2] forKey:@"description"];
        [arraylist addObject:[dict copy]];
        [dict removeAllObjects];
    }
    if (completeFlag==flag) {
        [self.view setUserInteractionEnabled:YES];
        [_mActivityIndicator startAnimating];
        [[NSUserDefaults standardUserDefaults] setObject:arraylist forKey:@"GmailEvents"];
        [[NSUserDefaults standardUserDefaults] setValue:self.gmailUserID forKey:@"GmailID"];
        [[NSUserDefaults standardUserDefaults] setValue:self.gmailPassword forKey:@"GmailPassword"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"RememberGmail"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Gmail events sync completed" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        if (self.delegate) {
            [self.delegate gmailsSyncComplete];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)deleteCalendarEvent:(GDataEntryCalendarEvent *)event{
  [googleCalendarService deleteEntry:event
                            delegate:self
                   didFinishSelector:nil];
}

- (void)insertCalendarEvent:(GDataEntryCalendarEvent *)event toCalendar:(GDataEntryCalendar *)calendar{
  [googleCalendarService fetchEntryByInsertingEntry:event
                                         forFeedURL:[[calendar alternateLink] URL]
                                           delegate:self
                                  didFinishSelector:@selector( insertTicket:finishedWithEntry:error: )];
}

- (void)insertTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryCalendarEvent *)entry error:(NSError *)error{
  if( !error )
    [self refresh];
  else
    [self handleError:error];
}

- (void)updateCalendarEvent:(GDataEntryCalendarEvent *)event{
  [googleCalendarService fetchEntryByUpdatingEntry:event
                                       forEntryURL:[[event editLink] URL]
                                          delegate:self
                                 didFinishSelector:nil];
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
        self.gmailUserID = _mGmailIdTextField.text;
        self.gmailPassword = _mGmailPasswordTextField.text;
      [googleCalendarService setUserCredentialsWithUsername:_mGmailIdTextField.text
                                                   password:_mGmailPasswordTextField.text];
        [self.view setUserInteractionEnabled:NO];
        [_mActivityIndicator startAnimating];
        [self refresh];
    }
}

-(void)syncCalander:(NSDictionary *)detail{
    [self.view setUserInteractionEnabled:NO];
    [googleCalendarService setUserCredentialsWithUsername:[detail valueForKey:@"ID"]
                                                 password:[detail valueForKey:@"Password"]];
    [data removeAllObjects];
    //
    [googleCalendarService fetchCalendarFeedForUsername:self.gmailUserID
                                               delegate:self
                                      didFinishSelector:@selector( calendarsTicket:finishedWithFeed:error: )];
    
}


- (IBAction)didTapToCancelGmailSign:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
@end