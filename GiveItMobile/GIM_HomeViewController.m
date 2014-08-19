//
//  GIM_HomeViewController.m
//  GiveItMobile
//
//  Created by Administrator on 20/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_HomeViewController.h"
@interface GIM_HomeViewController ()

@end

@implementation GIM_HomeViewController {
    
}

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
    [_mScrollView setContentSize:CGSizeMake(320, 504)];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"GivitLater"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appD.isGetPush == YES) {
        appD.isGetPush = NO;
        tabindex = 14;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
        [[NSUserDefaults standardUserDefaults] setValue:@"myGiftCard" forKey:@"myGift"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];
    }
//    else{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationItem.hidesBackButton = YES;
    NSArray *arr = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"myMessage"]];
    int count=0;
    for (int i = 0; i<arr.count; i++) {
        if ([[[arr objectAtIndex:i] valueForKey:@"status"] isEqualToString:@"unread"]) {
            count++;
        }
    }
    _countMessageLabel.text = [NSString stringWithFormat:@"%d",count];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    
    userController.delegate = self;
    
    [userController events_user:userModel];
//    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBAction Methods
#pragma mark -------------------------------------------


- (IBAction)btn_GiftCardOfTheDay:(id)sender {
    tabindex = 10;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:@"myGiftCard" forKey:@"myGift"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];
}
- (IBAction)btn_BuyGiftCards:(id)sender {
    tabindex = 11;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:@"myGiftCard" forKey:@"myGift"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];
}
- (IBAction)btn_MyGiftCards:(id)sender {
    tabindex = 12;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:@"myGiftCard" forKey:@"myGift"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];
}

- (IBAction)btn_AddNewGift:(id)sender {
    tabindex = 12;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:@"AddGiftCard" forKey:@"myGift"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];

}

- (IBAction)didTapToConnectMyEvents:(id)sender {
    tabindex = 13;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:@"myGiftCard" forKey:@"myGift"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];
}

- (IBAction)didTapToMyEvents:(id)sender {
    tabindex = 14;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:@"myGiftCard" forKey:@"myGift"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];
}

- (IBAction)didTapMySetting:(id)sender {
    tabindex = 15;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",tabindex] forKey:@"TabIndex"];
    [[NSUserDefaults standardUserDefaults] setValue:@"myGiftCard" forKey:@"myGift"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"SegueToTabBar" sender:self];
}

- (IBAction)didTapLogout:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"remember"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [FBSession.activeSession closeAndClearTokenInformation];
    [[LinkedINAPIFunction sharedManager] didLinkedINLogout];
    [[YahooHandler SharedInstance]LogoutFromYahoo:self didFinishSelector:@selector(LogoutDidFinish:) didFailSelector:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)LogoutDidFinish:(NSDictionary *)data{
    ;
}

#pragma mark Perform Segue
#pragma mark -------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"SegueToTabBar"]){
        CustomButtonTabController *tab = [segue destinationViewController];
        tab.selectedIndex = tabindex;
    }
}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------


-(void)didError:(NSString *)msg{
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

-(void)didTotalEvent:(NSArray *)msg isSuccess:(BOOL)isSuccess{
    NSMutableArray *fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBEvents"]];
    NSMutableArray *gmailEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"GmailEvents"]];
    if(isSuccess){
        
        _counteventLabel.text = [NSString stringWithFormat:@"%d",[msg count]+[fbEvent count]+[gmailEvent count]];
    } else {
        _counteventLabel.text = [NSString stringWithFormat:@"%d",[fbEvent count]+[gmailEvent count]];
    }
}
#pragma mark TextField Delegate
#pragma mark -------------------------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



@end