//
//  GIM_UserRegistrationViewController.h
//  GiveItMobile
//
//  Created by Administrator on 19/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
@interface GIM_UserRegistrationViewController : UIViewController <GIM_UserServiceDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstName;

@property (strong, nonatomic) IBOutlet UITextField *lastName;

@property (strong, nonatomic) IBOutlet UITextField *email;

@property (strong, nonatomic) IBOutlet UITextField *password;

@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

- (IBAction)signUpAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indc;

-(NSString *) validateRegistration;





@end
