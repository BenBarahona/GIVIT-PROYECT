//
//  GIM_BuyGiftCardViewController.h
//  GiveItMobile
//
//  Created by Nikita on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import "BuyGiftCardCell.h"
#import "GIM_GiveGiftCard_SelectContactViewController.h"
@interface GIM_BuyGiftCardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GIM_UserServiceDelegate,UITextFieldDelegate>
{
    NSMutableArray *itemGiftCardDetails;
    NSMutableDictionary *payMentDict;
    int amount,flagAmount;
}
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIView *mGiftAmountView;
@property (weak, nonatomic) IBOutlet UITextField *didTapSelectOthers;
@property (weak, nonatomic) IBOutlet UIImageView *m10ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *m20ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *m30ImageView;
@property (strong, nonatomic) IBOutlet UITableView *buyGiftTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *mFamountButton;
@property (weak, nonatomic) IBOutlet UIButton *mSamountButton;
@property (weak, nonatomic) IBOutlet UIButton *mTamountButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
-(void)loadRetailer;

- (IBAction)didTapSelect10:(id)sender;
- (IBAction)didTapSelect20:(id)sender;
- (IBAction)didTapSelect30:(id)sender;
- (IBAction)didTapContinue:(id)sender;
- (IBAction)didTapBackButton:(id)sender;

@end
