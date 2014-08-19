//
//  GIM_Eventlist.m
//  GiveItMobile
//
//  Created by Bhaskar on 08/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 3.0f

#import "GIM_Eventlist.h"
#import "GIM_EventCell.h"
@interface GIM_Eventlist ()

@end

@implementation GIM_Eventlist

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
    [_mTimeZoneTableView setHidden:YES];
    totalTimeZone = [NSMutableArray arrayWithArray:[NSTimeZone knownTimeZoneNames]];
    demoTimeZone = [NSMutableArray arrayWithArray:[NSTimeZone knownTimeZoneNames]];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:_currentDate];
    _mDateLabel.text = stringFromDate;
    formatter = nil;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [formatter stringFromDate:_currentDate];
    [_mDatePicker setDatePickerMode:UIDatePickerModeDate];
    NSString *dateString1 = @"01-02-2010";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString1];
    [_mDatePicker setDate:dateFromString animated:YES];
    dateString1 = @"01-08-2010";
    dateFromString = [dateFormatter dateFromString:dateString1];
    dateFormatter = nil;
    [_mDatePicker setDate:dateFromString animated:YES];
    [_mDatePicker setDate:[NSDate date] animated:YES];
    [_mAddEventView setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:(id)self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    _mPickerView.hidden =YES;
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"List of Events";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:NO];
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    userModel.date = dateString;
    userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    userController.delegate =(id)self;
    [userController events_users:userModel];
    [_mEventActivityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView DataSource Delegate
#pragma mark -------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _mTableView) {
        return totalEvent.count;
    } else {
        return demoTimeZone.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _mTableView) {
        static NSString *CellIdentifier = @"event";
        
        GIM_EventCell *cell = (GIM_EventCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[GIM_EventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.eventNameLabel.text = [[totalEvent objectAtIndex:totalEvent.count-indexPath.row-1]valueForKey:@"title"];
        cell.eventTimeLabel.text = [[totalEvent objectAtIndex:totalEvent.count-indexPath.row-1]valueForKey:@"date"];
        cell.eventDescriptionTextView.text = [[totalEvent objectAtIndex:totalEvent.count-indexPath.row-1]valueForKey:@"description"];
        cell.eventDescriptionTextView.tag = indexPath.row;
        return cell;
    } else {
        static NSString *CellIdentifier = @"new";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        [cell.textLabel setFont:[UIFont fontWithName:@"Droid Sans" size:12]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.text = [demoTimeZone objectAtIndex:indexPath.row];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _mTableView) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"GivitLater"] isEqualToString:@"Yes"]&&([_currentDate timeIntervalSinceDate:[NSDate date]] >= 0 || [stringFromDate isEqualToString:dateString])) {
            [_paymentDict setValue:[[totalEvent objectAtIndex:totalEvent.count-indexPath.row-1] valueForKey:@"date"] forKey:@"schedule"];
            [self performSegueWithIdentifier:@"segueToPayment" sender:self];
        }
        else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"GivitLater"] isEqualToString:@"Yes"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Event Date should be greater than Current Date" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    } else {
        _mDurationTextField.text = [demoTimeZone objectAtIndex:indexPath.row];
        [_mTimeZoneTableView setHidden:YES];
    }
}


#pragma mark Class Method
#pragma mark -------------------------------------------

-(void)gotoAddNewContact{
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.view.frame];
    _mAddEventView.hidden = NO;
    _mLocationTextField.text=_mDateLabel.text;
}

#pragma mark Perform Segue
#pragma mark -------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"segueAddEvent"]){
        GIM_AddEvent *event = [segue destinationViewController];
        event.currentDate = dateString;
    }
    else if([[segue identifier] isEqualToString:@"segueToPayment"]){
        GIM_PayementViewController *give = [segue destinationViewController];
        give.paymentDict = _paymentDict;
    }
}
#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------


-(void)didError:(NSString *)msg{
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


-(void)didEvents_user:(NSArray *)msg isSuccess:(BOOL)isSuccess {
    [_mActivityIndicator stopAnimating];
    [_mEventActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
    _mLocationTextField.text = nil;
    _mTitleTextField.text = nil;
    _mDescriptionTextField.text = nil;
    _mDurationTextField.text = nil;
    demoTimeZone = [NSMutableArray arrayWithArray:(NSArray *)totalTimeZone];
    [_mTimeZoneTableView reloadData];
    _mAddEventView.hidden = YES;
    if(isSuccess){
        totalEvent = [NSMutableArray arrayWithArray:msg];
    }
    NSMutableArray *fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"FBEvents"]];
    for (int i = 0 ; i < fbEvent.count; i++) {
        if ([[[fbEvent objectAtIndex:i] valueForKey:@"date"] isEqualToString:dateString] ) {
            if (!totalEvent) {
                totalEvent =[[NSMutableArray alloc] init];
            }
            [totalEvent addObject:[fbEvent objectAtIndex:i]];
        }
    }
    fbEvent = nil;
    fbEvent = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"GmailEvents"]];
    for (int i = 0 ; i < fbEvent.count; i++) {
        if ([[[fbEvent objectAtIndex:i] valueForKey:@"date"] isEqualToString:dateString] ) {
            if (!totalEvent) {
                totalEvent =[[NSMutableArray alloc] init];
            }
            [totalEvent addObject:[fbEvent objectAtIndex:i]];
        }
    }
    [_mTableView reloadData];
}

-(void)didEvents_save:(NSString *)msg isSuccess:(BOOL)isSuccess {
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    if(isSuccess){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        dateString = [formatter stringFromDate:_currentDate];
        userModel.date = dateString;
        userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
        GIM_UserController *userController = [[GIM_UserController alloc]init];
        userController.delegate = (id)self;
        [userController events_users:userModel];
        [_mActivityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_mTableView reloadData];
    
}

- (IBAction)didTapToOpenDatePicker:(id)sender {
    _mPickerView.hidden =NO;
}
- (IBAction)didTapToSelectDate:(id)sender {
    NSDate *myDate = _mDatePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    NSString *selectDate = [dateFormat stringFromDate:myDate];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    dateString =[dateFormat stringFromDate:myDate];
    _mLocationTextField.text = selectDate;
    _mPickerView.hidden = YES;
}

- (IBAction)didTapToCancelDate:(id)sender {
    _mPickerView.hidden =YES;
}

- (IBAction)didTapAddEvent:(id)sender {
    [_mLocationTextField resignFirstResponder];
    [_mTitleTextField resignFirstResponder];
    [_mDescriptionTextField resignFirstResponder];
    [_mDurationTextField resignFirstResponder];
    
    NSString *validationmsg = [self validateEvent];
    
    if ([validationmsg isEqualToString:@"1"] ){
        GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
        userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
        userModel.title = self.mTitleTextField.text;
        userModel.description = self.mDescriptionTextField.text;
        userModel.date = dateString;
        GIM_UserController *userController = [[GIM_UserController alloc]init];
        userController.delegate = (id)self;
        [userController events_save:userModel];
        [_mActivityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
    }
    
    else {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}
- (IBAction)didTapClose:(id)sender {
    demoTimeZone = [NSMutableArray arrayWithArray:(NSArray *)totalTimeZone];
    [_mTimeZoneTableView reloadData];
    _mLocationTextField.text = nil;
    _mTitleTextField.text = nil;
    _mDescriptionTextField.text = nil;
    _mDurationTextField.text = nil;
    [_mLocationTextField resignFirstResponder];
    [_mTitleTextField resignFirstResponder];
    [_mDescriptionTextField resignFirstResponder];
    [_mDurationTextField resignFirstResponder];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
    _mAddEventView.hidden = YES;
}


#pragma mark Validation
#pragma mark -------------------------------------------


-(NSString *) validateEvent{
    
    if([_mTitleTextField.text isEqualToString:@""] || _mTitleTextField.text == nil || [[_mTitleTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Name must not be empty";
        
    }
    
    if([_mDescriptionTextField.text isEqualToString:@""] || _mDescriptionTextField.text == nil || [[_mDescriptionTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Event must not be empty";
        
    }
    
//    if([_mDurationTextField.text isEqualToString:@""] || _mDurationTextField.text == nil || [[_mDurationTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)    {
//        return @"Timezone must not be empty";
//        
//    }
    if([_mLocationTextField.text isEqualToString:@""] || _mLocationTextField.text == nil || [[_mLocationTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Date must not be empty";
        
    }
    return @"1";
}





#pragma mark Textfield Delegate
#pragma mark -------------------------------------------

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _mDurationTextField) {
        [_mTimeZoneTableView setHidden:NO];
    }else{
        [_mTimeZoneTableView setHidden:YES];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _mDurationTextField) {
        [_mTimeZoneTableView setHidden:NO];
    }else{
        [_mTimeZoneTableView setHidden:YES];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_mTimeZoneTableView setHidden:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)barButtonAddText:(id)sender{
}
-(void)textChanged:(id)sender{
    UITextField *textField = [(NSNotification *)sender object];
    if (textField == _mDurationTextField) {
        [demoTimeZone removeAllObjects];
        demoTimeZone = nil;
        demoTimeZone = [[NSMutableArray alloc] init];
        if ([textField.text length]>0) {
            for (int i = 0 ; i<totalTimeZone.count; i++) {
                NSRange stringRange = [[totalTimeZone objectAtIndex:i]  rangeOfString:textField.text options:NSCaseInsensitiveSearch];
                if(stringRange.location != NSNotFound){
                    [demoTimeZone addObject:[totalTimeZone objectAtIndex:i]];
                }
            }
        }else{
            demoTimeZone = [NSMutableArray arrayWithArray:(NSArray *)totalTimeZone];
        }
        [_mTimeZoneTableView reloadData];
    }
}

@end
