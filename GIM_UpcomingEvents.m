//
//  GIM_UpcomingEvents.m
//  GiveItMobile
//
//  Created by Bhaskar on 03/02/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_UpcomingEvents.h"

@interface GIM_UpcomingEvents ()

@end

@implementation GIM_UpcomingEvents

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
    totalEvent = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"Upcoming Events";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:NO];
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    userController.delegate = (id)self;
    [userController events_user:userModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView DataSource Delegate
#pragma mark -------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return totalEvent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"event";
    
    GIM_EventCell *cell = (GIM_EventCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[GIM_EventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
//    CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
//    
//    CGSize expectedLabelSize = [[[totalEvent objectAtIndex:indexPath.row]valueForKey:@"title"] sizeWithFont:cell.eventNameLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.eventNameLabel.lineBreakMode];
//    if (expectedLabelSize.width>180.0f) {
//        CGRect newFrame = cell.eventNameLabel.frame;
//        newFrame.size.height = 40.0f;
//        cell.eventNameLabel.frame = newFrame;
//        cell.eventNameLabel.numberOfLines = 2;
//        NSLog(@"Height>>>>>>%f",newFrame.size.height);
//    }
    //adjust the label the the new height.
    cell.eventNameLabel.text = [[totalEvent objectAtIndex:indexPath.row]valueForKey:@"title"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:[[totalEvent objectAtIndex:indexPath.row]valueForKey:@"date"]];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSString *selectDate = [dateFormatter stringFromDate:dateFromString];
    cell.eventTimeLabel.text = selectDate;
    cell.eventDescriptionTextView.text = [[totalEvent objectAtIndex:indexPath.row]valueForKey:@"description"];
    cell.eventDescriptionTextView.tag = indexPath.row;
    return cell;
}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------

-(void)didError:(NSString *)msg{
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



-(void)didTotalEvent:(NSArray *)msg isSuccess:(BOOL)isSuccess{
    [totalEvent removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    if(isSuccess){
        for (int i = 0; i < msg.count; i++) {
            dateFromString = [dateFormatter dateFromString:[[msg objectAtIndex:i] objectForKey:@"date"]];
            if ([dateFromString timeIntervalSinceDate:[NSDate date]] > 0){
                [totalEvent addObject:[msg objectAtIndex:i]];
            }
        }

    }
    NSMutableArray *fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBEvents"]];
    for (int i = 0; i < fbEvent.count; i++) {
        dateFromString = [dateFormatter dateFromString:[[fbEvent objectAtIndex:i] objectForKey:@"date"]];
        if ([dateFromString timeIntervalSinceDate:[NSDate date]] > 0){
            [totalEvent addObject:[fbEvent objectAtIndex:i]];
        }
    }
    fbEvent = nil;
    fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"GmailEvents"]];
    for (int i = 0; i < fbEvent.count; i++) {
        dateFromString = [dateFormatter dateFromString:[[fbEvent objectAtIndex:i] objectForKey:@"date"]];
        if ([dateFromString timeIntervalSinceDate:[NSDate date]] > 0){
            [totalEvent addObject:[fbEvent objectAtIndex:i]];
        }
    }
    [_mUpcomingTableView reloadData];
}

@end
