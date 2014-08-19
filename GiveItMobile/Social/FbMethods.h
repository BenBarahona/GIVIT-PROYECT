//
//  FbMethods.h
//  SocialFram
//
//  Created by Bhaskar on 14/03/14.
//  Copyright (c) 2014 Bhaskar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#pragma mark FbMethodsDelegate Methodes

@protocol FbMethodsDelegate <NSObject>

@optional
/*
 * Response after Login.
 */
-(void)FacebookLoginSuccessFull;
-(void)FacebookLoginFaliur;
/*
 * Response after Logout.
 */
-(void)FacebookLogoutSuccessFull;
/*
 * Response after Share.
 */
-(void)FacebookShareCompletewithResult : (BOOL)isSuccess;
/*
 * Response after sending request.
 */
-(void)FacebookAppRequestComplete : (BOOL)isSuccess;
/*
 * Response after fetching freindlist.
 */
-(void)FacebookFriendList : (NSArray *)friendDetails withSuccess : (BOOL)isSuccess;
/*
 * Response after fetching profileDetails.
 */
-(void)FacebookProfileDetails : (NSDictionary *)profileDetails withSuccess : (BOOL)isSuccess;
/*
 * Response after fetching event.
 */
-(void)FacebookEventDetail : (NSArray *)events withSuccess : (BOOL)isSuccess;
@end

@interface FbMethods : NSObject
@property (strong, nonatomic) FBSession *session;
@property (nonatomic,strong) id <FbMethodsDelegate> delegate;

#pragma mark FBCall Methodes


+ (id)sharedManager;
/*
 * FaceBook Login.
 */
- (void)didFacebookLogin;
/*
 * FaceBook Logout.
 */
- (void)didFacebookLogout;
/*
 * Get Personal Detail.
 */
- (void)getPersonalDetails;
/*
 * Get FaceBook friendlist with details.
 */
- (void)getFacebookFriendListwithDetail;

/*
 * Calling Style
 * [[FbMethods sharedManager] getProfileImagewithID:userID withImage:^(UIImage *image){
   }];
 */
- (void)getProfileImagewithID : (NSString *) userID withImage:(void(^)(UIImage *))finishBlock;

/*NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
 @"Sharing Tutorial", @"name",
 @"Build great social apps and get more installs.", @"caption",
 @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
 @"http://sparku.blogspot.in/", @"link",
 @"http://1.bp.blogspot.com/_4XxSdOLTMy0/S2-mphOlNbI/AAAAAAAAACQ/Z0Co7rcczCc/S220-h/DSC00247.JPG", @"picture",
 nil];*/
- (void)shareFeedwithParam:(NSDictionary *)param;
/*
 * Share image
 */

- (void)shareImage : (UIImage *)image;
/*
 * Share Video
 */
- (void)shareVideo : (NSString *)videoPath;

-(void)syncFaceBookEvent;
-(void)isDeleteEventByID : (NSString *)eventID;
/*
 * Freinds using app.
 */

- (void)isUsingApp;

/*
 * Send request to Selected Freinds.
 */
//NSArray *suggestedFriends = [[NSArray alloc] initWithObjects:
//                             @"100000681410357", @"100000592133960", @"100007633297182",
//                             nil];
- (void)sendRequestToSelectedFriendsWithID:(NSArray *)suggestedFriends withMessage : (NSString *)message withTitle : (NSString *)title;

/*
 * Send request to iOS device users.
 */
- (void)sendRequestToiOSFriendswithMessage : (NSString *)message withTitle : (NSString *)title;

/*
 * Send request to Android device users.
 */
- (void)sendRequestToAndroidFriendswithMessage : (NSString *)message withTitle : (NSString *)title;

/*
 * Send request to All Freinds.
 */
- (void)sendRequestToAllFriendswithMessage : (NSString *)message withTitle : (NSString *)title;

- (void)handleAppLinkData:(FBAppLinkData *)appLinkData;
- (BOOL)handleAppLinkToken:(FBAccessTokenData *)appLinkToken;
@end
