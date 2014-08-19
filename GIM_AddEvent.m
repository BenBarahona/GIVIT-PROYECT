//
//  GIM_AddEvent.m
//  GiveItMobile
//
//  Created by Bhaskar on 08/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_AddEvent.h"

@interface GIM_AddEvent ()

@end

@implementation GIM_AddEvent
@synthesize mDescriptionTextField,mLocationTextField,mDurationTextField,mTitleTextField;

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
    [self customNavigationButton];
    NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapAddEvent:(id)sender {
    
    NSString *validationmsg = [self validateEvent];
    
    if ([validationmsg isEqualToString:@"1"] ){
        [mDurationTextField resignFirstResponder];
        [mTitleTextField resignFirstResponder];
        [mDescriptionTextField resignFirstResponder];
        [mLocationTextField resignFirstResponder];
        GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
        userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
        userModel.title = self.mTitleTextField.text;
        userModel.description = self.mDescriptionTextField.text;
        userModel.date = _currentDate;
        userModel.duration = self.mDurationTextField.text;
        userModel.location = self.mLocationTextField.text;
        GIM_UserController *userController = [[GIM_UserController alloc]init];
        userController.delegate = self;
        [userController events_save:userModel];
        [_mActivityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
    }
    
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
    }
}
- (IBAction)didTapClose:(id)sender {
    
}


#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------


-(void)didEvents_save:(NSString *)msg isSuccess:(BOOL)isSuccess {
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    if(isSuccess){
        mTitleTextField.text =nil;
        mDescriptionTextField.text =nil;
        mDescriptionTextField.text =nil;
        mLocationTextField.text =nil;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
   } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)didError:(NSString *)msg{
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark Validation
#pragma mark -------------------------------------------


-(NSString *) validateEvent{
    
    if([mTitleTextField.text isEqualToString:@""] || mTitleTextField.text == nil || [[mTitleTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Title must not be empty";
        
    }
    
    if([mDescriptionTextField.text isEqualToString:@""] || mDescriptionTextField.text == nil || [[mDescriptionTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Description must not be empty";
        
    }
    
    if([mDurationTextField.text isEqualToString:@""] || mDurationTextField.text == nil || [[mDurationTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)    {
        return @"Duration must not be empty";
        
    }
    if([mLocationTextField.text isEqualToString:@""] || mLocationTextField.text == nil || [[mLocationTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Location must not be empty";
        
    }
    return @"1";
}





#pragma mark Textfield Delegate
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)barButtonAddText:(id)sender{
}


#pragma mark Custom Navigation Bar
#pragma mark -------------------------------------------
-(void)customNavigationButton{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_next_arrow_01.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_next_arrow_02.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"btn_home_01.png"] forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"btn_home_02.png"] forState:UIControlStateHighlighted];
    button1.adjustsImageWhenDisabled = NO;
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, 30, 30);
    button1.frame = CGRectMake(0, 0, 30, 30);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(gotoHome) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = customBarItem1;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)gotoHome{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}


@end
