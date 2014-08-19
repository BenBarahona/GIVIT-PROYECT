//
//  GIM_PayementViewController.m
//  GiveItMobile
//
//  Created by Administrator on 26/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_PayementViewController.h"

@interface GIM_PayementViewController ()

@end

@implementation GIM_PayementViewController

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
    isSelected = NO;
    NSLog(@"Content Size %@",NSStringFromCGRect(self.mScrollView.frame));
    [self.mScrollView setContentSize:CGSizeMake(320, 400)];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:24] forKeyPath:@"label.font"];
    _mTableView.hidden = YES;
    cardNameArray = [[NSArray alloc] initWithObjects:@"Master Card", @"Visa", @"American Express", @"Discover", nil];
    [_mDatePicker setDatePickerMode:UIDatePickerModeDate];
    _mPickerView.hidden = YES;
    _mDueLabel.text = [NSString stringWithFormat:@"$%0.2f",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Amount"] floatValue]];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     0.0f,
                                                                     self.view.window.frame.size.width,
                                                                     44.0f)];
    
    toolBar.items =   @[ [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(barButtonAddText:)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                       target:nil
                                                                       action:nil],
                         // some more items could be added
                         ];
    _mCardNumberTextField.inputAccessoryView = toolBar;
    _mCvvNumberTextField.inputAccessoryView = toolBar;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"] != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"]];
        originalCardNo = [dict valueForKey:@"cardno"];
        NSString* bar = [originalCardNo substringToIndex:[originalCardNo length]-4];
        for (int i=0; i<10; i++) {
            bar = [bar stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d",i] withString:@"X"];
        }
        NSLog(@"%@", bar);
        _mCardNumberTextField.text = [NSString stringWithFormat:@"%@%@",bar,[originalCardNo substringFromIndex:[originalCardNo length]-4]];
        _mCardTypeTextfield.text = [dict valueForKey:@"cardname"];
        _mNameOnCard.text = [dict valueForKey:@"nameOnCard"];
        _mCvvNumberTextField.text = [dict valueForKey:@"cvv"];
        _mExpiryDateTextField.text = [dict valueForKey:@"exDt"];
    }
    NSString *dateString = @"01-02-2010";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    [_mDatePicker setDate:dateFromString animated:YES];
    dateString = @"01-08-2010";
    dateFromString = [dateFormatter dateFromString:dateString];
    dateFormatter = nil;
    [_mDatePicker setDate:dateFromString animated:YES];
    [_mDatePicker setDate:[NSDate date] animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"Payment Details";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    appD.isPaymentView =YES;
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    appD.isPaymentView =NO;
}
#pragma mark TableView DataSource Delegate
#pragma mark -------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cardNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    cell.textLabel.text = [cardNameArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _mCardTypeTextfield.text = [cardNameArray objectAtIndex:indexPath.row];
    _mTableView.hidden = YES;
}


#pragma mark IBAction Methods
#pragma mark -------------------------------------------

- (IBAction)buyNsendButton:(id)sender {
    if(_mNameOnCard.text.length<=0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You must enter Name on Card" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        return;
        
    }

    NSString *validationmsg;
    NSRange isRange = [_mCardNumberTextField.text rangeOfString:@"x" options:NSCaseInsensitiveSearch];
    if(isRange.location == 0 && _mCardNumberTextField.text.length > 0&& _mCardTypeTextfield.text.length > 0&& _mCvvNumberTextField.text.length > 0&& _mExpiryDateTextField.text.length > 0) {
        validationmsg = @"1";
    } else {
        validationmsg = [self validatePayement];
    }
    
    if ([validationmsg isEqualToString:@"1"] ){
        GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
        userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
        NSRange isRange = [_mCardNumberTextField.text rangeOfString:@"x" options:NSCaseInsensitiveSearch];
        cardDetail = [[NSMutableDictionary alloc] init];
        if(isRange.location == 0) {
            userModel.pCardNo = originalCardNo;
        } else {
            userModel.pCardNo = _mCardNumberTextField.text;
        }
        userModel.pCardType = _mCardTypeTextfield.text;
        userModel.pCvv = _mCvvNumberTextField.text;
        userModel.pexDate = _mExpiryDateTextField.text;
        userModel.pRetailerId = [self.paymentDict valueForKey:@"id"];
        userModel.pAmount = [NSString stringWithFormat:@"%0.2f",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Amount"] floatValue]];
        userModel.pemail = [_paymentDict valueForKey:@"email"];
        if ([_paymentDict valueForKey:@"schedule"]==nil || [[_paymentDict valueForKey:@"schedule"] length] == 0) {
            userModel.pschedule_date = @"";
            userModel.pSchedule = @"N";
        } else {
            userModel.pschedule_date = [_paymentDict valueForKey:@"schedule"];
            userModel.pSchedule = @"Y";
        }
        userModel.imageOrVideo =[_paymentDict valueForKey:@"imageVideo"];
        userModel.pImageVideo = [_paymentDict valueForKey:@"UploadImage"];
        userModel.pMessage = [_paymentDict valueForKey:@"message"];
        userModel.pNameOnCard = _mNameOnCard.text;
        [cardDetail setValue:userModel.pCardType forKey:@"cardname"];
        [cardDetail setValue:userModel.pNameOnCard forKey:@"nameOnCard"];
        [cardDetail setValue:userModel.pCardNo forKey:@"cardno"];
        [cardDetail setValue:userModel.pexDate forKey:@"exDt"];
        [cardDetail setValue:userModel.pCvv forKey:@"cvv"];
//        userModel.pCardNo = @"6011741015049771";
//        userModel.pCardType = @"Discover";
//        userModel.pCvv = @"111";
//        userModel.pexDate = @"2018-12";
//        userModel.pRetailerId = @"3";
//        userModel.pAmount = @"40";
//        userModel.pemail = @"ass@ccv.com,sdf@cg.com";
//        userModel.pschedule_date = @"";
//        userModel.pSchedule = @"N";
//        cardname = Visa;
//        cardno = 4540390646308530;
//        cvv = 962;
        
        
        GIM_UserController *userController = [[GIM_UserController alloc]init];
        
        userController.delegate = self;
        
        [userController payment:userModel];
        
        [self.view setUserInteractionEnabled:NO];
        
        //[self.indc startAnimating];
        
        [_mActivityIndicator startAnimating];
   }
    else {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}


- (IBAction)didTapToOpenCardNumber:(id)sender {
    [flagTextField resignFirstResponder];
    if (_mTableView.hidden == NO) {
        _mTableView.hidden = YES;
    } else {
        _mTableView.hidden = NO;
    }
}

- (IBAction)didTapToOpenExpiaryDate:(id)sender {
    [_mDatePicker setMinimumDate:[NSDate date]];
   [flagTextField resignFirstResponder];
    _mPickerView.hidden =NO;
}

- (IBAction)didTapToSelectCheckBox:(id)sender {
    if (isSelected == NO) {
        _mCheckBoxImageView.image = [UIImage imageNamed:@"chk_box_02.png"];
        isSelected = YES;
    } else {
        _mCheckBoxImageView.image = [UIImage imageNamed:@"chk_box_01.png"];
        isSelected = NO;
    }
}

- (IBAction)didTapToSelectDate:(id)sender {
    NSDate *myDate = _mDatePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM"];
    NSString *selectDate = [dateFormat stringFromDate:myDate];
    _mExpiryDateTextField.text = selectDate;
    _mPickerView.hidden = YES;
}

- (IBAction)didTapToCancelDate:(id)sender {
    _mPickerView.hidden =YES;
}


#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------



-(void)didError:(NSString *)msg{
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


-(void)didPayement:(NSString *)msg isSuccess:(BOOL)isSuccess {
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    if ([msg isEqualToString:@"Purchase gift card scheduled successfully"]) {
        UIAlertView *alert;
        if (isSelected == YES) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"]];
            if (!dict) {
                dict = [[NSMutableDictionary alloc] init];
            }
            NSRange isRange = [_mCardNumberTextField.text rangeOfString:@"x" options:NSCaseInsensitiveSearch];
            if(isRange.location == 0) {
                [dict setValue:originalCardNo forKey:@"cardno"];
            } else {
                [dict setValue:_mCardNumberTextField.text forKey:@"cardno"];
            }
            [dict setValue:_mCardTypeTextfield.text forKey:@"cardname"];
            [dict setValue:_mCvvNumberTextField.text forKey:@"cvv"];
            [dict setValue:_mExpiryDateTextField.text forKey:@"exDt"];
            [dict setValue:_mNameOnCard.text forKey:@"nameOnCard"];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"accountDetail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
            userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
            userModel.email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
            userModel.password = @"";
            userModel.dob = [dict valueForKey:@"dob"];
            userModel.doa = [dict valueForKey:@"dob"];
            userModel.pCardNo = [cardDetail valueForKey:@"cardno"];
            userModel.pCvv = [cardDetail valueForKey:@"cvv"];
            userModel.pexDate = [cardDetail valueForKey:@"exDt"];
            userModel.pCardType = [cardDetail valueForKey:@"cardname"];
            userModel.pNameOnCard = [cardDetail valueForKey:@"nameOnCard"];
            userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
            GIM_UserController *userController = [[GIM_UserController alloc]init];
            userController.delegate = self;
            [userController update:userModel];
        }
        alert = nil;
        alert= [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
        return;
    }
    if(isSuccess){
        //[self.view setUserInteractionEnabled:YES];
        //[self.indc stopAnimating];
        UIAlertView *alert;
        alert= [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        if ([msg isEqualToString:@"Thank you have purchased gift card."]) {
            NSLog(@"yes");
            if (isSelected == YES) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"]];
                if (!dict) {
                    dict = [[NSMutableDictionary alloc] init];
                }
                NSRange isRange = [_mCardNumberTextField.text rangeOfString:@"x" options:NSCaseInsensitiveSearch];
                if(isRange.location == 0) {
                    [dict setValue:originalCardNo forKey:@"cardno"];
                } else {
                    [dict setValue:_mCardNumberTextField.text forKey:@"cardno"];
                }
                [dict setValue:_mCardTypeTextfield.text forKey:@"cardname"];
                [dict setValue:_mCvvNumberTextField.text forKey:@"cvv"];
                [dict setValue:_mExpiryDateTextField.text forKey:@"exDt"];
                [dict setValue:_mNameOnCard.text forKey:@"nameOnCard"];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"accountDetail"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
                userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
                userModel.email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
                userModel.password = @"";
                userModel.dob = [dict valueForKey:@"dob"];
                userModel.doa = [dict valueForKey:@"dob"];
                userModel.pCardNo = [cardDetail valueForKey:@"cardno"];
                userModel.pCvv = [cardDetail valueForKey:@"cvv"];
                userModel.pexDate = [cardDetail valueForKey:@"exDt"];
                userModel.pCardType = [cardDetail valueForKey:@"cardname"];
                userModel.pNameOnCard = [cardDetail valueForKey:@"nameOnCard"];
                userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
                GIM_UserController *userController = [[GIM_UserController alloc]init];
                userController.delegate = self;
                [userController update:userModel];
            }
            alert = nil;
            alert= [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        }
        
        [alert show];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        //[self.view setUserInteractionEnabled:YES];
        // [self.indc stopAnimating];
    }
}

-(void)didAccount:(NSString *)msg isSuccess:(BOOL)isSuccess
{
    NSLog(@"Update account testing%@",msg);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
        CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
        [tabHome.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self performSegueWithIdentifier:@"segueThanks" sender:self];
    }
}

#pragma mark TextField Delegate
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    flagTextField = textField;
   [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


-(void)barButtonAddText:(id)sender{
    [flagTextField resignFirstResponder];
}
#pragma mark Validation
#pragma mark -------------------------------------------


-(NSString *) validatePayement
{
    if ([_mCardTypeTextfield.text isEqualToString:@"Visa"]) {
        return [self validateVISAcard];
    }
    
    else if ([_mCardTypeTextfield.text isEqualToString:@"Master Card"]) {
        return [self validateMASTERcard ];
    }
    
    else if ([_mCardTypeTextfield.text isEqualToString:@"American Express"]) {
        return [self validateAMEXcard ];
    }
    
    else if ([_mCardTypeTextfield.text isEqualToString:@"Discover"]) {
        return [self validateDiscoverCard];
        
    }
    else{
        return @"You must enter a valid Card Type";
    }
    return @"1";
    
}




-(NSString *) validateMASTERcard
{
    
    
    if([_mCardNumberTextField.text isEqualToString:@""] || self.mCardNumberTextField == nil )
    {
        return @"You must enter a valid Card No.";
        
    }
    if([self validateCardNoMastercard :_mCardNumberTextField.text] !=1)
        
    {
        
        return @"You must enter a valid Card No.";
    }
    
    
    if([_mCvvNumberTextField.text isEqualToString:@""] || self.mCvvNumberTextField == nil )
    {
        return @"You must enter a valid CVV No.";
        
    }
    if([_mCvvNumberTextField.text length] != 3 )
    {
        return @"CVV Number should be of 3 character" ;
        
    }
    if([_mExpiryDateTextField.text isEqualToString:@""] || self.mExpiryDateTextField == nil || _mExpiryDateTextField.text.length <=0 )
    {
        return @"Expiry Date must not be empty";
        
    }
    
    return @"1";
    
    
    
}

-(NSString *) validateVISAcard
{
    if([_mCardNumberTextField.text isEqualToString:@""] || self.mCardNumberTextField == nil )
    {
        return @"You must enter a valid Card No.";
        
    }
    if([self validateCardNoVisacard:_mCardNumberTextField.text] !=1)
        
    {
        
        return @"You must enter a valid Card No.";
    }
    
    
    if([_mCvvNumberTextField.text isEqualToString:@""] || self.mCvvNumberTextField == nil )
    {
        return @"You must enter a valid CVV No.";
        
    }
    if([_mCvvNumberTextField.text length] != 3 )
    {
        return @"CVV Number should be of 3 character" ;
        
    }
    
    
    
    if([_mExpiryDateTextField.text isEqualToString:@""] || self.mExpiryDateTextField == nil|| _mExpiryDateTextField.text.length <=0  )
    {
        return @"Expiry Date must not be empty";
        
    }
    
    
    return @"1";
    
    
}

-(NSString *) validateAMEXcard
{
    if([_mCardNumberTextField.text isEqualToString:@""] || self.mCardNumberTextField == nil )
    {
        return @"You must enter a valid Card No.";
        
    }
    
    if([self validateCardNoAMEXcard:_mCardNumberTextField.text] !=1)
        
    {
        
        return @"You must enter a valid Card No.";
    }
    
    
    
    
    if([_mCvvNumberTextField.text isEqualToString:@""] || self.mCvvNumberTextField == nil )
    {
        return @"You must enter a valid CVV No.";
        
    }
    if([_mCvvNumberTextField.text length] != 3 )
    {
        return @"CVV Number should be of 3 character" ;
        
    }
    
    
    
    if([_mExpiryDateTextField.text isEqualToString:@""] || self.mExpiryDateTextField == nil || _mExpiryDateTextField.text.length <=0 )
    {
        return @"Expiry Date must not be empty";
        
    }
    
    return @"1";
    
    
    
}



-(NSString *) validateDiscoverCard
{
    if([_mCardNumberTextField.text isEqualToString:@""] || self.mCardNumberTextField == nil )
    {
        return @"You must enter a valid Card No.";
        
    }
    if([self validateDiscoverCard:_mCardNumberTextField.text] !=1)
        
    {
        
        return @"You must enter a valid Card No.";
    }
    
    
    if([_mCvvNumberTextField.text isEqualToString:@""] || self.mCvvNumberTextField == nil )
    {
        return @"You must enter a valid CVV No.";
        
    }
    
    if([_mCvvNumberTextField.text length] != 3 )
    {
        return @"CVV Number should be of 3 character" ;
        
    }
    
    if([_mExpiryDateTextField.text isEqualToString:@""] || self.mExpiryDateTextField == nil || _mExpiryDateTextField.text.length <=0  )
    {
        return @"Expiry Date must not be empty";
        
    }
    
    
    return @"1";
    
    
}




- (BOOL) validateCardNoVisacard: (NSString *) candidate {
    NSString *numericRegex = @"^4[0-9]{12}(?:[0-9]{3})?$";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}



- (BOOL) validateCardNoMastercard: (NSString *) candidate {
    NSString *numericRegex = @"^5[1-5][0-9]{14}$";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}



- (BOOL) validateCardNoAMEXcard: (NSString *) candidate {
    NSString *numericRegex = @"^3[47][0-9]{13}$";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}

- (BOOL) validateDiscoverCard: (NSString *) candidate {
    NSString *numericRegex = @"^6(?:011|5[0-9]{2})[0-9]{12}$";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}

- (IBAction)mNameOnCardTextField:(id)sender {
}
@end
