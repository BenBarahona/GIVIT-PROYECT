//
//  LinkedINAPIFunction.m
//  FBAPILibaryFunction
//
//  Created by Bhaskar on 25/02/14.
//  Copyright (c) 2014 Bhaskar. All rights reserved.
//

#import "LinkedINAPIFunction.h"
@implementation LinkedINAPIFunction

#pragma mark Singleton Methods

+ (LinkedINAPIFunction *)sharedManager {
    static LinkedINAPIFunction *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

-(void)createLogINViewwithAPISecretKey:(NSString *)apiKey withSecretKey:(NSString *)secretKey{
//    APIKeySecretKey:@"ok0ktu3pdj67"
//    SecretKey:@"GgEcT0AGuP7N75di"
    linkedin=[[OAuthLoginView alloc]initWithAPIKeySecretKey:apiKey SecretKey:secretKey Delegate:(id)self];
}

-(void)didLinkedINLogin{
    [linkedin Login:NO];
}

-(void)didLinkedINLogout{
    [linkedin LogoutFromLinkedIn];
}

-(void)getLinkedINContactFetch{
    [linkedin GetLinkedInContacts];
}

-(void)fetchUserProfileDetails{
    [linkedin GetUserProfile];
}

-(void)postMessageInLinkedINwithSubject:(NSString *)subject message:(NSString *)textMessage FriendID:(NSString *)friendId{
    [linkedin PostLinkedInMessage:subject message:textMessage FriendID:friendId];
}

-(void)shareAnUpdate:(NSDictionary *)param{
    [linkedin postUpdateHERE:param];
}

#pragma mark OAuthDelegate Methods


-(void)TokenReceiveFailed:(NSData *)error{
    NSLog(@"TOKEN RECEIVED FAILED");
}
-(void)TokenReceiveSuccessful:(OAToken*)token{
    NSLog(@"TOKEN RECEIVED %@",token);
}
-(void)LoginSuccessful{
    NSLog(@"LOGIN SUCCESS");
    [self.delegate LinkedINSuccessFull];
}

-(void)LoginFailed{
    NSLog(@"LOGIN FAILED");
    [self.delegate LinkedINNotSuccessFull];
}

-(void)LogOutFailed{
    [self showingMessage:@"LoOut Failed" withSuccess:NO];
}

-(void)LogOutSuccessful{
}
-(void)GetLinkedInContactsDidFinish:(NSMutableDictionary *)contacts{
    NSLog(@"contacts %@",contacts);
    if (self.delegate) {
        [self.delegate LinkedINFriendList:(NSDictionary *)contacts];
    }
}

-(void)GetLinkedInContactsDidFail:(NSData *)error{
    [self showingMessage:@"Fetching Contacts Failed!" withSuccess:YES];
}

-(void)GetLinkedInUserProfileDidFinish:(NSMutableDictionary *)contacts{
    if (self.delegate) {
        [self.delegate LinkedINProfileDetails:(NSDictionary *)contacts];
    }
}

-(void)GetLinkedInUserProfileDidFail:(NSData *)error{
    [self showingMessage:@"Fetching ProfileDetails Failed!" withSuccess:YES];
}

-(void)LinkedInMessagePostSuccessful{
    [self showingMessage:@"Message share to Friend SucessFul" withSuccess:YES];
}
-(void)LinkedInMessagePostFailed:(NSData *)error{
    [self showingMessage:@"Message share to Friend Faild!" withSuccess:YES];
}
-(void)LinkedInPostSuccessful{
    [self showingMessage:@"Message Share SucessFul" withSuccess:YES];
}
-(void)LinkedInPostFailed:(NSData *)error{
    [self showingMessage:@"Message Share Faild!" withSuccess:YES];

}
-(void)showingMessage : (NSString *)message withSuccess :(BOOL) isSuccess{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
//    [alert show];
    if (self.delegate) {
        if (isSuccess == YES) {
        }
        else{
        }
    }
}



@end
