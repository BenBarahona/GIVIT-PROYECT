//
//  GIM_Thanks.m
//  GiveItMobile
//
//  Created by Bhaskar on 09/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_Thanks.h"
#import "GIM_AppDelegate.h"
@interface GIM_Thanks ()

@end

@implementation GIM_Thanks

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
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appD.isGetPushPayment == YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Givit Mobile" message:@"You have a New Message Want to see?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
        [alert show];

    }
	// Do any additional setup after loading the view.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (buttonIndex == 1) {
        appD.isGetPushPayment =NO;
        NSLog(@"viewcontrollers %@",[(UINavigationController *)appD.window.rootViewController viewControllers]);
        [(UINavigationController *)appD.window.rootViewController popToViewController:[[(UINavigationController *)appD.window.rootViewController viewControllers] objectAtIndex:1] animated:YES];
    }
    else{
        appD.isGetPush = NO;
        appD.isGetPushPayment =NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
