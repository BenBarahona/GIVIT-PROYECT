//
//  GIM_UserRegistrationViewController.m
//  GiveItMobile
//
//  Created by Administrator on 19/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_UserRegistrationViewController.h"
#import "GIM_AppDelegate.h"
@interface GIM_UserRegistrationViewController ()

@end

@implementation GIM_UserRegistrationViewController
@synthesize firstName,lastName,email,password,confirmPassword;

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
    [_mScrollView setContentSize:CGSizeMake(320, 504)];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
}

-(void)pushToSingle:(NSNotification *)notis{
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpAction:(id)sender {
    NSString *validationmsg = [self validateRegistration];
    
    if ([validationmsg isEqualToString:@"1"] ){
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    
    userModel.name = [NSString stringWithFormat:@"%@ %@",self.firstName.text,self.lastName.text];
    
    userModel.email = self.email.text;
    
    userModel.password = self.password.text;
    
    userModel.address = @"";
    
    userModel.phone = @"";
    
    userModel.website = @"";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    userModel.deviceToken = appD.deviceTokenString;
    userModel.deviceType = @"I";
    
    userModel.doa = @"";
    
    userModel.dob = @"";
    
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    
    userController.delegate = self;
    
    [userController registerUser:userModel];
    
    [self.view setUserInteractionEnabled:NO];
    
    [self.indc startAnimating];
    
}
    
    else {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------


-(void)didError:(NSString *)msg{
    [_indc stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



-(void)didRegister:(NSString *)msg isSuccess:(BOOL)isSuccess {
    if(isSuccess){
        [self.view setUserInteractionEnabled:YES];
        [self.indc stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Registered Successfully" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        [self.view setUserInteractionEnabled:YES];
        [self.indc stopAnimating];
    }
}

#pragma mark TextField Delegate
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-20) animated:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    [self performSegueWithIdentifier:@"didRegister" sender:self];
}







- (BOOL) validatemailid: (NSString *) candidate {
    NSString *numericRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}





-(NSString *) validateRegistration{
    
    if([firstName.text isEqualToString:@""] || firstName.text == nil || [[firstName.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"First Name must not be empty";
        
    }
    
    if([lastName.text isEqualToString:@""] || lastName.text == nil || [[lastName.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Last Name must not be empty";
        
    }
    
    if([email.text isEqualToString:@""] || self.email.text == nil )
    {
        return @"Email must not be empty";
        
    }
    
    if([self validatemailid:email.text] !=1)
        
    {
        
        return @"email is not in correct format";
    }

    if([password.text isEqualToString:@""] || self.email.text == nil )
    {
        return @"Password must not be empty";
        
    }
       
    if([confirmPassword.text isEqualToString:@""] || self.confirmPassword.text == nil )
    {
        return @"Confirm Password must not be empty";
        
    }
    
    if(!
       [confirmPassword.text isEqualToString: password.text]  )
    {
        return @"Confirm Password is not matching with Password";
        
    }

    
    return @"1";
}


#pragma mark Custom Navigation Bar
#pragma mark -------------------------------------------
-(void)customNavigationButton{
    //self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_next_arrow_01.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_next_arrow_02.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, 30, 30);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.hidesBackButton = YES;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
