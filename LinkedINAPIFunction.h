//
//  LinkedINAPIFunction.h
//  FBAPILibaryFunction
//
//  Created by Bhaskar on 25/02/14.
//  Copyright (c) 2014 Bhaskar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthLoginView.h"
@protocol LinkedINAPIFunctionDelegates <NSObject>

@optional

-(void)LinkedINSuccessFull;
-(void)LinkedINNotSuccessFull;
-(void)LinkedINShareComplete;
-(void)LinkedINFriendList : (NSDictionary *)friendDetails;
-(void)LinkedINProfileDetails : (NSDictionary *)profileDetails;

@end

@interface LinkedINAPIFunction : NSObject<OAuthDelegate>{
    OAuthLoginView *linkedin;
}

@property (nonatomic,strong) id <LinkedINAPIFunctionDelegates> delegate;

+ (id)sharedManager;
- (void)createLogINViewwithAPISecretKey : (NSString *)apiKey withSecretKey : (NSString *)secretKey;
- (void)didLinkedINLogin;
- (void)didLinkedINLogout;
- (void)getLinkedINContactFetch;
- (void)fetchUserProfileDetails;
- (void)postMessageInLinkedINwithSubject : (NSString *)subject message:(NSString *)textMessage FriendID:(NSString *)friendId;
//comment = "comment goes here";
//content =     {
//    description = "description goes here";
//    submittedImageUrl = "http://economy.blog.ocregister.com/files/2009/01/linkedin-logo.jpg";
//    submittedUrl = "www.google.com";
//    title = "title goes here";
//};
//visibility =     {
//    code = anyone;
//};

- (void)shareAnUpdate :(NSDictionary *)param;
@end
