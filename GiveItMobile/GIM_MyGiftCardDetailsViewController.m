//
//  GIM_MyGiftCardDetailsViewController.m
//  GiveItMobile
//
//  Created by Administrator on 21/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_MyGiftCardDetailsViewController.h"

@interface GIM_MyGiftCardDetailsViewController ()

@end

@implementation GIM_MyGiftCardDetailsViewController
@synthesize detailDict,lbl_Balance,lblAsOf,lblReceivedFrom;
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
    [self setValue:[UIFont fontWithName:@"DroidSans-Bold" size:15] forKeyPath:@"boldLabel.font"];
    [lblReceivedFrom setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
    [self customNavigationButton];
    lbl_Balance.text = [NSString stringWithFormat:@"$%0.2f",[[detailDict valueForKey:@"orginal_amount"] floatValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:[detailDict valueForKey:@"purchase_date"]];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSString *selectDate = [dateFormatter stringFromDate:dateFromString];
     lblAsOf.text = [NSString stringWithFormat:@"As Of %@",selectDate];
    if ([detailDict valueForKey:@"gift_user_name"] != [NSNull null])
    lblReceivedFrom.text = [detailDict valueForKey:@"gift_user_name"];
    if (lblReceivedFrom.text.length<=0) {
        lblReceivedFrom.text = @"Me";
        _mBarcodeNumberLabel.text = [detailDict valueForKey: @"card_code"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.mymobilerewards.net/sysfiles/barcode.php?codetype=code128&size=160&text=%@",[detailDict valueForKey: @"card_code"]]];
        [_mActivityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                _mBarCodeImageView.image = [UIImage imageWithData:imageData];
                [_mActivityIndicator stopAnimating];
            });
        });
    }
    else{
        _mBarcodeNumberLabel.text = [detailDict valueForKey: @"coupan_code"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.mymobilerewards.net/sysfiles/barcode.php?codetype=code128&size=160&text=%@",[detailDict valueForKey: @"coupan_code"]]];
        [_mActivityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                _mBarCodeImageView.image = [UIImage imageWithData:imageData];
                [_mActivityIndicator stopAnimating];
            });
        });
    }
    
	// Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"My Gift Cards";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_HowToRedeem:(id)sender {
    [self performSegueWithIdentifier:@"reedemMyGift" sender:self];

}

- (IBAction)btn_TermsNCondition:(id)sender {
    
    [self performSegueWithIdentifier:@"t&cMyGift" sender:self];
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
