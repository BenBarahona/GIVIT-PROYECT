//
//  GIM_AddNewGiftCardViewController.m
//  GiveItMobile
//
//  Created by Administrator on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_AddNewGiftCardViewController.h"

@interface GIM_AddNewGiftCardViewController ()

@end

@implementation GIM_AddNewGiftCardViewController
@synthesize ckeckBoxTableView,nameLabel,retailerNameText,cardCodeText,couponNoText,purchaseDateText,expiryDateText,amountText;

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
    [_mSubmitButton setFrame:CGRectMake(_mSubmitButton.frame.origin.x, couponNoText.frame.size.height+couponNoText.frame.origin.y+30, _mSubmitButton.frame.size.width, _mSubmitButton.frame.size.height)];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    userController.delegate = (id)self;
    [userController buyGiftCard:userModel];
    [_mActivityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    self.ckeckBoxTableView.hidden = YES;
    ckeckBoxTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _otherRetailerFormView.hidden = YES;
    [_mDatePicker setDatePickerMode:UIDatePickerModeDate];
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
    couponNoText.inputAccessoryView = toolBar;
    cardCodeText.inputAccessoryView = toolBar;
    amountText.inputAccessoryView = toolBar;
	// Do any additional setup after loading the view.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"Add New Gift Card";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
}


- (IBAction)checkBox:(id)sender {
    if (ckeckBoxTableView.hidden == YES) {
        self.ckeckBoxTableView.hidden = NO;
    }
    else{
        self.ckeckBoxTableView.hidden = YES;
    }
}

#pragma mark TableView DataSource Delegate
#pragma mark -------------------------------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemGiftCardDetails.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    UIView *bgV = [[UIView alloc] initWithFrame:cell.frame];
    [bgV setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor] ];
    [cell setBackgroundView:bgV];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    if (indexPath.row == itemGiftCardDetails.count) {
       cell.textLabel.text = @"Other Retailer";
    }
    else{
        cell.textLabel.text = [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"name"];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [nameLabel setTextColor:[UIColor blackColor]];
    
    if (indexPath.row == itemGiftCardDetails.count) {
        nameLabel.text = @"Other Retailer";
        _otherRetailerFormView.hidden = NO;
        [_mSubmitButton setFrame:CGRectMake(_mSubmitButton.frame.origin.x, _otherRetailerFormView.frame.size.height+_otherRetailerFormView.frame.origin.y+10, _mSubmitButton.frame.size.width, _mSubmitButton.frame.size.height)];
        couponNoText.text = nil;
    }
    else{
        re_id =[NSString stringWithFormat:@"%@",[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"id"]];
        nameLabel.text = [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"name"];
        _otherRetailerFormView.hidden = YES;
        [_mSubmitButton setFrame:CGRectMake(_mSubmitButton.frame.origin.x, couponNoText.frame.size.height+couponNoText.frame.origin.y+30, _mSubmitButton.frame.size.width, _mSubmitButton.frame.size.height)];
        retailerNameText.text = nil;
        cardCodeText.text = nil;
        purchaseDateText.text = nil;
        expiryDateText.text = nil;
        amountText.text = nil;
    }
    
    self.ckeckBoxTableView.hidden = YES;
    
}


#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------

-(void)didBuyGiftCard:(NSArray *)returnData isSuccess:(BOOL)isSuccess{
    [self.view setUserInteractionEnabled:YES];
    [_mActivityIndicator stopAnimating];
   if (isSuccess == YES) {
        itemGiftCardDetails = [NSMutableArray arrayWithArray:[returnData valueForKey:@"item"]];
        [ckeckBoxTableView reloadData];
    }
}

-(void)didAddGiftCard:(NSString *)msg isSuccess:(BOOL)isSuccess {
    [self.view setUserInteractionEnabled:YES];
    [_mActivityIndicator stopAnimating];
   if(isSuccess){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Done" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
    }
}


-(void)didError:(NSString *)msg{
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



- (IBAction)submitButton:(id)sender {
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [flagTextField resignFirstResponder];
    if ([nameLabel.text isEqualToString:@"Select Retailer Name"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Must Enter A Retailer Name" delegate:Nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if ([nameLabel.text isEqualToString:@"Other Retailer"]) {
        NSString *validationmsg = [self validateOtherCoupon];
        
        if ([validationmsg isEqualToString:@"1"] ){
            
            
            GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:self.purchaseDateText.text];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *selectDate = [dateFormatter stringFromDate:dateFromString];
            userModel.couponCode = self.cardCodeText.text;
            userModel.retailelName = self.retailerNameText.text;
            userModel.retaileramount = self.amountText.text;
            userModel.purchaseDate = selectDate;
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            dateFromString = [dateFormatter dateFromString:self.expiryDateText.text];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            selectDate = [dateFormatter stringFromDate:dateFromString];
            userModel.expDate = selectDate;
            userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
            
            GIM_UserController *userController = [[GIM_UserController alloc]init];
            
            userController.delegate = self;
            
            [userController otherCoupon: userModel];
            [self.view setUserInteractionEnabled:NO];
            [_mActivityIndicator startAnimating];
       }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [alert show];
            
        }
        
    }
    else{
        NSString *validationmsg = [self validateOtherCoupon];
       if ([validationmsg isEqualToString:@"1"] ){
           GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
           userModel.userid = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
           userModel.retailerId = re_id;
           userModel.couponCode = self.couponNoText.text;
           
           GIM_UserController *userController = [[GIM_UserController alloc]init];
           
           userController.delegate = self;
           
           [userController addGiftCard: userModel];
           [self.view setUserInteractionEnabled:NO];
           [_mActivityIndicator startAnimating];
       }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [alert show];
            
        }
        
        
    }
        

   
}
#pragma mark TextField Delegate
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag > 100) {
        [_mScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y+80) animated:YES];       
    }
    flagTextField = textField;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_mScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)scanBarCodeButton:(id)sender {
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    tabHome.delegate = (id)self;
    [tabHome didOpenCameraforBarcode:YES];
}

-(void)didOtherCoupon:(NSString *)msg isSuccess:(BOOL)isSuccess {
    [_mActivityIndicator stopAnimating];
    if(isSuccess){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[ msg  stringByConvertingHTMLToPlainText] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        

        
        [alert show];
        
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
    }
}


-(NSString *) validateOtherCoupon{
    
    
    if ([nameLabel.text isEqualToString:@"Other Retailer"]) {
        if (retailerNameText.text.length<=0) {
            return @"Retailer Name must not be empty";
        }
        else if (cardCodeText.text.length<=0){
            return @"Coupon Code must not be empty";
        }
        else if (purchaseDateText.text.length<=0){
            return @"Purchase Date must not be empty";
        }
        else if (expiryDateText.text.length<=0){
            return @"Expiry Date must not be empty";
        }
        else if ([purchaseDate timeIntervalSinceDate:expairyDate] > 0){
            return @"Expiry Date should be greater than Purchase Date";
        }
        else if ([[NSDate date] timeIntervalSinceDate:expairyDate] > 0){
            return @"Expiry Date should be greater than Purchase Date";
        }
        else if ([amountText.text intValue]<=0){
            return @"Amount must not be empty";
        }
        else {
            return @"1";
       }
        return @"1";
    }
    else if (nameLabel.text.length<=0){
        return @"Retailer Name must not be empty";
    }
    else{
        if (couponNoText.text.length<=0) {
            return @"Coupon Code must not be empty";
        }
        return @"1";
    }
    return @"1";
}

- (IBAction)didTapToEnterPurchaseDate:(id)sender {
    expiryDateText.text = nil;
    [flagTextField resignFirstResponder];
    _mPickerView.hidden =NO;
    dateFlag =1;
}

- (IBAction)didTapToEnterExpairyDate:(id)sender {
    [flagTextField resignFirstResponder];
    _mPickerView.hidden =NO;
    dateFlag =2;
}
- (IBAction)didTapToSelectDate:(id)sender {
    NSDate *myDate = _mDatePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    NSString *selectDate = [dateFormat stringFromDate:myDate];
    if (dateFlag == 1) {
        purchaseDate = myDate;
        purchaseDateText.text = selectDate;
    }
    else{
        expairyDate = myDate;
        expiryDateText.text = selectDate;
    }
    _mPickerView.hidden = YES;
}

- (IBAction)didTapToCancelDate:(id)sender {
    _mPickerView.hidden =YES;
}

//- (IBAction)mDidValueChangeInDate:(id)sender {
//    NSDate *myDate = _mDtePicker.date;
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"YYYY-MM-dd"];
//    NSString *selectDate = [dateFormat stringFromDate:myDate];
//    if (dateFlag == 1) {
//        purchaseDateText.text = selectDate;
//    }
//    else{
//        expiryDateText.text = selectDate;
//    }
//    _mDtePicker.hidden = YES;
//}

-(void)barButtonAddText:(id)sender{
    [flagTextField resignFirstResponder];
}

#pragma mark CustomTabController DELEGATE
#pragma mark -------------------------------------------

-(void)barCode:(NSString *)barcode{
    couponNoText.text = barcode;
    cardCodeText.text = barcode;
}


@end
