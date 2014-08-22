//
//  GIM_GiftOfDayViewController.m
//  GiveItMobile
//
//  Created by Administrator on 02/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_GiftOfDayViewController.h"
@interface GIM_GiftOfDayViewController ()

@end

@implementation GIM_GiftOfDayViewController

@synthesize valueLabel,GiftOfDayImage,givitLabel,savingLabel;

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
    [self.mDescriptionLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
    [self.mTargetGiftCard setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
    [self loadGiftCard];
   
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadGiftCard{
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *selectDate = [dateFormat stringFromDate:[NSDate date]];
    userModel.date = selectDate;
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    
    userController.delegate = self;
    
    [userController giftOfDay:userModel];
    
    [self.indc startAnimating];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title =@"Gift Card of The Day";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
}

- (IBAction)buyButton:(id)sender
{
    [self performSegueWithIdentifier:@"GiftToBuySegue" sender:self];
}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------

-(void)didError:(NSString *)msg{
    [_indc stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



-(void)didGiftOfDay:(NSDictionary *)msg isSuccess:(BOOL)isSuccess
{
    [self.view setUserInteractionEnabled:YES];
   if(isSuccess)
    {
        //[self.view setUserInteractionEnabled:YES];
        //[self.indc stopAnimating];
        float original_amount =[[[ msg valueForKey:@"day_item"] valueForKey:@"original_amount"] floatValue];
        float givit_amount = [[[ msg valueForKey:@"day_item"] valueForKey:@"discounted_amount"] floatValue];
        float discount = ((original_amount - givit_amount)/original_amount) *100 ;
        valueLabel.text = [NSString stringWithFormat:@"$%0.2f",original_amount];
        givitLabel.text = [NSString stringWithFormat:@"$%0.2f",givit_amount];
        savingLabel.text = [NSString stringWithFormat:@"%0.2f%%",discount];
        paymentDict = [NSMutableDictionary dictionaryWithDictionary:[msg valueForKey:@"reatler_item"]];
        self.mDescriptionTextView.text = [[[ msg valueForKey:@"day_item"] valueForKey:@"description"] stringByConvertingHTMLToPlainText];
        [[NSUserDefaults standardUserDefaults] setValue: [NSString stringWithFormat:@"%0.2f",givit_amount] forKey:@"Amount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSURL *url = [NSURL URLWithString:[[ msg valueForKey:@"day_item"] valueForKey:@"image"]];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
            GiftOfDayImage.image = [UIImage imageWithData:imageData];
                [self.indc stopAnimating];
                
            });
        });

    }
    else
    {
       [self.indc stopAnimating];
    }
}

#pragma mark Custom Navigation Bar
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    flagTextField = textField;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)barButtonAddText:(id)sender{
    [flagTextField resignFirstResponder];
}

#pragma mark Perform Segue
#pragma mark -------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%f",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Amount"] floatValue]);
    if([[segue identifier] isEqualToString:@"GiftToBuySegue"]){
        GIM_GiveGiftCard_SelectContactViewController *give = [segue destinationViewController];
        give.paymentDict = paymentDict;
        give.isHideContinue = NO;
    }
}

@end
