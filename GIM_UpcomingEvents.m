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
    showingEvent = [[NSMutableArray alloc] init];
    checkArray = [[NSMutableArray alloc] init];
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
    [cell.mCheckButton setTag:indexPath.row];
    if ([[checkArray objectAtIndex:indexPath.row]isEqualToString:@"Yes"]) {
        [cell.mCheckButton setImage:[UIImage imageNamed:@"chk_box_02.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.mCheckButton setImage:[UIImage imageNamed:@"chk_box_01.png"] forState:UIControlStateNormal];
    }
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
    [showingEvent removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    if(isSuccess){
        for (int i = 0; i < msg.count; i++) {
            dateFromString = [dateFormatter dateFromString:[[msg objectAtIndex:i] objectForKey:@"date"]];
            if ([dateFromString timeIntervalSinceDate:[NSDate date]] > 0){
                [showingEvent addObject:[msg objectAtIndex:i]];
            }
        }

    }
    [totalEvent removeAllObjects];
    totalEvent = [NSMutableArray arrayWithArray:(NSArray *)showingEvent];
    [self.appEventButton setSelected:YES];
    [self.fEventButton setSelected:NO];
    [self.gEventButton setSelected:NO];
    isAppevent = YES;
    isFBevent = NO;
    isGmailEvent = NO;
    [self createCheckArray];
    [self hiddenDeleteView];
}

- (IBAction)didTapCheckButton:(id)sender {
    int tag = [(UIButton *)sender tag];
    if ([[checkArray objectAtIndex:tag]isEqualToString:@"Yes"]) {
        [checkArray replaceObjectAtIndex:tag withObject:@"No"];
    }
    else{
        [checkArray replaceObjectAtIndex:tag withObject:@"Yes"];
    }
    [self.mUpcomingTableView reloadData];
}

- (IBAction)didTapAppEvent:(id)sender {
    isAppevent = YES;
    isFBevent = NO;
    isGmailEvent = NO;
    [self.appEventButton setSelected:YES];
    [self.fEventButton setSelected:NO];
    [self.gEventButton setSelected:NO];
    totalEvent = [NSMutableArray arrayWithArray:(NSArray *)showingEvent];
    [self createCheckArray];
    [self hiddenDeleteView];
}

- (IBAction)didTapFbEvent:(id)sender {
    isAppevent = NO;
    isFBevent = YES;
    isGmailEvent = NO;
    [self.appEventButton setSelected:NO];
    [self.fEventButton setSelected:YES];
    [self.gEventButton setSelected:NO];
    [totalEvent removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    NSMutableArray *fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBEvents"]];
    for (int i = 0; i < fbEvent.count; i++) {
        dateFromString = [dateFormatter dateFromString:[[fbEvent objectAtIndex:i] objectForKey:@"date"]];
        if ([dateFromString timeIntervalSinceDate:[NSDate date]] >= 0){
            [totalEvent addObject:[fbEvent objectAtIndex:i]];
        }
    }
    [self createCheckArray];
    [self hiddenDeleteView];
}

- (IBAction)didTapGmailEvent:(id)sender {
    isAppevent = NO;
    isFBevent = NO;
    isGmailEvent = YES;
    [self.appEventButton setSelected:NO];
    [self.fEventButton setSelected:NO];
    [self.gEventButton setSelected:YES];
    [totalEvent removeAllObjects];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    NSMutableArray *    fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"GmailEvents"]];
    for (int i = 0; i < fbEvent.count; i++) {
        dateFromString = [dateFormatter dateFromString:[[fbEvent objectAtIndex:i] objectForKey:@"date"]];
        if ([dateFromString timeIntervalSinceDate:[NSDate date]] > 0){
            [totalEvent addObject:[fbEvent objectAtIndex:i]];
        }
    }
    [self createCheckArray];
    [self hiddenDeleteView];
}

- (IBAction)didTapSelectAll:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == NO) {
        btn.selected = YES;
        [self.mSelectallCheckBoxImageView setImage:[UIImage imageNamed:@"chk_box_02.png"]];
        [checkArray removeAllObjects];
        for (int i = 0; i<totalEvent.count; i++) {
            [checkArray addObject:@"Yes"];
        }
    }
    else{
        btn.selected = NO;
        [self.mSelectallCheckBoxImageView setImage:[UIImage imageNamed:@"chk_box_01.png"]];
        [checkArray removeAllObjects];
        for (int i = 0; i<totalEvent.count; i++) {
            [checkArray addObject:@"No"];
        }
    }
    [self.mUpcomingTableView reloadData];
}

- (IBAction)didTapDeleteButton:(id)sender {
    if (isAppevent == YES) {
        for (int i = 0; i<totalEvent.count;) {
            if ([[checkArray objectAtIndex:i]isEqualToString:@"Yes"]) {
                NSString *URLString = [NSString stringWithFormat:@"http://appproto.com/demos/giftitmobile/get_api/get_api/delete_event?=&eventid=%@",[[totalEvent objectAtIndex:i] valueForKey:@"id"]];
                NSURL *requestURL = [NSURL URLWithString:URLString];
                [showingEvent removeObjectAtIndex:i];
                [totalEvent removeObjectAtIndex:i];
                [checkArray removeObjectAtIndex:i];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *responseData;
                    responseData = [NSData dataWithContentsOfURL:requestURL];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        NSLog(@"\n\n<<<<<<<<<<<<<<<<<<<<Appdelegate : %@\n\n",[NSString stringWithUTF8String:[responseData bytes]]);
                    });
                });
            }
            else{
                i++;
            }
        }
        
    }
    else if (isFBevent == YES) {
        for (int i = 0; i<totalEvent.count;) {
            if ([[checkArray objectAtIndex:i]isEqualToString:@"Yes"]) {
                [totalEvent removeObjectAtIndex:i];
                [checkArray removeObjectAtIndex:i];
                [[NSUserDefaults standardUserDefaults] setObject:totalEvent forKey:@"FBEvents"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else{
                i++;
            }
        }
    }
    else if (isGmailEvent == YES) {
        for (int i = 0; i<totalEvent.count;) {
            if ([[checkArray objectAtIndex:i]isEqualToString:@"Yes"]) {
                [totalEvent removeObjectAtIndex:i];
                [checkArray removeObjectAtIndex:i];
                [[NSUserDefaults standardUserDefaults] setObject:totalEvent forKey:@"GmailEvents"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else{
                i++;
            }
        }
    }
    [self.mUpcomingTableView reloadData];
    [self hiddenDeleteView];
}

-(void)hiddenDeleteView{
    if (totalEvent.count == 0) {
        [self.mDeleteView setHidden:YES];
        [self.mDisplayLabel setHidden:NO];
    }
    else{
        [self.mDeleteView setHidden:NO];
        [self.mDisplayLabel setHidden:YES];
    }
}

-(void)createCheckArray{
    [checkArray removeAllObjects];
    for (int i = 0; i<totalEvent.count; i++) {
        [checkArray addObject:@"No"];
    }
    [self.mUpcomingTableView reloadData];
}
@end
