//
//  GIM_UserController.h
//  GiveItMobile
//
//  Created by Debashis Banerjee on 11/12/13.
//  Copyright (c) 2013 Debashis Banerjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GIM_UserModel.h"

@protocol GIM_UserServiceDelegate <NSObject>

@optional

-(void) didRegister: (NSString *)msg isSuccess:(BOOL)isSuccess;

-(void) didLoggedIn: (NSDictionary *)dict isSuccess:(BOOL)isSuccess;

-(void) didForgetPassword: (NSString *)msg isSuccess:(BOOL)isSuccess;

-(void) didMyGiftCard: (NSDictionary *)returnDict isSuccess:(BOOL)isSuccess;

-(void) didBuyGiftCard: (NSArray *)returnData isSuccess:(BOOL)isSuccess;

-(void) didAddGiftCard: (NSString *)msg isSuccess:(BOOL)isSuccess;

-(void) didOtherCoupon: (NSString *)msg isSuccess:(BOOL)isSuccess;

-(void) didPayement: (NSString *)msg isSuccess:(BOOL)isSuccess;

-(void) didAccount: (NSString *)msg isSuccess:(BOOL)isSuccess;

-(void) didGiftOfDay: (NSDictionary *)returnData isSuccess:(BOOL)isSuccess;

-(void) didEvents_save: (NSString *)msg isSuccess:(BOOL)isSuccess;

-(void) didEvents_user: (NSArray *)msg isSuccess:(BOOL)isSuccess;

-(void) didTotalEvent: (NSArray *)msg isSuccess:(BOOL)isSuccess;

-(void) didError : (NSString *)msg;

-(void) didAccountLoad : (NSString *)msg;

@end

@interface GIM_UserController : NSObject <NSURLConnectionDelegate> {
    NSString *baseUrl;
}

@property (nonatomic, strong) GIM_UserModel *user;
@property (nonatomic,strong) id <GIM_UserServiceDelegate> delegate;
-(void) registerUser: (GIM_UserModel *)user;
-(void) login: (GIM_UserModel *)user;
-(void) forgetPassword:(GIM_UserModel *)user;
-(void) myGiftCard:(GIM_UserModel *)user;
-(void) buyGiftCard:(GIM_UserModel *)user;
-(void) addGiftCard: (GIM_UserModel *)user;
-(void) otherCoupon: (GIM_UserModel *)user;
-(void) payment: (GIM_UserModel *)user;
-(void) update: (GIM_UserModel *)user;
-(void) giftOfDay: (GIM_UserModel *)user;
-(void) events_save: (GIM_UserModel *)user;
-(void) events_users: (GIM_UserModel *)user;
-(void) events_user: (GIM_UserModel *)user;
-(void) social_Login: (GIM_UserModel *)user;
-(void) myAcc:(GIM_UserModel *)user;
-(void) updateGftCardCount:(NSString *)cardID;



@end
