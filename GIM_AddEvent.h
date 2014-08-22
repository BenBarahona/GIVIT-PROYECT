//
//  GIM_AddEvent.h
//  GiveItMobile
//
//  Created by Bhaskar on 08/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserController.h"
#import "GIM_UserModel.h"


@interface GIM_AddEvent : UIViewController<GIM_UserServiceDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) NSString *currentDate;
@property (weak, nonatomic) IBOutlet UITextField *mTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *mDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *mDurationTextField;
@property (weak, nonatomic) IBOutlet UITextField *mLocationTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
- (IBAction)didTapAddEvent:(id)sender;
- (IBAction)didTapClose:(id)sender;

@end
