//
//  GIM_NavControllerViewController.m
//  GiveItMobile
//
//  Created by Bhaskar on 03/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_NavControllerViewController.h"

@interface GIM_NavControllerViewController ()

@end

@implementation GIM_NavControllerViewController

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
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"myGift"] isEqualToString:@"AddGiftCard"]) {
        GIM_AddNewGiftCardViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GIM_AddNewGiftCardViewController"];
        [self setViewControllers:@[controller]];
    }
    else{
        GIM_MyGiftCardListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GIM_MyGiftCardListViewController"];
        [self setViewControllers:@[controller]];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
