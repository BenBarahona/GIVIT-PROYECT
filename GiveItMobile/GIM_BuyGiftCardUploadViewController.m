//
//  GIM_BuyGiftCardUploadViewController.m
//  GiveItMobile
//
//  Created by Administrator on 26/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_BuyGiftCardUploadViewController.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import<AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>

@interface GIM_BuyGiftCardUploadViewController ()

@end

@implementation GIM_BuyGiftCardUploadViewController

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
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
	// Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.view.frame];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction Methods
#pragma mark -------------------------------------------

- (IBAction)continueButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"GivitLater"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"didBuyGiftPayment" sender:self];
}

- (IBAction)didTapToUpload:(id)sender {
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    tabHome.delegate = (id)self;
    [tabHome didOpenCameraforBarcode:NO];
    
}

- (IBAction)didTapCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapGivitLater:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"GivitLater"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"segueGiveMeLater" sender:self];
    
}

#pragma mark Perform Segue
#pragma mark -------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_paymentDict setValue:_messageTextField.text forKey:@"message"];
    if([[segue identifier] isEqualToString:@"didBuyGiftPayment"]){
        GIM_PayementViewController *give = [segue destinationViewController];
        give.paymentDict = _paymentDict;
    }
    else if([[segue identifier] isEqualToString:@"segueGiveMeLater"]){
        GIM_Eventlist *give = [segue destinationViewController];
        give.paymentDict = _paymentDict;
    }
}


#pragma mark UITEXTFIELD DELEGATE
#pragma mark -------------------------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITEXTFIELD DELEGATE
#pragma mark -------------------------------------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
//    if (![theTextView hasText]) {
//        _lbl.hidden = NO;
//    }
}

- (void) textViewDidChange:(UITextView *)textView
{
//    if(![textView hasText]) {
//        _lbl.hidden = NO;
//    }
//    else{
//        _lbl.hidden = YES;
//    }
}


#pragma mark CustomTabController DELEGATE
#pragma mark -------------------------------------------

-(void)updateUploadeImageOrVideo:(UIImage *)image{
    _mImageView.image = image;
    [_paymentDict setObject:UIImageJPEGRepresentation((image), 0.5) forKey:@"UploadImage"];
    [_paymentDict setValue:@"image" forKey:@"imageVideo"];
}

-(void)updateUploadeVideo:(NSString *)video{
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:video] options:nil];
    AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    [_mImageView setImage:image];
//    _mImageView.image =thumbnail;
    NSData *data = [[NSData alloc] initWithContentsOfFile:video];
    [_paymentDict setObject:data forKey:@"UploadImage"];
    [_paymentDict setValue:@"video" forKey:@"imageVideo"];
}

@end
