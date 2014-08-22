//
//  GIM_GiveGiftCard_SelectContactViewController.h
//  GiveItMobile
//
//  Created by Bhaskar on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_SendContact.h"
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import "GIM_SocialSynViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>
#import "GIM_BuyGiftCardUploadViewController.h"
#import "GIM_AddNewContactsViewController.h"
#import "BuyGiftCardCell.h"
#import "GIM_GiveGiftCard_SelectContactViewController.h"
#import <MessageUI/MessageUI.h>

@interface GIM_GiveGiftCard_SelectContactViewController : UIViewController<UIAlertViewDelegate,socialLoginDelegate,newContactAddProtocol,UITableViewDataSource,UITableViewDelegate, MFMailComposeViewControllerDelegate >{
    NSMutableArray *contactDetail,*selectArray,*totalContact;
    NSMutableArray *demoArray;
    BOOL isChange;
    NSString *contactType;
}
@property BOOL isHideContinue;
@property (nonatomic,strong) UILocalizedIndexedCollation  *collation;
@property (strong, nonatomic) NSMutableDictionary *paymentDict;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (strong, nonatomic) IBOutlet UITableView *sendGiftTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *mFaceBookButton;
@property (weak, nonatomic) IBOutlet UIButton *mContactsButton;
@property (weak, nonatomic) IBOutlet UIButton *mGmailButton;
@property (weak, nonatomic) IBOutlet UIButton *mYahooButton;
@property (weak, nonatomic) IBOutlet UIButton *mContinueButton;
@property (weak, nonatomic) IBOutlet UIButton *mLinkedInButton;



- (IBAction)didTapToContinue:(id)sender;
- (IBAction)didTapToSocialSync:(id)sender;
- (IBAction)didTapToAddNewContact:(id)sender;

@end
