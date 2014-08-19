//
//  CustomButtonTabController.h
//  GiveItMobile
//
//  Created by Bhaskar on 17/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabNavBuyGift.h"
#import "CustomTabNavMyAccount.h"
#import "CustomTabNavMyEvent.h"
#import "CustomTabNavMyGift.h"
#import "CustomTabNavMyMessage.h"
#import "CustomTabNavGOtDay.h"
#import "ZBarSDK.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>


@protocol customTabControlDelegate <NSObject>

@optional
-(void)updateUploadeImageOrVideo:(UIImage *)image;
-(void)updateUploadeVideo:(NSString *)video;
-(void)barCode:(NSString *)barcode;

@end

@interface CustomButtonTabController : UIViewController{
    CustomTabNavGOtDay *giftOfTheDayNavigation;
    CustomTabNavBuyGift *buyGiftNavigation;
    CustomTabNavBuyGift *myGiftNavigation;
    CustomTabNavMyEvent *eventNavigation;
    CustomTabNavMyMessage *messageNavigation;
    CustomTabNavMyAccount *myAccountNavigation;
    int cameraPickerType;
}
@property CGRect navigationViewFrame;
@property int selectedIndex;
@property (nonatomic,strong) id <customTabControlDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *mHeaderTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *mSecondRightBarButton;
@property (weak, nonatomic) IBOutlet UIView *mNavigationView;
@property (weak, nonatomic) IBOutlet UIView *mTabBarButtonView;

- (IBAction)didTapGiftOftheDay:(id)sender;
- (IBAction)didTapBuyGiftCard:(id)sender;
- (IBAction)didTapMyGiftCard:(id)sender;
- (IBAction)didTapEvent:(id)sender;
- (IBAction)didTapMessages:(id)sender;
- (IBAction)didTapMyAccount:(id)sender;
- (IBAction)didTapBackButton:(id)sender;
- (IBAction)didTapHomeButton:(id)sender;
- (IBAction)didTapExtraRightButton:(id)sender;

- (void)setHeaderTitleLabelText:(id)navigationController;
- (void)setHiddenOnOffExtraButton:(BOOL)hidden;
- (void)didOpenCameraforBarcode : (BOOL)isBarcode;
- (void)setCustomNavigationViewFrame:(CGRect)frame;
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
- (void)video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo:(void*)contextInfo;

@end
