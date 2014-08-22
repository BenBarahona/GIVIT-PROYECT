//
//  GIM_KeepMeLoginViewController.h
//  GiveItMobile
//
//  Created by Administrator on 20/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserController.h"
#import "GIM_UserModel.h"

@interface GIM_KeepMeLoginViewController : UIViewController <GIM_UserServiceDelegate,UITextFieldDelegate>
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;
- (IBAction)submitBtn:(id)sender;
- (IBAction)closeBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indc;

@end
