//
//  GmailSync.h
//  GiveItMobile
//
//  Created by Bhaskar on 14/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GData.h"
#import "GDataFeedContact.h"
#import "GDataContacts.h"
@protocol gmailDelegate <NSObject>

@optional
-(void)didFinishGmailSync;
-(void)didGmailSignInComplete;
-(void)didGmailSignInError : (NSString *)error;

@end
@interface GmailSync : NSObject
{
    GDataFeedContact *mContactFeed;
    GDataServiceTicket *mContactFetchTicket;
    NSError *mContactFetchError;
    
    NSString *mContactImageETag;
    
    GDataFeedContactGroup *mGroupFeed;
    GDataServiceTicket *mGroupFetchTicket;
    NSError *mGroupFetchError;
    NSMutableDictionary *data;
    BOOL isContactFetch;
}
@property (nonatomic,strong) id <gmailDelegate> delegate;
-(void)checkLogin:(NSDictionary *)userData FetchContact : (BOOL)isFetch;
-(void)getContact;
- (void)setContactFetchTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleContact *)contactService;
- (NSArray *)sortedEntries:(NSArray *)entries;

@end
