//
//  GIM_HomeViewController.h
//  GiveItMobile
//
//  Created by Administrator on 20/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GIM_GiftOfDayViewController.h"
#import "GIM_BuyGiftCardViewController.h"
#import "GIM_MyGiftCardListViewController.h"
#import "GIM_Events.h"
#import "GIM_MyMessage.h"
#import "GIM_MyAccountViewController.h"
#import "CustomButtonTabController.h"
#import "LinkedINAPIFunction.h"
@interface GIM_HomeViewController : UIViewController<GIM_UserServiceDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    int tabindex;
}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction)didTapMySetting:(id)sender;
- (IBAction)didTapLogout:(id)sender;
- (IBAction)didTapToConnectMyEvents:(id)sender;
- (IBAction)didTapToMyEvents:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *counteventLabel;
@property (weak, nonatomic) IBOutlet UILabel *countMessageLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@end
