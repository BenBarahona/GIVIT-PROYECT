//
//  GIM_AddNewContactsViewController.m
//  GiveItMobile
//
//  Created by Bhaskar on 06/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import "GIM_AddNewContactsViewController.h"

@interface GIM_AddNewContactsViewController ()

@end

@implementation GIM_AddNewContactsViewController

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
    [_mScrollview setContentSize:CGSizeMake(320, 460)];
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
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
    _mPhoneNoTextField.inputAccessoryView = toolBar;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"New Contacts Detail";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
    [tabHome setCustomNavigationViewFrame:tabHome.view.frame];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
}


#pragma mark Textfield Delegate
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_mScrollview setContentOffset:CGPointMake(0, textField.frame.origin.y-20) animated:YES];
   return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_mScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_mScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark IBAction Delegate
#pragma mark -------------------------------------------

-(void)barButtonAddText:(id)sender{
    [_mPhoneNoTextField resignFirstResponder];
}


- (IBAction)didTapToClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapToSaveContacts:(id)sender {
    NSString *validationmsg = [self validateRegistration];
    
    if ([validationmsg isEqualToString:@"1"] ){
        CFErrorRef error = NULL;
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
        
        ABRecordRef newPerson = ABPersonCreate();
        
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty,(__bridge CFTypeRef)(_mFirstNameTextField.text), &error);
        ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(_mLastNameTextField.text), &error);
        
        ABMutableMultiValueRef multiPhone =     ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(_mPhoneNoTextField.text), kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
        CFRelease(multiPhone);
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(_mEmailTextField.text), kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
        CFRelease(multiEmail);    // ...
        // Set other properties
        // ...
        ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
        
        ABAddressBookSave(iPhoneAddressBook, &error);
        CFRelease(newPerson);
        CFRelease(iPhoneAddressBook);
        if (error != NULL)
        {
            CFStringRef errorDesc = CFErrorCopyDescription(error);
            NSLog(@"Contact not saved: %@", errorDesc);
            CFRelease(errorDesc);
        }
        if (_delegate) {
            [_delegate addNewContact];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:validationmsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}



#pragma mark Validation
#pragma mark -------------------------------------------

- (BOOL) validatemailid: (NSString *) candidate {
    NSString *numericRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    NSPredicate *numericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    
    return [numericTest evaluateWithObject:candidate];
}


-(NSString *) validateRegistration{
    
    if([_mFirstNameTextField.text isEqualToString:@""] || _mFirstNameTextField.text == nil || [[_mFirstNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"First Name must not be empty";
        
    }
    
    if([_mLastNameTextField.text isEqualToString:@""] || _mLastNameTextField.text == nil || [[_mLastNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] <= 0)
    {
        return @"Last Name must not be empty";
        
    }
    
    if([_mEmailTextField.text isEqualToString:@""] || _mEmailTextField.text == nil )
    {
        return @"Email must not be empty";
        
    }
    
    if([self validatemailid:_mEmailTextField.text] !=1)
        
    {
        
        return @"email is not in correct format";
    }
    
    if([_mPhoneNoTextField.text isEqualToString:@""] || _mPhoneNoTextField.text == nil )
    {
        return @"Phone No must not be empty";
        
    }
    
    if([_mPhoneNoTextField.text length] < 10)
    {
        return @"Phone No should be of 10 character" ;
        
    }
    
    
    
    return @"1";
}


@end
