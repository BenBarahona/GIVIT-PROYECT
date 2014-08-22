//
//  GIM_MyMessage.m
//  GiveItMobile
//
//  Created by Bhaskar on 09/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_MyMessage.h"

@interface GIM_MyMessage ()

@end

@implementation GIM_MyMessage

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"My Messages";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
    [self loadMessage];
}

-(void)loadMessage{
    selectedindex = -1;
    totalMassege = Nil;
    totalMassege = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"myMessage"]];
    selectedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<totalMassege.count; i++) {
        [selectedArray addObject:@"No"];
    }
    if (totalMassege.count == 0) {
        _demoLabel.hidden = NO;
        self.SelectView.hidden = YES;
    }
    else{
        _demoLabel.hidden = YES;
        self.SelectView.hidden = NO;
    }
    [self.mTableview reloadData];
}
#pragma mark TableView DataSource Delegate
#pragma mark -------------------------------------------


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isTapToRead == YES && selectedindex == indexPath.row) {
        UILabel * label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        label.text = [[totalMassege objectAtIndex:indexPath.row] valueForKey:@"message"];
        [label setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
        CGSize maximumLabelSize = CGSizeMake(204, FLT_MAX);
        CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [label setFrame:CGRectMake(35, 32, expectedLabelSize.width, expectedLabelSize.height)];
        isTapToRead = NO;
        ;
        heightForCell = expectedLabelSize.height;
        return expectedLabelSize.height+45;
    }
    else{
        return 80.0f;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return totalMassege.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myMessageCell";
    
    GIM_MyMessageCell *cell = (GIM_MyMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[GIM_MyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.mBackgroundView.layer.cornerRadius = 5.0;

    if (selectedindex == indexPath.row) {
        [cell.mMymessageLabel setBackgroundColor:[UIColor clearColor]];
        [cell.mMymessageLabel setTextColor:[UIColor blackColor]];
        cell.mMymessageLabel.text = [[totalMassege objectAtIndex:indexPath.row] valueForKey:@"message"];
        [cell.mMymessageLabel setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
        CGSize maximumLabelSize = CGSizeMake(204, FLT_MAX);
        CGSize expectedLabelSize = [cell.mMymessageLabel.text sizeWithFont:cell.mMymessageLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.mMymessageLabel.lineBreakMode];
        cell.mMymessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.mMymessageLabel.numberOfLines = 0;
        [cell.mMymessageLabel setFrame:CGRectMake(35, 32, expectedLabelSize.width, expectedLabelSize.height)];
        [cell.mBackgroundView setFrame:CGRectMake(0, 2, 280, expectedLabelSize.height+40)];
//       selectedindex=-1;
    }
    else{
        [cell.mBackgroundView setFrame:CGRectMake(0, 2, 280, 75)];
        [cell.mMymessageLabel setFrame:CGRectMake(35, 32, 204, 35)];
        cell.mMymessageLabel.numberOfLines = 2;
    }
    [cell setDelegate:(id)self];
    [cell.mCheckButton setTag:indexPath.row];
    [cell.mGotoButton setTag:indexPath.row];
    if ([[selectedArray objectAtIndex:indexPath.row]isEqualToString:@"Yes"]) {
        [cell.mCheckButton setImage:[UIImage imageNamed:@"chk_box_02.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.mCheckButton setImage:[UIImage imageNamed:@"chk_box_01.png"] forState:UIControlStateNormal];
    }
    cell.mDateLabel.text = [NSString stringWithFormat:@"%@",[[totalMassege objectAtIndex:indexPath.row] valueForKey:@"messagedate"]];
    cell.mMymessageLabel.text = [NSString stringWithFormat:@"%@",[[totalMassege objectAtIndex:indexPath.row] valueForKey:@"message"]];
    if ([[[totalMassege objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"unread"]) {
        [cell.mMymessageLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
        [cell.mDateLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:13]];
    }
    else{
        [cell.mMymessageLabel setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
        [cell.mDateLabel setFont:[UIFont fontWithName:@"Droid Sans" size:13]];
    }
    
    
//    CGPoint point = cell.center;
//    CGPoint select = cell.mCheckButton.center;
//    select.y = point.y;
//    [cell.mCheckButton setCenter:select];
//    select = cell.mGotoButton.center;
//    select.y = point.y;
//    [cell.mGotoButton setCenter:select];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[totalMassege objectAtIndex:indexPath.row]];
    [dict setValue:@"read" forKey:@"status"];
    [totalMassege replaceObjectAtIndex:indexPath.row withObject:dict];
    [[NSUserDefaults standardUserDefaults] setObject:totalMassege forKey:@"myMessage"];
    isTapToRead = YES;
    selectedindex = indexPath.row;
    NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
    [self.mTableview reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
}


- (IBAction)didTapSelectAll:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == NO) {
        btn.selected = YES;
        [self.mSelectAllImageView setImage:[UIImage imageNamed:@"chk_box_02.png"]];
        [selectedArray removeAllObjects];
        for (int i = 0; i<totalMassege.count; i++) {
            [selectedArray addObject:@"Yes"];
        }
    }
    else{
        btn.selected = NO;
        [self.mSelectAllImageView setImage:[UIImage imageNamed:@"chk_box_01.png"]];
        [selectedArray removeAllObjects];
        for (int i = 0; i<totalMassege.count; i++) {
            [selectedArray addObject:@"No"];
        }
    }
    [self.mTableview reloadData];
}

- (IBAction)didTapDeleteButton:(id)sender {
    for (int i = 0; i<totalMassege.count;) {
        if ([[selectedArray objectAtIndex:i]isEqualToString:@"Yes"]) {
            [totalMassege removeObjectAtIndex:i];
            [selectedArray removeObjectAtIndex:i];
        }
        else{
            i++;
        }
    }
    selectedindex = -1;
    [self.mTableview reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:totalMassege forKey:@"myMessage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (totalMassege.count == 0) {
        _demoLabel.hidden = NO;
        self.SelectView.hidden = YES;
    }
    else{
        _demoLabel.hidden = YES;
        self.SelectView.hidden = NO;
    }
}

-(void)checkButtonClickedwithTag:(int)tag{
    if ([[selectedArray objectAtIndex:tag]isEqualToString:@"Yes"]) {
        [selectedArray replaceObjectAtIndex:tag withObject:@"No"];
    }
    else{
        [selectedArray replaceObjectAtIndex:tag withObject:@"Yes"];
    }
    [self.mTableview reloadData];
}

-(void)gotoButtonClickedwithTag:(int)tag{
//    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appD.massageTapScreen = [[totalMassege objectAtIndex:tag] valueForKey:@"msg_type"];
//    if ([[(UINavigationController *)appD.window.rootViewController viewControllers]count]>=2 && ![appD.massageTapScreen isEqualToString:@"MESSAGE"]&&![appD.massageTapScreen isEqualToString:@"SEND_GIFT_CARD_FROM"]) {
//        [(UINavigationController *)appD.window.rootViewController popToViewController:[[(UINavigationController *)appD.window.rootViewController viewControllers] objectAtIndex:1] animated:YES];
//    }
//    else{
//        appD.massageTapScreen = @"";
//    }
//
//    NSLog(@"selected msg type %@",[totalMassege objectAtIndex:tag]);
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
//    tabHome.delegate = (id)self;
    if (![[[totalMassege objectAtIndex:tag] valueForKey:@"msg_type"] isEqualToString:@"MESSAGE"]&&![[[totalMassege objectAtIndex:tag] valueForKey:@"msg_type"]isEqualToString:@"SEND_GIFT_CARD_FROM"]) {
        [tabHome didOpenMassage:[[totalMassege objectAtIndex:tag] valueForKey:@"msg_type"]];
    }
}
@end
