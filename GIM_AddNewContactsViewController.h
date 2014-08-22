//
//  GIM_AddNewContactsViewController.h
//  GiveItMobile
//
//  Created by Bhaskar on 06/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"

@protocol newContactAddProtocol <NSObject>

@optional
-(void)addNewContact;

@end

@interface GIM_AddNewContactsViewController : UIViewController
@property (nonatomic,strong) id <newContactAddProtocol> delegate;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UITextField *mFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mLastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *mPhoneNoTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;

- (IBAction)didTapToClose:(id)sender;
- (IBAction)didTapToSaveContacts:(id)sender;
@end
