//
//  CustomButtonTabController.m
//  GiveItMobile
//
//  Created by Bhaskar on 17/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "CustomButtonTabController.h"
#import "GIM_Eventlist.h"
#import "GIM_UpcomingEvents.h"
#import "GIM_Thanks.h"
#import "GIM_MyAccountViewController.h"
@interface CustomButtonTabController ()

@end

@implementation CustomButtonTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_mSecondRightBarButton setHidden:YES];
    [_mHeaderTitleLabel setFont:[UIFont fontWithName:@"Droid Sans" size:18]];
    _navigationViewFrame = _mNavigationView.frame;
    buyGiftNavigation =  [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabNavBuyGift"];
    myGiftNavigation =  [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabNavMyGift"];
    eventNavigation =  [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabNavMyEvent"];
    messageNavigation =  [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabNavMyMessage"];
    myAccountNavigation =  [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabNavMyAccount"];
    giftOfTheDayNavigation =  [self.storyboard instantiateViewControllerWithIdentifier:@"CustomTabNavGOtDay"];
    [_mNavigationView addSubview:buyGiftNavigation.view];
    [_mNavigationView addSubview:myGiftNavigation.view];
    [_mNavigationView addSubview:eventNavigation.view];
    [_mNavigationView addSubview:messageNavigation.view];
    [_mNavigationView addSubview:myAccountNavigation.view];
    [_mNavigationView addSubview:giftOfTheDayNavigation.view];
    switch (_selectedIndex) {
        case 10:
           [_mNavigationView bringSubviewToFront:giftOfTheDayNavigation.view];
            break;
        case 11:
            [_mNavigationView bringSubviewToFront:buyGiftNavigation.view];
            break;
        case 12:
            [_mNavigationView bringSubviewToFront:myGiftNavigation.view];
            break;
        case 13:
            [_mNavigationView bringSubviewToFront:eventNavigation.view];
            break;
        case 14:
            [_mNavigationView bringSubviewToFront:messageNavigation.view];
            break;
        case 15:
            [_mNavigationView bringSubviewToFront:myAccountNavigation.view];
            break;
            
        default:
            break;
    }
    [self changeButtonImage];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mSecondRightBarButton.hidden = YES;
}

- (IBAction)didTapGiftOftheDay:(id)sender {
    _selectedIndex = [sender tag];
    [self changeButtonImage];
    _mHeaderTitleLabel.text = giftOfTheDayNavigation.title;
    [_mNavigationView bringSubviewToFront:giftOfTheDayNavigation.view];
}

- (IBAction)didTapBuyGiftCard:(id)sender {
    _selectedIndex = [sender tag];
    [self changeButtonImage];
    _mHeaderTitleLabel.text = buyGiftNavigation.title;
    [_mNavigationView bringSubviewToFront:buyGiftNavigation.view];
}

- (IBAction)didTapMyGiftCard:(id)sender {
    _selectedIndex = [sender tag];
    [self changeButtonImage];
    _mHeaderTitleLabel.text = myGiftNavigation.title;
   [_mNavigationView bringSubviewToFront:myGiftNavigation.view];
}

- (IBAction)didTapEvent:(id)sender {
    _selectedIndex = [sender tag];
    [self changeButtonImage];
    _mHeaderTitleLabel.text = eventNavigation.title;
    [_mNavigationView bringSubviewToFront:eventNavigation.view];
}

- (IBAction)didTapMessages:(id)sender {
    _selectedIndex = [sender tag];
    [self changeButtonImage];
    _mHeaderTitleLabel.text = messageNavigation.title;
    [_mNavigationView bringSubviewToFront:messageNavigation.view];
}

- (IBAction)didTapMyAccount:(id)sender {
    _selectedIndex = [sender tag];
    [self changeButtonImage];
    _mHeaderTitleLabel.text = myAccountNavigation.title;
    [_mNavigationView bringSubviewToFront:myAccountNavigation.view];
}

- (IBAction)didTapBackButton:(id)sender {
    switch (_selectedIndex) {
        case 10:{
            if ([[giftOfTheDayNavigation viewControllers] count]>1 && ![(GIM_Thanks *)[[giftOfTheDayNavigation viewControllers] objectAtIndex:[[giftOfTheDayNavigation viewControllers] count]-1] isKindOfClass:[GIM_Thanks class]] ) {
                [giftOfTheDayNavigation popViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 11:{
            if ([[buyGiftNavigation viewControllers] count]>1 && ![(GIM_Thanks *)[[buyGiftNavigation viewControllers] objectAtIndex:[[buyGiftNavigation viewControllers] count]-1] isKindOfClass:[GIM_Thanks class]]) {
                [buyGiftNavigation popViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 12:{
            if ([[myGiftNavigation viewControllers] count]>1) {
                [myGiftNavigation popViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 13:{
            if ([[eventNavigation viewControllers] count]>1) {
                [eventNavigation popViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 14:{
            if ([[messageNavigation viewControllers] count]>1) {
                [messageNavigation popViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 15:{
            if ([[myAccountNavigation viewControllers] count]>1) {
                [myAccountNavigation popViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (IBAction)didTapHomeButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapExtraRightButton:(id)sender {
    if (_selectedIndex == 13 && [(GIM_Eventlist *)[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] isKindOfClass:[GIM_Eventlist class]]) {
        [(GIM_Eventlist *)[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] gotoAddNewContact];
    }
    else if (_selectedIndex == 13 && [(GIM_UpcomingEvents *)[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] isKindOfClass:[GIM_UpcomingEvents class]]) {
        [[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] performSegueWithIdentifier:@"segueCalander" sender:[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1]];
    }
    else if (_selectedIndex == 15 && [(GIM_MyAccountViewController *)[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] isKindOfClass:[GIM_MyAccountViewController class]]) {
        [[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] performSegueWithIdentifier:@"seguePerform" sender:[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1]];
    }
    else if (_selectedIndex == 15 && [(GIM_GiveGiftCard_SelectContactViewController *)[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] isKindOfClass:[GIM_GiveGiftCard_SelectContactViewController class]]) {
        [[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] performSegueWithIdentifier:@"SocialLogin" sender:[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1]];
    }
}

-(void)changeButtonImage{
    for (id view in _mTabBarButtonView.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            [(UIButton *)view setSelected:NO];
        }
    }
    [(UIButton *)[_mTabBarButtonView viewWithTag:_selectedIndex] setSelected:YES];
    if (_selectedIndex == 13 && [(GIM_Eventlist *)[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] isKindOfClass:[GIM_Eventlist class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_event_01.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_event_02.png"] forState:UIControlStateHighlighted];
    }
    else if (_selectedIndex == 13 && [(GIM_UpcomingEvents *)[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] isKindOfClass:[GIM_UpcomingEvents class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_date_01.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_date_02.png"] forState:UIControlStateHighlighted];
    }
    else if (_selectedIndex == 15 && [(GIM_MyAccountViewController *)[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] isKindOfClass:[GIM_MyAccountViewController class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_addcontact_01-1.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_addcontact_02-1.png"] forState:UIControlStateHighlighted];
    }
    else if (_selectedIndex == 15 && [(GIM_GiveGiftCard_SelectContactViewController *)[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] isKindOfClass:[GIM_GiveGiftCard_SelectContactViewController class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_icon_01.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_icon_02.png"] forState:UIControlStateHighlighted];
    }
    else{
        [_mSecondRightBarButton setHidden:YES];
    }

}


#pragma mark Class Method
#pragma mark -------------------------------------------

- (void)setHeaderTitleLabelText:(id )navigationController{
    if (_selectedIndex == 10 && [navigationController isKindOfClass:[CustomTabNavGOtDay class]]) {
        _mHeaderTitleLabel.text = giftOfTheDayNavigation.title;
    }
    else if (_selectedIndex == 11 && [navigationController isKindOfClass:[CustomTabNavBuyGift class]]) {
        _mHeaderTitleLabel.text = buyGiftNavigation.title;
    }
    else if (_selectedIndex == 12 && [navigationController isKindOfClass:[CustomTabNavMyGift class]]) {
        _mHeaderTitleLabel.text = myGiftNavigation.title;
    }
    else if (_selectedIndex == 13 && [navigationController isKindOfClass:[CustomTabNavMyEvent class]]) {
        _mHeaderTitleLabel.text = eventNavigation.title;
    }
    else if (_selectedIndex == 14 && [navigationController isKindOfClass:[CustomTabNavMyMessage class]]) {
        _mHeaderTitleLabel.text = messageNavigation.title;
    }
    else if (_selectedIndex == 15 && [navigationController isKindOfClass:[CustomTabNavMyAccount class]]) {
        _mHeaderTitleLabel.text = myAccountNavigation.title;
    }
}

-(void)setHiddenOnOffExtraButton:(BOOL)hidden{
    if (_selectedIndex == 13 && [(GIM_Eventlist *)[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] isKindOfClass:[GIM_Eventlist class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_event_01.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_event_02.png"] forState:UIControlStateHighlighted];
    }
    else if (_selectedIndex == 13 && [(GIM_UpcomingEvents *)[[eventNavigation viewControllers] objectAtIndex:[[eventNavigation viewControllers] count]-1] isKindOfClass:[GIM_UpcomingEvents class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_date_01.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_date_02.png"] forState:UIControlStateHighlighted];
    }
    else if (_selectedIndex == 15 && [(GIM_MyAccountViewController *)[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] isKindOfClass:[GIM_MyAccountViewController class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_addcontact_01-1.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_addcontact_02-1.png"] forState:UIControlStateHighlighted];
    }
    else if (_selectedIndex == 15 && [(GIM_GiveGiftCard_SelectContactViewController *)[[myAccountNavigation viewControllers] objectAtIndex:[[myAccountNavigation viewControllers] count]-1] isKindOfClass:[GIM_GiveGiftCard_SelectContactViewController class]]) {
        [_mSecondRightBarButton setHidden:NO];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_icon_01.png"] forState:UIControlStateNormal];
        [_mSecondRightBarButton setImage:[UIImage imageNamed:@"btn_icon_02.png"] forState:UIControlStateHighlighted];
    }
    else{
        [_mSecondRightBarButton setHidden:YES];
    }
}

-(void)setCustomNavigationViewFrame:(CGRect)frame{
    [_mNavigationView setFrame:frame];
}
-(void)didOpenCameraforBarcode:(BOOL)isBarcode{
    if (isBarcode == YES) {
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = (id)self;
        [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
        reader.readerView.zoom = 1.0;
        cameraPickerType = 0;
        [self presentViewController:reader animated:YES completion:Nil];
    }
    else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:(id)self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"My Album",@"Video", @"Camera", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = buttonIndex;
    switch(i)
    {
        case 0:
        {
            cameraPickerType =1;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = (id)self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        case 1:
        {
            cameraPickerType =2;
            [self startCameraControllerFromViewController: self
                                            usingDelegate: (id)self];
        }
            break;
        case 2:
        {
            cameraPickerType =1;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = (id)self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
        default:
            // Do Nothing.........
            break;
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    switch (cameraPickerType) {
        case 0:
        {
            id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
            ZBarSymbol *symbol = nil;
            for(symbol in results){
                NSString *upcString = symbol.data;
                if (_delegate) {
                    [_delegate barCode:upcString];
                }
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }
            break;
        case 1:
        {
            UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
            NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((chosenImage), 0.5)];
            
            float imageSize = imageData.length/(1024);
            imageData = Nil;
            if (imageSize<=1024.0f) {
                if (_delegate) {
                    [_delegate updateUploadeImageOrVideo:chosenImage];
                }
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Givit Mobile" message:@"File Size limit exceeds !\nImage Size upto 1 MB allowd"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                [alert show];
            }
            chosenImage = Nil;
            [picker dismissViewControllerAnimated:YES completion:NULL];
        }
            break;
        case 2:
        {
            NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
            [self dismissViewControllerAnimated:YES completion:nil];
            // Handle a movie capture
            if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0)
                == kCFCompareEqualTo) {
                
                NSString *moviePath = (NSString *)[[info objectForKey:
                                        UIImagePickerControllerMediaURL] path];
                if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                    UISaveVideoAtPathToSavedPhotosAlbum (moviePath,self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
                moviePath = Nil;
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:Nil];
    
    return YES;
}


// For responding to the user accepting a newly-captured picture or movie

- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
    }else{
        NSData *data = [[NSData alloc] initWithContentsOfFile:videoPath];
        float videoSize = data.length/(1024);
        if (videoSize<=1024*5) {
            if (_delegate) {
                [_delegate updateUploadeVideo:videoPath];
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Givit Mobile" message:@"File Size limit exceeds !\nVideo Size upto 5 MB allowd"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
