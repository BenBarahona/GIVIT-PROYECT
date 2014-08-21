//
//  GIM_GiveGiftCard_SelectContactViewController.m
//  GiveItMobile
//
//  Created by Bhaskar on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_GiveGiftCard_SelectContactViewController.h"

@interface GIM_GiveGiftCard_SelectContactViewController ()

@end

@implementation GIM_GiveGiftCard_SelectContactViewController


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
    [self setValue:[UIFont fontWithName:@"Droid Sans" size:16] forKeyPath:@"buttons.font"];
    [_mContactsButton setImage:[UIImage imageNamed:@"btn_user_02.png"] forState:UIControlStateNormal];
    [_mActivityIndicator stopAnimating];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LocalContacts"] != nil) {
        contactDetail = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"LocalContacts"]];
        totalContact = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"LocalContacts"]];
    }
    [self sectionArray];
    [_sendGiftTableView reloadData];
    isChange = NO;
    [[NSNotificationCenter defaultCenter] addObserver:(id)self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    if (totalContact.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Contact information" message:[NSString stringWithFormat:@"You have total %d contacts. Do you want to sync?",totalContact.count] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
    }
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    if ([os_version integerValue]>=7.0) {
        _sendGiftTableView.sectionIndexColor = [UIColor whiteColor]; // some color
        _sendGiftTableView.sectionIndexBackgroundColor = [UIColor clearColor]; // some color
        _sendGiftTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor]; // some other color
    }
    if (_isHideContinue == YES) {
        CGRect rect =  _sendGiftTableView.frame;
        rect.size.height += 40;
        [_sendGiftTableView setFrame:rect];
    }
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"";
    self.navigationController.title = @"Buy Gift Cards";
    if (_isHideContinue == YES) {
        self.navigationController.title = @"All Contacts";
   }
    //GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    //CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    
    //[tabHome setHeaderTitleLabelText:self.navigationController];
    //[tabHome setHiddenOnOffExtraButton:_isHideContinue];
    _mContinueButton.hidden = _isHideContinue;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView DataSource Delegates
#pragma mark -------------------------------------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return contactDetail.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UIView *BgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width-14, 18)];
    /* Create custom view to display section header... */
    [BgV setBackgroundColor:[UIColor colorWithRed:64/255.0 green:169/255.0 blue:219/255.0 alpha:1.0]]; //your background color...
    [view addSubview:BgV];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width-20, 14)];
    /* Section header is in 0th index... */
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:[[contactDetail objectAtIndex:section] valueForKey:@"key"]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[[contactDetail objectAtIndex:section]valueForKey:@"Objects"] count] == 0) {
        return 0;
    }
    return 20;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([[[contactDetail objectAtIndex:section]valueForKey:@"Objects"] count] == 0) {
//        return Nil;
//    }
//    return [[contactDetail objectAtIndex:section] valueForKey:@"key"];
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i< contactDetail.count; i++) {
        [arr addObject:[[contactDetail objectAtIndex:i] valueForKey:@"key"]];
    }
    return arr;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[contactDetail objectAtIndex:section] valueForKey:@"Objects"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"giftCardCell";
    
    GIM_SendContact *cell = (GIM_SendContact *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[GIM_SendContact alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.sendGiftCardLabel.text = [[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.sendGiftCellImageView.image = nil;
    NSURL *url;
    NSString *fileName;
    if ([[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"picture"] length]>0){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"picture"]]];
        
        fileName = [NSString stringWithFormat:@"%@.png",[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"username"]];
    }
    else if ([[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"id"] length]>0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"id"]]];
        
        fileName = [NSString stringWithFormat:@"fb%@.png",[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"id"]];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    if ([img isKindOfClass:[UIImage class]]) {
        cell.sendGiftCellImageView.image = img;
        [cell.mActivityIndicator stopAnimating];
    }
    else {
        NSLog(@"%@",[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"id"]);
        int count;
        if ([[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"picture"] length]>0){
            count = [[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"picture"] length];
        }
        else{
            count = [[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"id"] length];
        }
        if (count<=6) {
            cell.sendGiftCellImageView.image = [UIImage imageNamed:@"no_photo.jpg"];
            [cell.mActivityIndicator stopAnimating];
        }
        else{
            [cell.mActivityIndicator startAnimating];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                if ([[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] count] > indexPath.row) {
                    NSLog(@"in loop");
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    NSString *fileName;
                    if ([[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] count] > indexPath.row &&[[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"picture"] length]>0){
                        fileName = [NSString stringWithFormat:@"%@.png",[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"username"]];
                    }
                    else if ([[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] count] > indexPath.row && [[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"id"] length]>0) {
                        fileName = [NSString stringWithFormat:@"fb%@.png",[[[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"id"]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        if (fileName == nil || fileName == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",fileName] length] == 0 || [[[NSString stringWithFormat:@"%@",fileName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
                            
                        }
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                        [imageData writeToFile:savedImagePath atomically:NO];
                        cell.sendGiftCellImageView.image = [UIImage imageWithData:imageData];
                        [cell.mActivityIndicator stopAnimating];
                        
                    });

                }
            });
        }
    }
    if (_isHideContinue != YES) {
        if ([[[selectArray objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row] isEqualToString:@"no"]) {
            cell.sendCheckBoxImageView.image = [UIImage imageNamed:@"chk_box_01.png"];
        }
        else{
            cell.sendCheckBoxImageView.image = [UIImage imageNamed:@"chk_box_02.png"];
        }
    }
    else{
        cell.sendCheckBoxImageView.image = nil;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = [[[contactDetail objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row];
    NSLog(@"SELECTED: %@", info);
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.messageComposeDelegate = self;
            controller.body = @"";
        
        [self presentViewController:controller animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
	}
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GivIt" message:@"This device cannot send SMS messages" delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles: nil];
        [alert show];
    }
    /*
    if ([[[selectArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"no"]) {
        NSMutableArray *arr =[NSMutableArray arrayWithArray:[selectArray objectAtIndex:indexPath.section]];
        [arr replaceObjectAtIndex:indexPath.row withObject:@"yes"];
        [selectArray replaceObjectAtIndex:indexPath.section withObject:arr];
    }
    else{
        NSMutableArray *arr =[NSMutableArray arrayWithArray:[selectArray objectAtIndex:indexPath.section]];
        [arr replaceObjectAtIndex:indexPath.row withObject:@"no"];
        [selectArray replaceObjectAtIndex:indexPath.section withObject:arr];
    }
    [_sendGiftTableView reloadData];
    isChange = NO;
     */
    
}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------




-(void)gotoAddNewEvent{
}

#pragma mark IBAction Methods
#pragma mark -------------------------------------------

- (IBAction)didTapToContinue:(id)sender {
    NSString *email = @"a@a.m";
    for (int i=0; i<selectArray.count; i++) {
        for (int j=0; j<[[selectArray objectAtIndex:i] count]; j++) {
            if ([[[selectArray objectAtIndex:i] objectAtIndex:j]isEqualToString:@"yes"]) {
                email = [NSString stringWithFormat:@"%@,%@",email,[[[[contactDetail objectAtIndex:i] valueForKey:@"Objects"] objectAtIndex:j]valueForKey:@"username"]];
            }
        }
    }
    if (email.length>5) {
        email = [email substringFromIndex:6];
    }
    else{
        email =@"";
    }
    if (email.length >0) {
        [_paymentDict setValue:email forKey:@"email"];
        [self performSegueWithIdentifier:@"didUploadBuyGift" sender:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please select at least one contact to send gift card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag = 10;
        [alert show];
    }
}


- (IBAction)didTapToSocialSync:(id)sender {
    isChange = YES;
    [_mContactsButton setImage:[UIImage imageNamed:@"btn_user_01.png"] forState:UIControlStateNormal];
    [_mFaceBookButton setImage:[UIImage imageNamed:@"btn_fb_01.png"] forState:UIControlStateNormal];
    [_mGmailButton setImage:[UIImage imageNamed:@"btn_mail_01.png"] forState:UIControlStateNormal];
    [_mLinkedInButton setImage:[UIImage imageNamed:@"btn_in_01.png"] forState:UIControlStateNormal];
    [_mYahooButton setImage:[UIImage imageNamed:@"btn_yahoo_0001.png"] forState:UIControlStateNormal];
    switch ([(UIButton *)sender tag]) {
        case 1:{
            [_mContactsButton setImage:[UIImage imageNamed:@"btn_user_02.png"] forState:UIControlStateNormal];
            contactType = @"LocalContacts";
        }
            break;
        case 2:{
            contactType = @"FBContacts";
            [_mFaceBookButton setImage:[UIImage imageNamed:@"btn_fb_02.png"] forState:UIControlStateNormal];
        }
            break;
        case 3:{
            contactType = @"LinkedInContacts";
            [_mLinkedInButton setImage:[UIImage imageNamed:@"btn_in_02.png"] forState:UIControlStateNormal];
        }
            break;
        case 4:{
            contactType = @"GmailContacts";
            [_mGmailButton setImage:[UIImage imageNamed:@"btn_mail_02.png"] forState:UIControlStateNormal];
        }
            break;
        case 5:{
            contactType = @"YahooContacts";
            [_mYahooButton setImage:[UIImage imageNamed:@"btn_yahoo_0002.png"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:contactType] != nil) {
        contactDetail = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:contactType]];
        totalContact = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:contactType]];
        [self sectionArray];
        [_sendGiftTableView reloadData];
        isChange = NO;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Contact information" message:[NSString stringWithFormat:@"You have total 0 contacts. Do you want to sync?"] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
    }

}

- (IBAction)didTapToAddNewContact:(id)sender {
    [self performSegueWithIdentifier:@"AddNewContact" sender:self];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag != 10) {
        [self performSegueWithIdentifier:@"SocialLogin" sender:self];
    }
    if (contactType == nil || contactType == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",contactType] length] == 0 || [[[NSString stringWithFormat:@"%@",contactType] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
    }
    else{
        if ([[NSUserDefaults standardUserDefaults] valueForKey:contactType] != nil) {
            contactDetail = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:contactType]];
            totalContact = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:contactType]];
        }
        else{
            contactDetail = nil;
        }
        [self sectionArray];
    }
    [_sendGiftTableView reloadData];
    isChange = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"SocialLogin"]){
        GIM_SocialSynViewController *social = [segue destinationViewController];
        social.delegate = (id)self;
    }
    else if ([[segue identifier] isEqualToString:@"didUploadBuyGift"]){
        GIM_BuyGiftCardUploadViewController *upload = [segue destinationViewController];
        upload.paymentDict = _paymentDict;
    }
    else if ([[segue identifier] isEqualToString:@"AddNewContact"]){
        GIM_AddNewContactsViewController *newContact = [segue destinationViewController];
        newContact.delegate = (id)self;
    }
}

#pragma mark SocialSync Delegate Methods
#pragma mark -------------------------------------------


-(void)didFinishSync:(NSString *)ContactType{
    if (ContactType != nil) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:ContactType] != nil) {
            totalContact = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:ContactType]];
            contactDetail = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:ContactType]];
            [self sectionArray];
        }
        [_mContactsButton setImage:[UIImage imageNamed:@"btn_user_01.png"] forState:UIControlStateNormal];
        [_mFaceBookButton setImage:[UIImage imageNamed:@"btn_fb_01.png"] forState:UIControlStateNormal];
        [_mGmailButton setImage:[UIImage imageNamed:@"btn_mail_01.png"] forState:UIControlStateNormal];
        [_mLinkedInButton setImage:[UIImage imageNamed:@"btn_in_01.png"] forState:UIControlStateNormal];
        [_mYahooButton setImage:[UIImage imageNamed:@"btn_yahoo_0001.png"] forState:UIControlStateNormal];
    }
    if ([ContactType isEqualToString:@"LocalContacts"]) {
        [_mContactsButton setImage:[UIImage imageNamed:@"btn_user_02.png"] forState:UIControlStateNormal];
    }
    else if ([ContactType isEqualToString:@"FBContacts"]){
        [_mFaceBookButton setImage:[UIImage imageNamed:@"btn_fb_02.png"] forState:UIControlStateNormal];
    }
    else if ([ContactType isEqualToString:@"GmailContacts"]){
        [_mGmailButton setImage:[UIImage imageNamed:@"btn_mail_02.png"] forState:UIControlStateNormal];
    }
    else if ([ContactType isEqualToString:@"YahooContacts"]){
        [_mYahooButton setImage:[UIImage imageNamed:@"btn_yahoo_0002.png"] forState:UIControlStateNormal];
    }
    else if ([ContactType isEqualToString:@"LinkedInContacts"]){
        [_mYahooButton setImage:[UIImage imageNamed:@"btn_in_02.png"] forState:UIControlStateNormal];
    }
    [_sendGiftTableView reloadData];
    isChange = NO;
}

#pragma mark NewcontactAdd Delegate
#pragma mark -------------------------------------------

-(void)addNewContact{
    CFErrorRef *error = NULL;
    
    NSMutableArray *arrayofContacts =[[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,error);
    
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef sortedPeople =ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
    
    //RETRIEVING THE FIRST NAME AND PHONE NUMBER FROM THE ADDRESS BOOK
    
    CFIndex number = CFArrayGetCount(sortedPeople);
    
    NSString *firstName;
    NSString *lastName;
    NSString *email ;
    
    for( int i=0;i<number;i++)
    {
        
        ABRecordRef person = CFArrayGetValueAtIndex(sortedPeople, i);
        firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        ABRecordRef personL = CFArrayGetValueAtIndex(sortedPeople, i);
        lastName = (__bridge NSString *)ABRecordCopyValue(personL, kABPersonLastNameProperty);
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        email = (__bridge NSString *) ABMultiValueCopyValueAtIndex(emails, 0);
        
        if(email != NULL)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSString stringWithFormat:@"%@ %@",firstName,lastName] forKey:@"name"];
            [dict setValue:email forKey:@"username"];
            
            [arrayofContacts addObject:dict];
        }
    }
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                    ascending:YES selector:@selector(localizedStandardCompare:)] ;
    NSArray *sa = [arrayofContacts sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [[NSUserDefaults standardUserDefaults] setValue:sa forKey:@"LocalContacts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LocalContacts"] != nil) {
        contactDetail = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"LocalContacts"]];
        totalContact = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"LocalContacts"]];
    }
    [self sectionArray];
    
    [_sendGiftTableView reloadData];
    isChange = NO;
}

#pragma mark Textfield Delegate
#pragma mark -------------------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textChanged:(id)sender{
    isChange = YES;

    UITextField *textField = [(NSNotification *)sender object];
    [contactDetail removeAllObjects];
    contactDetail = nil;
    contactDetail = [[NSMutableArray alloc] init];
    if ([textField.text length]>0) {
        for (int i = 0 ; i<totalContact.count; i++) {
            if([[[[totalContact objectAtIndex:i] valueForKey:@"name"] lowercaseString] hasPrefix:[textField.text lowercaseString]] ){
                [contactDetail addObject:[totalContact objectAtIndex:i]];
            }
        }
    }else{
        contactDetail = [NSMutableArray arrayWithArray:(NSArray *)totalContact];
    }
    [self sectionArray];
    [_sendGiftTableView reloadData];
    isChange = NO;
}

#pragma mark Method to divide an array with section
#pragma mark -------------------------------------------


-(void)sectionArray{
    if (!selectArray) {
        selectArray = [[NSMutableArray alloc] init];
    }
    else{
        [selectArray removeAllObjects];
    }
    NSMutableArray *totalName = [[NSMutableArray alloc] init];
    for (int i=0; i<contactDetail.count; i++) {
        [totalName addObject:[[contactDetail objectAtIndex:i] valueForKey:@"name"]];
    }
    demoArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *sectionDict = [NSMutableDictionary dictionary];
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
    {
        //NSPredicates are fast
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSArray *content = [totalName filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", firstCharacter]];
        NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];
            NSString *key = [firstCharacter uppercaseString];
            [sectionDict setValue:[NSString stringWithFormat:@"%d",[mutableContent count]] forKey:key];
            [sectionDict setValue:key forKey:@"key"];
            [demoArray addObject:[sectionDict copy]];
        [sectionDict removeAllObjects];
    }
    [totalName removeAllObjects];
    NSMutableArray *total = [[NSMutableArray alloc] init];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    for (int i =0 ; i<demoArray.count; i++) {
        for (int j = 0; j<[[[demoArray objectAtIndex:i ] valueForKey:[[demoArray objectAtIndex:i] valueForKey:@"key"]]integerValue]; j++) {
            char ch = [[[contactDetail objectAtIndex:j] valueForKey:@"name"] characterAtIndex:0];
            NSString *fc =[[demoArray objectAtIndex:i] valueForKey:@"key"];
            if ((ch != [[fc lowercaseString] characterAtIndex:0])&&(ch != [[fc uppercaseString] characterAtIndex:0])) {
                [contactDetail addObject:[[contactDetail objectAtIndex:j] copy]];
                [contactDetail removeObjectAtIndex:j];
            }
            [totalName addObject:[[contactDetail objectAtIndex:j] copy]];
            [total addObject:@"no"];
        }
        for (NSMutableDictionary *dict in totalName) {
            [contactDetail removeObject:dict];
        }
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setObject:[totalName copy] forKey:@"Objects"];
        [dict setObject:[[demoArray objectAtIndex:i] valueForKey:@"key"] forKey:@"key"];
        [finalArray addObject:[dict copy]];
        [selectArray addObject:[total copy]];
        [dict removeAllObjects];
        [total removeAllObjects];
        [totalName removeAllObjects];
        
    }
//    if (contactDetail.count>0) {
        for (int j = 0; j<contactDetail.count; j++) {
            [totalName addObject:[[contactDetail objectAtIndex:j] copy]];
            [total addObject:@"no"];
        }
        for (NSMutableDictionary *dict in totalName) {
            [contactDetail removeObject:dict];
        }
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setObject:[totalName copy] forKey:@"Objects"];
        [dict setObject:@"#" forKey:@"key"];
        [finalArray addObject:[dict copy]];
        [selectArray addObject:[total copy]];
        [dict removeAllObjects];
        [total removeAllObjects];
        [totalName removeAllObjects];
//    }
    contactDetail = finalArray;
}
@end
