//
//  GmailSync.m
//  GiveItMobile
//
//  Created by Bhaskar on 14/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GmailSync.h"

@implementation GmailSync

-(void)checkLogin:(NSDictionary *)userData FetchContact : (BOOL)isFetch{
    data = [NSMutableDictionary dictionaryWithDictionary:userData];
    isContactFetch = isFetch;
    [self getContact];
}

-(void)getContact
{
    NSLog(@">>>>>>>>>> get Contact Pressed");
    GDataServiceGoogleContact *service = [self contactService];
    GDataServiceTicket *ticket;
    
    BOOL shouldShowDeleted = TRUE;
    
    // request a whole buncha contacts; our service object is set to
    // follow next links as well in case there are more than 2000
    const int kBuncha =2000;
    
    NSURL *feedURL = [GDataServiceGoogleContact contactFeedURLForUserID:kGDataServiceDefaultUser];
    
    GDataQueryContact *query = [GDataQueryContact contactQueryWithFeedURL:feedURL];
    [query setShouldShowDeleted:shouldShowDeleted];
    [query setMaxResults:kBuncha];
    
    ticket = [service fetchFeedWithQuery:query
                                delegate:self
                       didFinishSelector:@selector(contactsFetchTicket:finishedWithFeed:error:)];
    
    [self setContactFetchTicket:ticket];
}

- (GDataServiceGoogleContact *)contactService
{
    static GDataServiceGoogleContact* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleContact alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // update the username/password each time the service is requested
    
    //    [service setUserCredentialsWithUsername:gmailID
    //                                   password:gmailpass];
    
    [service setUserCredentialsWithUsername:[data valueForKey:@"userID"]
                                   password:[data valueForKey:@"password"]];
    
    return service;
}

// contacts fetched callback
- (void)contactsFetchTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedContact *)feed
                      error:(NSError *)error {
    
    if (error) {
        NSLog(@">>>>>>>>>>>>>>>> Fetch error :%@", [error description]);
        if (_delegate) {
            [_delegate didGmailSignInError:[error description]];
        }
        return;
    }
    if (isContactFetch == YES) {
        NSArray *contacts = [feed entries];
        NSMutableArray *arrData = [[NSMutableArray alloc] init];
        for (int i = 0; i < [contacts count]; i++) {
            GDataEntryContact *contact = [contacts objectAtIndex:i];
            NSLog(@">>>>>>>>>>>>>>>> elementname contact :%@", [[[contact name] fullName] contentStringValue]);
            NSString *ContactName = [[[contact name] fullName] contentStringValue];
            GDataEmail *email = [[contact emailAddresses] objectAtIndex:0];
            NSLog(@">>>>>>>>>>>>>>>> Contact's email id :%@", [email address]);
            NSString *ContactEmail = [email address];
            
            if (!ContactName || !ContactEmail) {
                NSLog(@">>>>>>>>>>>>> in if loop\n\n");
            }
            else
            {
                NSArray *keys = [[NSArray alloc] initWithObjects:@"name", @"username", nil];
                NSArray *objs = [[NSArray alloc] initWithObjects:ContactName, ContactEmail, nil];
                NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
                [arrData addObject:dict];
            }
        }
        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                        ascending:YES selector:@selector(localizedStandardCompare:)] ;
        NSArray *sa = [arrData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        [arrData removeAllObjects];
        arrData = Nil;
        arrData = [[NSMutableArray alloc] initWithArray:sa];
        for (int i=0 ; i<arrData.count ; ) {
            unichar ch = [[[arrData objectAtIndex:i] valueForKey:@"name"] characterAtIndex:0];
            NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
            if (![letters characterIsMember:ch]) {
                [arrData addObject:[[arrData objectAtIndex:i] copy]];
                [arrData removeObjectAtIndex:i];
            }
            else{
                break;
            }
        }
        NSLog(@"x=%@",arrData);
        [[NSUserDefaults standardUserDefaults] setValue:arrData forKey:@"GmailContacts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (_delegate) {
            [_delegate didFinishGmailSync];
        }
    }
    else{
        if (_delegate) {
            [_delegate didGmailSignInComplete];
        }
    }
}
- (NSArray *)sortedEntries:(NSArray *)entries
{
    NSSortDescriptor *sortDesc;
    SEL sel = @selector(caseInsensitiveCompare:);
    
    sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"title"
                                            ascending:YES
                                             selector:sel] autorelease];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDesc];
    entries = [entries sortedArrayUsingDescriptors:sortDescriptors];
    return entries;
}

- (void)setContactFetchTicket:(GDataServiceTicket *)ticket
{
    [mContactFetchTicket release];
    mContactFetchTicket = [ticket retain];
}

@end
