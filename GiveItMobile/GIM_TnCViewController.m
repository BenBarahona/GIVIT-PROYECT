//
//  GIM_TnCViewController.m
//  GiveItMobile
//
//  Created by Administrator on 21/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_TnCViewController.h"

@interface GIM_TnCViewController ()

@end

@implementation GIM_TnCViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"Terms & Conditions";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
}

#pragma mark Custom Navigation Bar
#pragma mark -------------------------------------------

#pragma mark Custom Navigation Bar
#pragma mark -------------------------------------------
-(void)customNavigationButton{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_next_arrow_01.png"] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"btn_next_arrow_02.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"btn_home_01.png"] forState:UIControlStateNormal];
    //[button1 setImage:[UIImage imageNamed:@"btn_home_02.png"] forState:UIControlStateHighlighted];
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
