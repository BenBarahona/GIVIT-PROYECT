//
//  GIM_KeepMeLoginViewController.m
//  GiveItMobile
//
//  Created by Administrator on 20/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_KeepMeLoginViewController.h"

@interface GIM_KeepMeLoginViewController ()

@end

@implementation GIM_KeepMeLoginViewController
@synthesize emailTxt;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitBtn:(id)sender {
    
    
    NSString *validationmsg = [self validateEmail];
    
    if ([validationmsg isEqualToString:@"1"] ){
        GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
        
        userModel.email = self.emailTxt.text;
        
        
        GIM_UserController *userController = [[GIM_UserController alloc]init];
        
        userController.delegate = self;
        
        [userController forgetPassword:userModel];
        
        [self.view setUserInteractionEnabled:NO];
        
        [self.indc startAnimating];
        

        
        
    }
    else {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}



    
    



- (IBAction)closeBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------



-(void)didError:(NSString *)msg{
    [_indc stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


-(void)didForgetPassword:(NSString *)msg isSuccess:(BOOL)isSuccess {
    if(isSuccess){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        [self.view setUserInteractionEnabled:YES];
        [self.indc stopAnimating];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        
        [self.view setUserInteractionEnabled:YES];
        [self.indc stopAnimating];
        
    }
}





- (BOOL) validatemailid: (NSString *) candidate {
    NSString *numericRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}


-(NSString *) validateEmail{
    
    
        
    if([emailTxt.text isEqualToString:@""] || self.emailTxt.text == nil )
    {
        return @"Email must not be empty";
        
    }
    
    if([self validatemailid:emailTxt.text] !=1)
        
    {
        
        return @"email is not in correct format";
    }
    
    
    
    return @"1";
}





@end
