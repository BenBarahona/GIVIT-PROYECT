//
//  FbMethods.m
//  SocialFram
//
//  Created by Bhaskar on 14/03/14.
//  Copyright (c) 2014 Bhaskar. All rights reserved.
//

#import "FbMethods.h"

@implementation FbMethods
#pragma mark Singleton Methods

+ (FbMethods *)sharedManager {
    static FbMethods *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        [self checkFaceBookLoginSession];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



-(void)checkFaceBookLoginSession{
    if (!self.session.isOpen) {
        // create a fresh session object
        self.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (self.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [self.session openWithCompletionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                // we recurse here, Call delegate for Our Work
                
            }];
        }
    }
    
}


-(void)didFacebookLogin{
    if (!self.session.isOpen) {
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email"]
                                              allowLoginUI:YES
                                         completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
            // Call delegate for Our Work
            if (!error) {
                NSLog(@"LOGGING SucessFUL");
                if (self.delegate) {
                    [self.delegate FacebookLoginSuccessFull];
                }
            }
            else{
                if (self.delegate) {
                    [self.delegate FacebookLoginFaliur];
                }
            }
        }];
    }
    else{
        if (self.delegate) {
            [self.delegate FacebookLoginSuccessFull];
        }
    }
    
}

-(void)didFacebookLogout{
    // this button's job is to flip-flop the session from open to closed
    if (self.session.isOpen) {
        [self.session closeAndClearTokenInformation];
    }
    if (self.delegate) {
        [self.delegate FacebookLogoutSuccessFull];
    }
}

/*
 * Get Facebook friends Details
 */

-(void)getFacebookFriendListwithDetail{
    if (self.session.isOpen) {
        FBSession.activeSession = self.session;
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            if (!error) {
                NSMutableArray *friends = [result objectForKey:@"data"];
                for (int i=0; i<friends.count; i++) {
                    NSString *username = [[friends objectAtIndex:i] valueForKey:@"username"];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[friends objectAtIndex:i]];
                    [dict setValue:[NSString stringWithFormat:@"%@@facebook.com",username] forKey:@"useremail"];
                    [friends replaceObjectAtIndex:i withObject:dict];
                }
                NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                                ascending:YES selector:@selector(localizedStandardCompare:)] ;
                NSArray *sortedArray = [friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                [friends removeAllObjects];
                friends = Nil;
                friends = [[NSMutableArray alloc] initWithArray:sortedArray];
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
                if (self.delegate) {
                    [self.delegate FacebookFriendList:(NSArray *)friends withSuccess : YES];
                }

            }
            else{
                if (self.delegate) {
                    [self.delegate FacebookFriendList:nil withSuccess : NO];
                }
            }
        }];
    }
    else{
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
            // Call delegate for Our Work
            if (!error) {
                FBSession.activeSession = self.session;
                FBRequest* friendsRequest = [FBRequest requestForMyFriends];
                [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                              NSDictionary* result,
                                                              NSError *error) {
                    if (!error) {
                        NSMutableArray *friends = [result objectForKey:@"data"];
                        for (int i=0; i<friends.count; i++) {
                            NSString *username = [[friends objectAtIndex:i] valueForKey:@"username"];
                            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[friends objectAtIndex:i]];
                            [dict setValue:[NSString stringWithFormat:@"%@@facebook.com",username] forKey:@"useremail"];
                            [friends replaceObjectAtIndex:i withObject:dict];
                        }
                        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                                        ascending:YES selector:@selector(localizedStandardCompare:)] ;
                        NSArray *sortedArray = [friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                        [friends removeAllObjects];
                        friends = Nil;
                        friends = [[NSMutableArray alloc] initWithArray:sortedArray];
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
                        if (self.delegate) {
                            [self.delegate FacebookFriendList:(NSArray *)friends withSuccess : YES];
                        }
                        
                    }
                    else{
                        if (self.delegate) {
                            [self.delegate FacebookFriendList:nil withSuccess : NO];
                        }
                    }
                }];
            }
            else{
                if (self.delegate) {
                    [self.delegate FacebookFriendList:nil withSuccess : NO];
                }
            }
        }];
    }
}

/*
 * Get user Details
 */

-(void)getPersonalDetails{
    FBSession.activeSession = self.session;
    if (self.session.isOpen) {
         FBRequest* myRequest = [FBRequest requestForMe];
         [myRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error1) {
             
             if (!error1) {
                 if (self.delegate) {
                     [self.delegate FacebookProfileDetails:result withSuccess:YES];
                 }
             }
             else {
                 if (self.delegate) {
                     [self.delegate FacebookProfileDetails:nil withSuccess:NO];
                 }
             }
         }];
    }else{
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
            // Call delegate for Our Work
            if (!error) {
                [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email"]
                                                   allowLoginUI:YES
                                              completionHandler:
                 ^(FBSession *session, FBSessionState state, NSError *error) {
                     
                     if (!error){
                         FBRequest* myRequest = [FBRequest requestForMe];
                         [myRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                                  NSDictionary* result,
                                                                  NSError *error1) {
                             
                             if (!error1) {
                                 if (self.delegate) {
                                     [self.delegate FacebookProfileDetails:result withSuccess:YES];
                                 }
                             }
                             else {
                                 if (self.delegate) {
                                     [self.delegate FacebookProfileDetails:nil withSuccess:NO];
                                 }
                             }
                         }];
                     }
                     else{
                         if (self.delegate) {
                             [self.delegate FacebookProfileDetails:nil withSuccess:NO];
                         }
                     }
                 }];
            }
            else{
                if (self.delegate) {
                    [self.delegate FacebookProfileDetails:nil withSuccess:NO];
                }
            }
        }];
    }
}

/*
 * Get Profile Image By ID
 */

-(void)getProfileImagewithID : (NSString *) userID withImage:(void(^)(UIImage *))finishBlock{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",userID]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            finishBlock([UIImage imageWithData:imageData]);
        });
    });
}
/*
 * Get Profile Image URL By ID
 */

- (void)profilePictureUrlbyID : (NSString *) userID withLink:(void(^)(NSString *))finishBlock{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"false", @"redirect",
                                   @"large", @"type",
                                   nil];
    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/picture",userID]
                                 parameters:params
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              if (!error) {
                                  finishBlock([[result valueForKey:@"data"] valueForKey:@"url"]);
                              }
                              else {
                                  finishBlock(@"");
                              }
                          }];
}


/*
 * Share feed
 */

-(void)shareFeedwithParam:(NSDictionary *)param{
    
    if (self.session.isOpen) {
        FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
        params.link = [NSURL URLWithString:[param valueForKey:@"link"]];
        params.name = [param valueForKey:@"name"];
        params.caption = [param valueForKey:@"name"];
        params.picture = [NSURL URLWithString:[param valueForKey:@"picture"]];
        params.description = [param valueForKey:@"description"];
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentShareDialogWithParams:params]) {
            // Present the share dialog
            // Present share dialog
            [FBDialogs presentShareDialogWithLink:params.link
                                             name:params.name
                                          caption:params.caption
                                      description:params.description
                                          picture:params.picture
                                      clientState:nil
                                          handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                              if(error) {
                                                  // An error occurred, we need to handle the error
                                                  // See: https://developers.facebook.com/docs/ios/errors
                                                  [self showingMessage:@"Some error happened":NO];
                                                  NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                              } else {
                                                  // Success
                                                  NSLog(@"result %@", results);
                                                  [self showingMessage:@"Photo Uploaded Complete":YES];
                                              }
                                          }];
        } else {
            // Present the feed dialog
            
            // Show the feed dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:self.session
                                                   parameters:param
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // An error occurred, we need to handle the error
                                                              // See: https://developers.facebook.com/docs/ios/errors
                                                              NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                              [self showingMessage:@"Some error happened":NO];
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // Handle the publish feed callback
                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                                                                  if (![urlParams valueForKey:@"post_id"]) {
                                                                      // User cancelled.
                                                                      NSLog(@"User cancelled.");
                                                                      
                                                                  } else {
                                                                      // User clicked the Share button
                                                                      NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                      NSLog(@"result %@", result);
                                                                      [self showingMessage:@"Photo Uploaded Complete":YES];
                                                                  }
                                                              }
                                                          }
                                                      }];
        }
    } else {
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
            // Call delegate for Our Work
            if (!error) {
                FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
                params.link = [NSURL URLWithString:[param valueForKey:@"link"]];
                params.name = [param valueForKey:@"name"];
                params.caption = [param valueForKey:@"name"];
                params.picture = [NSURL URLWithString:[param valueForKey:@"picture"]];
                params.description = [param valueForKey:@"description"];
                
                // If the Facebook app is installed and we can present the share dialog
                if ([FBDialogs canPresentShareDialogWithParams:params]) {
                    // Present the share dialog
                    // Present share dialog
                    [FBDialogs presentShareDialogWithLink:params.link
                                                     name:params.name
                                                  caption:params.caption
                                              description:params.description
                                                  picture:params.picture
                                              clientState:nil
                                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                      if(error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          [self showingMessage:@"Some error happened":NO];
                                                          NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                      } else {
                                                          // Success
                                                          NSLog(@"result %@", results);
                                                          [self showingMessage:@"Photo Uploaded Complete":YES];
                                                      }
                                                  }];
                } else {
                    // Present the feed dialog
                    
                    // Show the feed dialog
                    [FBWebDialogs presentFeedDialogModallyWithSession:self.session
                                                           parameters:param
                                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                                  if (error) {
                                                                      // An error occurred, we need to handle the error
                                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                                      NSLog(@"%@",[NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                                      [self showingMessage:@"Some error happened":NO];
                                                                  } else {
                                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                                          // User cancelled.
                                                                          NSLog(@"User cancelled.");
                                                                      } else {
                                                                          // Handle the publish feed callback
                                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                          
                                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                                              // User cancelled.
                                                                              NSLog(@"User cancelled.");
                                                                              
                                                                          } else {
                                                                              // User clicked the Share button
                                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                              NSLog(@"result %@", result);
                                                                              [self showingMessage:@"Photo Uploaded Complete":YES];
                                                                          }
                                                                      }
                                                                  }
                                                              }];
                }
            }
            else{
                [self showingMessage:@"Some error happened":NO];
            }
        }];
    }
}

/*
 * Share Image
 */

-(void)shareImage:(UIImage *)image{
    if (!self.session.isOpen) {
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
            // Call delegate for Our Work
            if (!error) {
                NSString *fbid=[NSString stringWithFormat:@"%@", FBSession.activeSession.accessTokenData.accessToken];
                
                NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                [params setObject:UIImagePNGRepresentation(image) forKey:@"picture"];
                [params setObject:[NSString stringWithFormat:@"%@",fbid] forKey:@"access_token"];
                
                [FBRequestConnection startWithGraphPath:@"me/photos"
                                             parameters:params
                                             HTTPMethod:@"POST"
                                      completionHandler:^(FBRequestConnection *connection,
                                                          id result,
                                                          NSError *error)
                 {
                     if (error)
                     {
                         //showing an alert for failure
                         [self showingMessage:@"Some error happened":NO];
                     }
                     else
                     {
                         //showing an alert for success
                         [self showingMessage:@"Photo Uploaded Complete":YES];
                     }
                 }];
            }
            else{
                [self showingMessage:@"Some error happened":NO];
            }
        }];
    }
    else{
        NSString *fbid=[NSString stringWithFormat:@"%@", FBSession.activeSession.accessTokenData.accessToken];
        
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setObject:UIImagePNGRepresentation(image) forKey:@"picture"];
        [params setObject:[NSString stringWithFormat:@"%@",fbid] forKey:@"access_token"];
        
        [FBRequestConnection startWithGraphPath:@"me/photos"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error)
         {
             if (error)
             {
                 //showing an alert for failure
                 [self showingMessage:@"Some error happened":NO];
             }
             else
             {
                 //showing an alert for success
                 [self showingMessage:@"Photo Uploaded Complete":YES];
             }
         }];
    }
}

/*
 * Share Video
 */

-(void)shareVideo:(NSString *)videoPath{
    if (!self.session.isOpen) {
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
            // Call delegate for Our Work
            if (!error) {
                NSData *data = [NSData dataWithContentsOfFile:videoPath];
                NSString* videoName = [videoPath lastPathComponent];
                NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
                [params setObject:data forKey:videoName];
                FBSession.activeSession = self.session;
                [FBRequestConnection startWithGraphPath:@"me/videos"
                                             parameters:params
                                             HTTPMethod:@"POST"
                                      completionHandler:^(FBRequestConnection *connection,
                                                          id result,
                                                          NSError *error)
                 {
                     if (error)
                     {
                         //showing an alert for failure
                         [self showingMessage:@"Some error happened try again":NO];
                     }
                     else
                     {
                         //showing an alert for success
                         [self showingMessage:@"Video Uploaded Complete":YES];
                     }
                 }];
            }
            else{
                if (self.delegate) {
                    [self showingMessage:@"Some error happened":NO];
                }
            }
        }];
    }
    else{
        NSData *data = [NSData dataWithContentsOfFile:videoPath];
        NSString* videoName = [videoPath lastPathComponent];
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setObject:data forKey:videoName];
        FBSession.activeSession = self.session;
        [FBRequestConnection startWithGraphPath:@"me/videos"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error)
         {
             if (error)
             {
                 //showing an alert for failure
                 [self showingMessage:@"Some error happened try again":NO];
             }
             else
             {
                 //showing an alert for success
                 [self showingMessage:@"Video Uploaded Complete":YES];
             }
         }];
    }
}

/*
 * app users
 */

-(void)isUsingApp{
    if (!self.session.isOpen) {
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
            // Call delegate for Our Work
            if (!error) {
                FBSession.activeSession = self.session;
                NSString *query = [NSString stringWithFormat:@"Select name, uid, pic_small, username from user where is_app_user = 1 and uid in (select uid2 from friend where uid1 = me()) order by concat(first_name,last_name) asc" ];
                NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                            query, @"q", nil];
                
                [FBRequestConnection startWithGraphPath:@"/fql" parameters:queryParam
                                             HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection,
                                                                                   id result, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"Error: %@", [error localizedDescription]);
                                                     if (self.delegate) {
                                                         [self.delegate FacebookFriendList:nil withSuccess:NO];
                                                     }
                                                 } else {
                                                     NSMutableArray *friends = [result objectForKey:@"data"];
                                                     for (int i=0; i<friends.count; i++) {
                                                         NSString *username = [[friends objectAtIndex:i] valueForKey:@"username"];
                                                         NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[friends objectAtIndex:i]];
                                                         [dict setValue:[NSString stringWithFormat:@"%@@facebook.com",username] forKey:@"useremail"];
                                                         [friends replaceObjectAtIndex:i withObject:dict];
                                                     }
                                                     NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                                                                     ascending:YES selector:@selector(localizedStandardCompare:)] ;
                                                     NSArray *sortedArray = [friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                                                     [friends removeAllObjects];
                                                     friends = Nil;
                                                     friends = [[NSMutableArray alloc] initWithArray:sortedArray];
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
                                                     if (self.delegate) {
                                                         [self.delegate FacebookFriendList:(NSArray *)friends withSuccess:YES];
                                                     }
                                                 }
                                             }];
            }
            else{
                if (self.delegate) {
                    [self.delegate FacebookFriendList:nil withSuccess:NO];
                }
            }
        }];
    }
    else{
        FBSession.activeSession = self.session;
        NSString *query = [NSString stringWithFormat:@"Select name, uid, pic_small, username from user where is_app_user = 1 and uid in (select uid2 from friend where uid1 = me()) order by concat(first_name,last_name) asc" ];
        NSDictionary *queryParam = [NSDictionary dictionaryWithObjectsAndKeys:
                                    query, @"q", nil];
        
        [FBRequestConnection startWithGraphPath:@"/fql" parameters:queryParam
                                     HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection,
                                                                           id result, NSError *error) {
                                         if (error) {
                                             NSLog(@"Error: %@", [error localizedDescription]);
                                             if (self.delegate) {
                                                 [self.delegate FacebookFriendList:nil withSuccess:NO];
                                             }
                                         } else {
                                             NSMutableArray *friends = [result objectForKey:@"data"];
                                             for (int i=0; i<friends.count; i++) {
                                                 NSString *username = [[friends objectAtIndex:i] valueForKey:@"username"];
                                                 NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[friends objectAtIndex:i]];
                                                 [dict setValue:[NSString stringWithFormat:@"%@@facebook.com",username] forKey:@"useremail"];
                                                 [friends replaceObjectAtIndex:i withObject:dict];
                                             }
                                             NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                                                             ascending:YES selector:@selector(localizedStandardCompare:)] ;
                                             NSArray *sortedArray = [friends sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                                             [friends removeAllObjects];
                                             friends = Nil;
                                             friends = [[NSMutableArray alloc] initWithArray:sortedArray];
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
                                             if (self.delegate) {
                                                 [self.delegate FacebookFriendList:(NSArray *)friends withSuccess:YES];
                                             }
                                         }
                                     }];
    }

}


/*
 * Send a user to user request
 */

- (void)sendRequestToSelectedFriendsWithID:(NSArray *)suggestedFriends withMessage : (NSString *)message withTitle : (NSString *)title{
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // 3. Suggest friends the user may want to request, could be game context specific?
                                     [suggestedFriends componentsJoinedByString:@","], @"to",    nil];
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:self.session
     message:message
     title:title
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
             if (!self.delegate) {
                 [self.delegate FacebookAppRequestComplete:NO];
             }
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
                 if (!self.delegate) {
                     [self.delegate FacebookAppRequestComplete:NO];
                 }
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                     if (!self.delegate) {
                         [self.delegate FacebookAppRequestComplete:NO];
                     }
                 }
                 else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                     if (!self.delegate) {
                         [self.delegate FacebookAppRequestComplete:YES];
                     }
                 }
             }
         }
     }];
}

/*
 * Send a user to user request, with a targeted list
 */
- (void)sendRequest:(NSArray *) targeted  withMessage : (NSString *)message withTitle : (NSString *)title{
    NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
    
    // Filter and only show targeted friends
    if (targeted != nil && [targeted count] > 0) {
        NSString *selectIDsStr = [targeted componentsJoinedByString:@","];
        params[@"suggestions"] = selectIDsStr;
    }
    
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:self.session
     message:message
     title:title
     parameters:params
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending request.
             NSLog(@"Error sending request.");
             if (!self.delegate) {
                 [self.delegate FacebookAppRequestComplete:NO];
             }
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
                 if (!self.delegate) {
                     [self.delegate FacebookAppRequestComplete:NO];
                 }
            } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                     if (!self.delegate) {
                         [self.delegate FacebookAppRequestComplete:NO];
                     }
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                     if (!self.delegate) {
                         [self.delegate FacebookAppRequestComplete:YES];
                     }
                }
             }
         }
     }];
}

/*
 * Get iOS device users and send targeted requests.
 */
- (void) requestFriendsUsingDevice:(NSString *)device  withMessage : (NSString *)message withTitle : (NSString *)title{
    NSMutableArray *deviceFilteredFriends = [[NSMutableArray alloc] init];
    FBSession.activeSession = self.session;
    [FBRequestConnection startWithGraphPath:@"me/friends"
                                 parameters: @{ @"fields" : @"id,devices"}
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error) {
                                  // Get the result
                                  NSArray *resultData = result[@"data"];
                                  // Check we have data
                                  if ([resultData count] > 0) {
                                      // Loop through the friends returned
                                      for (NSDictionary *friendObject in resultData) {
                                          // Check if devices info available
                                          if (friendObject[@"devices"]) {
                                              NSArray *deviceData = friendObject[@"devices"];
                                              // Loop through list of devices
                                              for (NSDictionary *deviceObject in deviceData) {
                                                  // Check if there is a device match
                                                  if ([device isEqualToString:deviceObject[@"os"]]) {
                                                      // If there is a match, add it to the list
                                                      [deviceFilteredFriends addObject:
                                                       friendObject[@"id"]];
                                                      break;
                                                  }
                                              }
                                          }
                                      }
                                  }
                              }
                              // Send request
                              [self sendRequest:deviceFilteredFriends withMessage : message withTitle : title];
                          }];
}

/*
 * Send request to iOS device users.
 */
- (void)sendRequestToiOSFriendswithMessage : (NSString *)message withTitle : (NSString *)title {
    // Filter and only show friends using iOS
    [self requestFriendsUsingDevice:@"iOS" withMessage : message withTitle : title];
}
/*
 * Send request to Android device users.
 */

-(void)sendRequestToAndroidFriendswithMessage : (NSString *)message withTitle : (NSString *)title{
    [self requestFriendsUsingDevice:@"Android" withMessage : message withTitle : title];
}
/*
 * Send request to all users.
 */

-(void)sendRequestToAllFriendswithMessage:(NSString *)message withTitle:(NSString *)title{
    [self sendRequest:nil withMessage : message withTitle : title];
}

#pragma mark - Helper methods

/**
 * Helper method for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

/*
 * Helper method to handle incoming request app link
 */
- (void) handleAppLinkData:(FBAppLinkData *)appLinkData {
    NSString *targetURLString = appLinkData.originalQueryParameters[@"target_url"];
    if (targetURLString) {
        NSURL *targetURL = [NSURL URLWithString:targetURLString];
        NSDictionary *targetParams = [self parseURLParams:[targetURL query]];
        NSString *ref = [targetParams valueForKey:@"ref"];
        // Check for the ref parameter to check if this is one of
        // our incoming news feed link, otherwise it can be an
        // an attribution link
        if ([ref isEqualToString:@"notif"]) {
            // Get the request id
            NSString *requestIDParam = targetParams[@"request_ids"];
            NSArray *requestIDs = [requestIDParam
                                   componentsSeparatedByString:@","];
            
            // Get the request data from a Graph API call to the
            // request id endpoint
            [self notificationGet:requestIDs[0]];
        }
    }
}

/*
 * Helper method to check incoming token data
 */
- (BOOL)handleAppLinkToken:(FBAccessTokenData *)appLinkToken {
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    return [appLinkSession openFromAccessTokenData:appLinkToken
                                 completionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
                                     // Log any errors
                                     if (error) {
                                         NSLog(@"Error using cached token to open a session: %@",
                                               error.localizedDescription);
                                     }
                                 }];
}
/*
 * Helper function to get the request data
 */
- (void) notificationGet:(NSString *)requestid {
    FBSession.activeSession = self.session;
    [FBRequestConnection startWithGraphPath:requestid
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error) {
                                  NSString *title;
                                  NSString *message;
                                  if (result[@"data"]) {
                                      title = [NSString
                                               stringWithFormat:@"%@ sent you a gift",
                                               result[@"from"][@"name"]];
                                      NSString *jsonString = result[@"data"];
                                      NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                      if (!jsonData) {
                                          NSLog(@"JSON decode error: %@", error);
                                          return;
                                      }
                                      NSError *jsonError = nil;
                                      NSDictionary *requestData =
                                      [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:0
                                                                        error:&jsonError];
                                      if (jsonError) {
                                          NSLog(@"JSON decode error: %@", error);
                                          return;
                                      }
                                      message =
                                      [NSString stringWithFormat:@"Badge: %@, Karma: %@",
                                       requestData[@"badge_of_awesomeness"],
                                       requestData[@"social_karma"]];
                                  } else {
                                      title = [NSString
                                               stringWithFormat:@"%@ sent you a request",
                                               result[@"from"][@"name"]];
                                      message = result[@"message"];
                                  }
                                  UIAlertView *alert = [[UIAlertView alloc]
                                                        initWithTitle:title
                                                        message:message
                                                        delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil,
                                                        nil];
                                  [alert show];
                                  
                                  // Delete the request notification
                                  [self notificationClear:result[@"id"]];
                              }
                          }];
}

/*
 * Helper function to delete the request notification
 */
- (void) notificationClear:(NSString *)requestid {
    // Delete the request notification
    [FBRequestConnection startWithGraphPath:requestid
                                 parameters:nil
                                 HTTPMethod:@"DELETE"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error) {
                                  NSLog(@"Request deleted");
                              }
                          }];
}

-(void)showingMessage : (NSString *)message :(bool)isSuccess{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
    if (self.delegate) {
        [self.delegate FacebookShareCompletewithResult:isSuccess];
    }
}



@end
