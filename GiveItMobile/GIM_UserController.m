//
//  GIM_UserController.m
//  GiveItMobile
//
//  Created by Debashis Banerjee on 11/12/13.
//  Copyright (c) 2013 Debashis Banerjee. All rights reserved.
//

#import "GIM_UserController.h"

@implementation GIM_UserController {
    NSMutableData *_responseData;
    int connectionFlag;
}

-(id)init{
    self = [super init];
    if (self) {
        // Initialization code
        // NSURL *aUrl = [NSURL URLWithString:@"http://idsdev.net/demos/giftitmobile/get_api/registration"];
        //    NSURL *aUrl = [NSURL URLWithString:@"http://appproto.com/demos/giftitmobile/get_api/registration"];
        baseUrl = @"http://appproto.com/demos/giftitmobile/get_api/get_api/";
    }
    return (id)self;

}

-(void)registerUser:(GIM_UserModel *)user {
    
    connectionFlag = 1;
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@registration",baseUrl]];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    NSString *postString = [NSString stringWithFormat:@"inputs[name]=%@&inputs[email]=%@&inputs[password]=%@&inputs[address]=%@&inputs[ph_no1]=%@&inputs[website]=%@&inputs[device_token]=%@&inputs[device_type]=%@&inputs[dateofbirth]=%@&inputs[dateofanniversary]=%@&inputs[id]=%@",user.name,user.email,user.password,user.address,user.phone,user.website,user.deviceToken,user.deviceType,user.dob,user.doa,@"0"];
   
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
    
}

-(void) login:(GIM_UserModel *)user {
    connectionFlag = 2;
    NSLog(@"Base url %@",baseUrl);
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@login",baseUrl]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    NSString *postString = [NSString stringWithFormat:@"email=%@&password=%@&device_token=%@&device_type=I",user.email,user.password,user.deviceToken];
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
}

-(void) myAcc:(GIM_UserModel *)user {
    connectionFlag = 25;
    NSLog(@"Base url %@",baseUrl);
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@login",baseUrl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    NSString *postString = [NSString stringWithFormat:@"email=%@&password=%@&device_token=%@&device_type=I",user.email,user.password,user.deviceToken];
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
}



-(void) forgetPassword:(GIM_UserModel *)user {
    connectionFlag = 3;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@forgot_password",baseUrl]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    NSString *postString = [NSString stringWithFormat:@"email=%@",user.email];
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
}


-(void) myGiftCard:(GIM_UserModel *)user {
    
    connectionFlag = 4;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@coupon_details_user",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    

    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"]];
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    

    
    [connection start];
    
   }

-(void) buyGiftCard:(GIM_UserModel *)user {
    
    connectionFlag = 5;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@get_retailer_details",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString;
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    
    
    [connection start];
    
}

-(void) addGiftCard:(GIM_UserModel *)user {
    connectionFlag = 6;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@check_coupon_user",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    
    [request setHTTPMethod:@"POST"];
    
    
     NSString *postString = [NSString stringWithFormat:@"user_id=%@&retailer_id=%@&coupan_code=%@",user.userid,user.retailerId,user.couponCode];
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
}


-(void) otherCoupon:(GIM_UserModel *)user {
    connectionFlag = 7;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@others_coupon",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    
    NSString *postString = [NSString stringWithFormat:@"inputs[retailer_name]=%@&inputs[amount]=%@&inputs[purchase_date]=%@&inputs[exp_date]=%@&inputs[user_id]=%@&inputs[card_code]=%@",user.retailelName,user.retaileramount,user.purchaseDate,user.expDate,user.userid,user.couponCode];
    

    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
}


-(void) payment:(GIM_UserModel *)user {
     connectionFlag = 8;
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@gift_coupon_user",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];

    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:user.userid forKey:@"inputs[user_id]"];
    [dict setObject:user.pCardNo forKey:@"inputs[card_no]"];
    [dict setObject:user.pCardType forKey:@"inputs[card_type]"];
    [dict setObject:user.pCvv forKey:@"inputs[cvv]"];
    [dict setObject:user.pexDate forKey:@"inputs[ex_date]"];
    [dict setObject:user.pRetailerId forKey:@"inputs[retailer_id]"];
    [dict setObject:user.pAmount forKey:@"inputs[paid_amount]"];
    [dict setObject:user.pemail forKey:@"inputs[email]"];
    [dict setObject:user.pschedule_date forKey:@"inputs[schedule_date]"];
    [dict setObject:user.pSchedule forKey:@"inputs[schedule]"];
    [dict setObject:user.pMessage forKey:@"inputs[message]"];
    [dict setObject:user.pNameOnCard forKey:@"inputs[nameon_card]"];
    if (![user.pSchedule isEqualToString:@"N"]) {
        [dict setObject:@"" forKey:@"inputs[schedule_timezone]"];
    }

    NSData *imageData=user.pImageVideo;
    
    [request setHTTPMethod:@"POST"];
    
    //post data
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//
    for (NSString *param in dict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([user.imageOrVideo isEqualToString:@"image"]) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"uploadImage.jpeg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"\r\n\n\n"]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if ([user.imageOrVideo isEqualToString:@"video"]){
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"video\"; filename=\"uploadVideo.mov\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"\r\n\n\n"]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/mov\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    

    [request setHTTPBody:body];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
}

-(void)update:(GIM_UserModel *)user {
    
    connectionFlag = 9;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@registration",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"inputs[id]=%@&inputs[email]=%@&inputs[password]=%@&inputs[dateofbirth]=%@&inputs[dateofanniversary]=%@&cards[user_id]=%@&cards[card_no]=%@&cards[cvv]=%@&cards[ex_date]=%@&cards[card_type]=%@&cards[nameon_card]=%@",user.userid,user.email,user.password,user.dob,user.doa,user.newuserid,user.pCardNo,user.pCvv,user.pexDate,user.pCardType,user.pNameOnCard];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
        [connection start];
}





-(void)giftOfDay:(GIM_UserModel *)user {
    
    connectionFlag = 10;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@gift_card_of_the_day",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    
    
    NSString *postString = [NSString stringWithFormat:@"date=%@",user.date];

    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection start];
    
}

-(void)events_save:(GIM_UserModel *)user {
    
    connectionFlag = 11;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@events_save",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    
    
    NSString *postString = [NSString stringWithFormat:@"inputs[id]=%@&inputs[title]=%@&inputs[description]=%@&inputs[date]=%@&inputs[timezone]=%@&inputs[location]=%@&inputs[user_id]=%@",@"",user.title,user.description,user.date,user.duration,user.location,user.userid];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection start];
    
}

-(void)events_users :(GIM_UserModel *)user {
    
    connectionFlag = 12;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@events_users",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    
    
    
    NSString *postString = [NSString stringWithFormat:@"user_id=%@&&date=%@",user.newuserid,user.date];
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection start];
    
}

-(void)events_user :(GIM_UserModel *)user {
    
    connectionFlag = 13;
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@events_user",baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    
    
    
    NSString *postString = [NSString stringWithFormat:@"user_id=%@",user.newuserid];
    
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    [connection start];
    
}

-(void)social_Login:(GIM_UserModel *)user{
    connectionFlag = 14;
    NSString *urlstring =[NSString stringWithFormat:@"%@social_login",baseUrl];
    NSURL *aUrl = [NSURL URLWithString:urlstring];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", @"kkk", @"lll"];
    
    NSString *postString = [NSString stringWithFormat:@"inputs[name]=%@&inputs[email]=%@&inputs[device_type]=%@&inputs[device_token]=%@&inputs[id]=%@",user.name,user.email,user.deviceType,user.deviceToken,@"0"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [connection start];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
   
    NSError *error;
    NSString *respons = [NSString stringWithUTF8String:[_responseData bytes]];
//    NSLog(@"rsponsedata %@",[NSString stringWithUTF8String:[_responseData bytes]]);
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"%@",json);
    if (!error) {
        
    if(connectionFlag == 1){
       
        
        NSString *msg = [json valueForKey:@"msg"];
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
        if ([errorCode isEqualToString:@"0"]) {
            [self.delegate didRegister:msg isSuccess:YES];
        } else {
            [self.delegate didRegister:msg isSuccess:NO];
        }
       
    }
    
    if(connectionFlag == 2 || connectionFlag == 14){
        
        
        NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
        if ([errorCode isEqualToString:@"0"]) {
            if (![[[(NSDictionary *)json valueForKey:@"item"] valueForKey:@"email"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"Save"]]) {
                NSString *remember = [[NSUserDefaults standardUserDefaults] valueForKey:@"remember"];
                NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
                for (NSString *key in [defaultsDictionary allKeys]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSFileManager *fileMgr = [[NSFileManager alloc] init] ;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSError *error = nil;
                NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
                if (error == nil) {
                    for (NSString *path in directoryContents) {
                        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
                        BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                        if (!removeSuccess) {
                            // Error handling
                        }
                    }
                } else {
                    // Error handling
                }
                [[NSUserDefaults standardUserDefaults] setValue:remember forKey:@"remember"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            if ([[[json valueForKey:@"cards"] valueForKey:@"card_no"] length]>0) {
                NSMutableDictionary *cardData = [NSMutableDictionary dictionaryWithDictionary:[json valueForKey:@"cards"]];
                NSString *dobString = [[json valueForKey:@"item"] valueForKey:@"dateofbirth"];
                NSString *doaString = [[json valueForKey:@"item"] valueForKey:@"dateofanniversary"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dobFromString = [[NSDate alloc] init];
                NSDate *doaFromString = [[NSDate alloc] init];
                dobFromString = [dateFormatter dateFromString:dobString];
                doaFromString = [dateFormatter dateFromString:doaString];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                doaString = [dateFormatter stringFromDate:doaFromString];
                dobString = [dateFormatter stringFromDate:dobFromString];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:dobString forKey:@"dob"];
                [dict setValue:doaString forKey:@"doa"];
                [dict setValue:[cardData valueForKey:@"card_no"] forKey:@"cardno"];
                [dict setValue:[cardData valueForKey:@"card_type"] forKey:@"cardname"];
                [dict setValue:[cardData valueForKey:@"cvv"] forKey:@"cvv"];
                [dict setValue:[cardData valueForKey:@"ex_date"] forKey:@"exDt"];
                [dict setValue:[cardData valueForKey:@"nameon_card"] forKey:@"nameOnCard"];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"accountDetail"];
            }
            [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"email"] forKey:@"Save"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [[NSUserDefaults standardUserDefaults] setObject:[[json valueForKey:@"item"] valueForKey:@"id"]forKey:@"UserID"];
            [[NSUserDefaults standardUserDefaults] setObject:[[json valueForKey:@"item"] valueForKey:@"email"]forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.delegate didLoggedIn:(NSDictionary *)json isSuccess:YES];
        } else {
            [self.delegate didLoggedIn:(NSDictionary *)json isSuccess:NO];
        }
    }
        
        if(connectionFlag == 3){
            
            NSString *msg = [json valueForKey:@"msg"];
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didForgetPassword:msg isSuccess:YES];
            } else {
                [self.delegate didForgetPassword:msg isSuccess:NO];
            }
            
            
        }
        
        if(connectionFlag == 4){
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didMyGiftCard:(NSDictionary *)json isSuccess:YES];
            } else {
                [self.delegate didMyGiftCard:(NSDictionary *)json isSuccess:NO];
            }
            
            
        }
        
        if(connectionFlag == 5){
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didBuyGiftCard:(NSArray *)json isSuccess:YES];
            } else {
                
            }
            
            
        }

        
        if(connectionFlag == 6){
            
            
            NSString *msg = [json valueForKey:@"msg"];
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didAddGiftCard:msg isSuccess:YES];
            } else {
                [self.delegate didAddGiftCard:msg isSuccess:NO];
            }
            
        }
        
        
        if(connectionFlag == 7){
            
            
            NSString *msg = [json valueForKey:@"msg"];
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didOtherCoupon:msg isSuccess:YES];
            } else {
                [self.delegate didOtherCoupon:msg isSuccess:NO];
            }
            
        }
        
        
        if(connectionFlag == 8){
            
            NSString *msg = [json valueForKey:@"msg"];
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didPayement:msg isSuccess:YES];
            } else {
                [self.delegate didPayement:msg isSuccess:NO];
            }
            
        }
        
        
        
        if(connectionFlag == 9){
            
            
            NSString *msg = [json valueForKey:@"msg"];
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didAccount:msg isSuccess:YES];
            } else {
                [self.delegate didAccount:msg isSuccess:NO];
            }
            
        }
        
        if(connectionFlag == 10){
            
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[json valueForKey:@"day_item"] forKey:@"day_item"];
            [dict setValue:[json valueForKey:@"reatler_item"] forKey:@"reatler_item"];
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didGiftOfDay:(NSDictionary *)dict isSuccess:YES];
            } else {
                
            }
            
        }
        
        if(connectionFlag == 11){
            
            
            NSString *msg = [json valueForKey:@"msg"];
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didEvents_save:msg isSuccess:YES];
                
            } else {
                [self.delegate didEvents_save:msg isSuccess:YES];
            }
            
        }
        
        if(connectionFlag == 12){
            
            
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didEvents_user:(NSArray *)[json valueForKey:@"item"] isSuccess:YES];
            } else {
                [self.delegate didEvents_user:(NSArray *)[json valueForKey:@"item"] isSuccess:NO];
            }
            
        }
        if(connectionFlag == 13){
            
            
            
            NSString *errorCode = [NSString stringWithFormat:@"%@",[json valueForKey:@"error"]];
            
            
            
            if ([errorCode isEqualToString:@"0"]) {
                [self.delegate didTotalEvent:(NSArray *)[json valueForKey:@"item"] isSuccess:YES];
            } else {
                [self.delegate didTotalEvent:(NSArray *)[json valueForKey:@"item"] isSuccess:NO];
            }
            
        }
        if (connectionFlag == 25) {
            if ([[[json valueForKey:@"cards"] valueForKey:@"card_no"] length]>0) {
                NSMutableDictionary *cardData = [NSMutableDictionary dictionaryWithDictionary:[json valueForKey:@"cards"]];
                NSString *dobString = [[json valueForKey:@"item"] valueForKey:@"dateofbirth"];
                NSString *doaString = [[json valueForKey:@"item"] valueForKey:@"dateofanniversary"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dobFromString = [[NSDate alloc] init];
                NSDate *doaFromString = [[NSDate alloc] init];
                dobFromString = [dateFormatter dateFromString:dobString];
                doaFromString = [dateFormatter dateFromString:doaString];
                [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                doaString = [dateFormatter stringFromDate:doaFromString];
                dobString = [dateFormatter stringFromDate:dobFromString];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:dobString forKey:@"dob"];
                [dict setValue:doaString forKey:@"doa"];
                [dict setValue:[cardData valueForKey:@"card_no"] forKey:@"cardno"];
                [dict setValue:[cardData valueForKey:@"card_type"] forKey:@"cardname"];
                [dict setValue:[cardData valueForKey:@"cvv"] forKey:@"cvv"];
                [dict setValue:[cardData valueForKey:@"ex_date"] forKey:@"exDt"];
                [dict setValue:[cardData valueForKey:@"nameon_card"] forKey:@"nameOnCard"];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"accountDetail"];
            }
            [self.delegate didAccountLoad:@"Yes"];
        }

        
     
    } else {
        NSString *msg = @"Some server problem encountered";
        
        
        [self.delegate didError:msg];
        //fail delegate will come
        
        return;
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSString *msg = @"Some server problem encountered";
    
    
    [self.delegate didError:msg];
    //fail delegate will come
    
}
@end
