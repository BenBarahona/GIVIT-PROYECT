//
//  GIM_MyAccountViewController.m
//  GiveItMobile
//
//  Created by Administrator on 02/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_MyAccountViewController.h"

@interface GIM_MyAccountViewController ()

@end

@implementation GIM_MyAccountViewController
@synthesize doaText,dobText,passwordText,cvvText,cardNoText,confirmPassword,nameOfCardText,expiryDateText;

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
    [_indc stopAnimating];
    _mTableView.hidden = YES;
    cardNameArray = [[NSArray alloc] initWithObjects:@"Master Card", @"Visa", @"American Express", @"Discover", nil];
    _mPickerView.hidden = YES;
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
    [_mDatePicker setDatePickerMode:UIDatePickerModeDate];
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
    cardNoText.inputAccessoryView = toolBar;
    cvvText.inputAccessoryView = toolBar;
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    
    userModel.email = [[NSUserDefaults standardUserDefaults] valueForKey:@"Myemail"];
    
    userModel.password = [[NSUserDefaults standardUserDefaults] valueForKey:@"Mypass"];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"UserToken %@",appD.deviceTokenString);
    userModel.deviceToken = appD.deviceTokenString;
    
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    
    userController.delegate = self;
    
    [userController myAcc:userModel];
    
    [self.mScrollView setContentSize:CGSizeMake(320, 480)];
   NSLog(@"%@", [_mDatePicker.viewForBaselineLayout subviews]);
	// Do any additional setup after loading the view.
}

-(void)didAccountLoad:(NSString *)msg{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"] != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"]];
        originalCardNo = [dict valueForKey:@"cardno"];
        NSString* bar = [originalCardNo substringToIndex:[originalCardNo length]-4];
        for (int i=0; i<10; i++) {
            bar = [bar stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d",i] withString:@"X"];
        }
        NSLog(@"%@", bar);
        dobText.text = [dict valueForKey:@"dob"];
        doaText.text = [dict valueForKey:@"doa"];
        _mNameTextField.text = [dict valueForKey:@"nameOnCard"];
        cardNoText.text = [NSString stringWithFormat:@"%@%@",bar,[originalCardNo substringFromIndex:[originalCardNo length]-4]];
        nameOfCardText.text = [dict valueForKey:@"cardname"];
        cvvText.text = [dict valueForKey:@"cvv"];
        expiryDateText.text = [dict valueForKey:@"exDt"];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    return nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:15] forKeyPath:@"button.font"];
    [self setValue:[UIFont fontWithName:@"DroidSans-Bold" size:13] forKeyPath:@"label.font"];
    self.navigationController.title = @"My Account";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:NO];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------

-(void)didError:(NSString *)msg{
    [_indc stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



-(void)didAccount:(NSString *)msg isSuccess:(BOOL)isSuccess
 {
    if(isSuccess){
        [self.view setUserInteractionEnabled:YES];
        [self.indc stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Account Update Successfully"  delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:dobText.text forKey:@"dob"];
        [dict setValue:doaText.text forKey:@"doa"];
        NSRange isRange = [self.cardNoText.text rangeOfString:@"x" options:NSCaseInsensitiveSearch];
        if(isRange.location == 0) {
            [dict setValue:originalCardNo forKey:@"cardno"];
        } else {
            [dict setValue:cardNoText.text forKey:@"cardno"];
        }
        [dict setValue:nameOfCardText.text forKey:@"cardname"];
        [dict setValue:cvvText.text forKey:@"cvv"];
        [dict setValue:expiryDateText.text forKey:@"exDt"];
        [dict setValue:_mNameTextField.text forKey:@"nameOnCard"];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"accountDetail"];
        [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"email"] forKey:@"Save"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"] != nil) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:@"accountDetail"]];
            originalCardNo = [dict valueForKey:@"cardno"];
            NSString* bar = [originalCardNo substringToIndex:[originalCardNo length]-4];
            for (int i=0; i<10; i++) {
                bar = [bar stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d",i] withString:@"X"];
            }
            dobText.text = [dict valueForKey:@"dob"];
            doaText.text = [dict valueForKey:@"doa"];
            cardNoText.text = [NSString stringWithFormat:@"%@%@",bar,[originalCardNo substringFromIndex:[originalCardNo length]-4]];
            nameOfCardText.text = [dict valueForKey:@"cardname"];
            cvvText.text = [dict valueForKey:@"cvv"];
            expiryDateText.text = [dict valueForKey:@"exDt"];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        [self.view setUserInteractionEnabled:YES];
        [self.indc stopAnimating];
    }
}


- (BOOL) validatemailid: (NSString *) candidate {
    NSString *numericRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}


-(NSString *) validateRegistration{
    
    
    if([dobText.text isEqualToString:@""] || dobText.text == nil || [[dobText.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Date of Birth must not be empty";
        
    }
    else if ([bDate timeIntervalSinceDate:[NSDate date]] > 0){
        return @"Birth day can not be greater then current date";
    }

    
    if([doaText.text isEqualToString:@""] || doaText.text == nil || [[doaText.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Date of Anniversary must not be empty";
        
    }
    
    
    if(![confirmPassword.text isEqualToString: passwordText.text] && passwordText.text.length !=0)
    {
        return @"Confirm Password is not matching with Password";
        
    }
    
   
    if([nameOfCardText.text isEqualToString:@""] || nameOfCardText.text == nil || [[nameOfCardText.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"You must enter a valid Card Type";
        
    }
    if([_mNameTextField.text isEqualToString:@""] || _mNameTextField.text == nil || [[_mNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"You must enter Name on Card";
        
    }
  
    if([cardNoText.text isEqualToString:@""] || cardNoText.text == nil || [[cardNoText.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"You must enter a valid Card No.";
        
    }
    
    if([cvvText.text isEqualToString:@""] || cvvText.text == nil || [[cvvText.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"You must enter a valid CVV No.";
        
    }

    if([expiryDateText.text isEqualToString:@""] || expiryDateText.text == nil || [[expiryDateText.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Expiry Date must not be empty";
        
    }

    
    return @"1";
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
    [cell.textLabel setFont:[UIFont systemFontOfSize:9]];
    cell.textLabel.text = [cardNameArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nameOfCardText.text = [cardNameArray objectAtIndex:indexPath.row];
    _mTableView.hidden = YES;
}


#pragma mark Textfield Delegate
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-20) animated:YES];
    flagTextField = textField;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [textField resignFirstResponder];
    return YES;
}

-(void)barButtonAddText:(id)sender{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [flagTextField resignFirstResponder];
}

#pragma mark IBAction Delegate
#pragma mark -------------------------------------------
- (IBAction)updateButton:(id)sender  {
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [cardNoText resignFirstResponder];
    [cvvText resignFirstResponder];
    [passwordText resignFirstResponder];
    [confirmPassword resignFirstResponder];
    [_mNameTextField resignFirstResponder];
    NSString *validationmsg = [self validateRegistration];
    NSString *validationCard;
    NSRange isRange = [self.cardNoText.text rangeOfString:@"x" options:NSCaseInsensitiveSearch];
    if(isRange.location == 0) {
        validationCard = @"1";
    } else {
        validationCard = [self validatePayement];
    }
    
    if ([validationmsg isEqualToString:@"1"] && [validationCard isEqualToString:@"1"]){
        GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
        userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
        userModel.email = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
        if (passwordText.text.length<=0) {
            userModel.password = @"";
        }
        else{
            userModel.password = self.passwordText.text;
        }
        NSString *dobString = dobText.text;
        NSString *doaString = doaText.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *dobFromString = [[NSDate alloc] init];
        NSDate *doaFromString = [[NSDate alloc] init];
        dobFromString = [dateFormatter dateFromString:dobString];
        doaFromString = [dateFormatter dateFromString:doaString];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        doaString = [dateFormatter stringFromDate:doaFromString];
        dobString = [dateFormatter stringFromDate:dobFromString];
        userModel.dob = dobString;
        userModel.doa = doaString;
        
        
        NSRange isRange = [self.cardNoText.text rangeOfString:@"x" options:NSCaseInsensitiveSearch];
        if(isRange.location == 0) {
            userModel.pCardNo = originalCardNo;
        } else {
            userModel.pCardNo = self.cardNoText.text;
        }
        userModel.pCvv = self.cvvText.text;
        userModel.pexDate = self.expiryDateText.text;
        userModel.pCardType = self.nameOfCardText.text;
        userModel.pNameOnCard = self.mNameTextField.text;
        userModel.newuserid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
        GIM_UserController *userController = [[GIM_UserController alloc]init];
        userController.delegate = self;
        [userController update:userModel];
        [self.view setUserInteractionEnabled:NO];
        [self.indc startAnimating];
    }
    else if ([validationmsg isEqualToString:@"1"] ){
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationCard delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
    }
    else {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
    
}


- (IBAction)didTapToaddBirthDate:(id)sender {
    flagDate =1;
    [_mDatePicker setMinimumDate:nil];
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [flagTextField resignFirstResponder];
    _mPickerView.hidden =NO;
}

- (IBAction)didTapAddAneversary:(id)sender {
    flagDate =2;
    [_mDatePicker setMinimumDate:nil];
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
   [flagTextField resignFirstResponder];
    _mPickerView.hidden =NO;
}

- (IBAction)didTapToSelectCardType:(id)sender {
    flagDate =3;
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [flagTextField resignFirstResponder];
    if (_mTableView.hidden == YES) {
        _mTableView.hidden = NO;
    }
    else{
        _mTableView.hidden = YES;

    }
}
- (IBAction)didTaptoSelectExpairyDate:(id)sender {
    flagDate =3;
    [_mDatePicker setMinimumDate:[NSDate date]];
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [flagTextField resignFirstResponder];
    _mPickerView.hidden =NO;
}

- (IBAction)didTapToSelectDate:(id)sender {
    NSDate *myDate = _mDatePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    switch (flagDate) {
        case 1:{
            [dateFormat setDateFormat:@"MM/dd/YYYY"];
            NSString *selectDate = [dateFormat stringFromDate:myDate];
            dobText.text = selectDate;
            bDate = _mDatePicker.date;
        }
            break;
        case 2:{
            [dateFormat setDateFormat:@"MM/dd/YYYY"];
            NSString *selectDate = [dateFormat stringFromDate:myDate];
            doaText.text = selectDate;
        }
            break;
        case 3:{
            [dateFormat setDateFormat:@"YYYY-MM"];
            NSString *selectDate = [dateFormat stringFromDate:myDate];
           expiryDateText.text = selectDate;
        }
            break;
            
        default:
            break;
    }
    _mPickerView.hidden = YES;
}

- (IBAction)didTapToCancelDate:(id)sender {
    _mPickerView.hidden =YES;
}
#pragma mark Perform Segue
#pragma mark -------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"seguePerform"]){
        GIM_GiveGiftCard_SelectContactViewController *give = [segue destinationViewController];
        give.isHideContinue = YES;
    }
    else if([[segue identifier] isEqualToString:@"SocialLogin"])
    {
        GIM_SocialSynViewController *social = [segue destinationViewController];
        social.delegate = (id)self;
    }
}

#pragma mark Validation
#pragma mark -------------------------------------------


-(NSString *) validatePayement
{
    if ([nameOfCardText.text isEqualToString:@"Visa"]) {
        return [self validateVISAcard];
    }
    
    else if ([nameOfCardText.text isEqualToString:@"Master Card"]) {
        return [self validateMASTERcard ];
    }
    
    else if ([nameOfCardText.text isEqualToString:@"American Express"]) {
        return [self validateAMEXcard ];
    }
    
    else if ([nameOfCardText.text isEqualToString:@"Discover"]) {
        return [self validateDiscoverCard];
        
    }
    else{
        return @"Select A Card Type";
    }
    return @"1";
    
}




-(NSString *) validateMASTERcard
{
    
    
    if([cardNoText.text isEqualToString:@""] || cardNoText == nil )
    {
        return @"Card Number must not be empty";
        
    }
    if([self validateCardNoMastercard :cardNoText.text] !=1)
        
    {
        
        return @"Card Number is not in correct format";
    }
    return @"1";
    
    
    
}

-(NSString *) validateVISAcard
{
    if([cardNoText.text isEqualToString:@""] || cardNoText == nil )
    {
        return @"Card Number must not be empty";
        
    }
    if([self validateCardNoVisacard:cardNoText.text] !=1)
        
    {
        
        return @"Card Number is not in correct format";
    }
    return @"1";
    
    
}

-(NSString *) validateAMEXcard
{
    if([cardNoText.text isEqualToString:@""] || cardNoText == nil )
    {
        return @"Card Number must not be empty";
        
    }
    
    if([self validateCardNoAMEXcard:cardNoText.text] !=1)
        
    {
        
        return @"Card Number is not in correct format";
    }
    
    return @"1";
    
    
    
}



-(NSString *) validateDiscoverCard
{
    if([cardNoText.text isEqualToString:@""] || cardNoText == nil )
    {
        return @"Card Number must not be empty";
        
    }
    if([self validateDiscoverCard:cardNoText.text] !=1)
        
    {
        
        return @"Card Number is not in correct format";
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


@end
