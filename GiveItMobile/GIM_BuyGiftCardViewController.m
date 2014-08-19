//
//  GIM_BuyGiftCardViewController.m
//  GiveItMobile
//
//  Created by Administrator on 24/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_BuyGiftCardViewController.h"

@interface GIM_BuyGiftCardViewController ()

@end

@implementation GIM_BuyGiftCardViewController
@synthesize buyGiftTableView;

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
    [self setValue:[UIFont fontWithName:@"Driod Sans" size:10] forKeyPath:@"buttons.font"];
    [_mGiftAmountView setHidden:YES];
    amount = [[_mFamountButton.titleLabel.text substringFromIndex:1] integerValue];
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    userController.delegate = (id)self;
    [userController buyGiftCard:userModel];
    [_mActivityIndicator startAnimating];
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
    _didTapSelectOthers.inputAccessoryView = toolBar;
	// Do any additional setup after loading the view.
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    if ([os_version integerValue]>=7.0) {
        buyGiftTableView.sectionIndexColor = [UIColor whiteColor]; // some color
        buyGiftTableView.sectionIndexBackgroundColor = [UIColor clearColor]; // some color
        buyGiftTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor]; // some other color
    }
    NSLog(@"tableview subviews %@",    buyGiftTableView.subviews);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"Buy Gift Cards";
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setHeaderTitleLabelText:self.navigationController];
    [tabHome setHiddenOnOffExtraButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView DataSource Delegates
#pragma mark -------------------------------------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return itemGiftCardDetails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[itemGiftCardDetails objectAtIndex:section] valueForKey:@"Objects"] count];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Z",@"#", nil];
//    return arr;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i< itemGiftCardDetails.count; i++) {
        [arr addObject:[[itemGiftCardDetails objectAtIndex:i] valueForKey:@"key"]];
    }
    return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"giftCardCell";
    
    BuyGiftCardCell *cell = (BuyGiftCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[BuyGiftCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    NSLog(@"indexpath.row %d",indexPath.section);
    cell.buyGiftCardLabel.text = [[[[itemGiftCardDetails objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"name"];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[[[itemGiftCardDetails objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"coupon_thumb_background_image"] ]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
    cell.buyGiftCellImageView.image = nil;
    NSArray *f = [[[[[itemGiftCardDetails objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"coupon_thumb_background_image"] componentsSeparatedByString:@"/"];
    NSString *fileName = [f objectAtIndex:f.count-1];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    
    if ([img isKindOfClass:[UIImage class]]) {
        cell.buyGiftCellImageView.image = img;
        [cell.mActivityIndicator stopAnimating];
    }
    else {
        if ([[[[[itemGiftCardDetails objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] valueForKey:@"coupon_thumb_background_image"] length]<=6) {
            cell.buyGiftCellImageView.image = [UIImage imageNamed:@"no_image.jpg"];
            [cell.mActivityIndicator stopAnimating];
        }
        else{
            [cell.mActivityIndicator startAnimating];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                
                NSString *fileName = [f objectAtIndex:f.count-1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    
                    cell.buyGiftCellImageView.image = [UIImage imageWithData:imageData];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                    [imageData writeToFile:savedImagePath atomically:NO];
                    
                    [cell.mActivityIndicator stopAnimating];
                    
                });
            });
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    payMentDict = [NSMutableDictionary dictionaryWithDictionary:[[[itemGiftCardDetails objectAtIndex:indexPath.section] valueForKey:@"Objects"] objectAtIndex:indexPath.row] ];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.view.frame];
    [_mGiftAmountView setHidden:NO];
        amount = [[_mFamountButton.titleLabel.text substringFromIndex:1] integerValue];
    _didTapSelectOthers.text = nil;
    [_m10ImageView setImage:[UIImage imageNamed:@"pointer_selected.png"]];
    [_m20ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
    [_m30ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
    [UIView commitAnimations];
}

#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------


-(void)didBuyGiftCard:(NSArray *)returnData isSuccess:(BOOL)isSuccess{
    if (isSuccess == YES) {
        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                        ascending:YES selector:@selector(localizedStandardCompare:)] ;
        NSArray *sa = [[returnData valueForKey:@"item"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        itemGiftCardDetails = [NSMutableArray arrayWithArray:sa];
        [_mActivityIndicator stopAnimating];
        [self sectionArray];
        NSMutableArray *amountArr = [returnData valueForKey:@"amount"];
        switch (amountArr.count) {
            case 0:
            {
            }
                break;
            case 1:
            {
                [_mFamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:0] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [_mFamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:0] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
                [_mSamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:1] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [_mFamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:0] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
                [_mSamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:1] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
                [_mTamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:2] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
            }
                break;
                
            default:
            {
                [_mFamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:0] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
                [_mSamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:1] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
                [_mTamountButton setTitle:[NSString stringWithFormat:@"$%d",[[[amountArr objectAtIndex:2] valueForKey:@"price"] integerValue]] forState:UIControlStateNormal];
            }
                break;
        }
        amount = [[_mFamountButton.titleLabel.text substringFromIndex:1] integerValue];
        [buyGiftTableView reloadData];
    }
}

-(void)didError:(NSString *)msg{
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark Perform Segue
#pragma mark -------------------------------------------

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"buyGiftToSendGiftCard"]){
        GIM_GiveGiftCard_SelectContactViewController *give = [segue destinationViewController];
        give.paymentDict = payMentDict;
        give.isHideContinue = NO;
    }
}


#pragma mark IBAction Methods
#pragma mark -------------------------------------------

- (IBAction)didTapSelect10:(id)sender {
    if (amount != [[[_mFamountButton.titleLabel.text substringFromIndex:1] substringFromIndex:1] integerValue]) {
        amount = [[_mFamountButton.titleLabel.text substringFromIndex:1] integerValue];
        _didTapSelectOthers.text = nil;
        [_m10ImageView setImage:[UIImage imageNamed:@"pointer_selected.png"]];
        [_m20ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
        [_m30ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
    }
}

- (IBAction)didTapSelect20:(id)sender {
    if (amount != [[_mSamountButton.titleLabel.text substringFromIndex:1] integerValue]) {
        amount = [[_mSamountButton.titleLabel.text substringFromIndex:1] integerValue];
        _didTapSelectOthers.text = nil;
        [_m10ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
        [_m20ImageView setImage:[UIImage imageNamed:@"pointer_selected.png"]];
        [_m30ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
    }
}

- (IBAction)didTapSelect30:(id)sender {
    if (amount != [[_mTamountButton.titleLabel.text substringFromIndex:1] integerValue]) {
        amount = [[_mTamountButton.titleLabel.text substringFromIndex:1] integerValue];
        _didTapSelectOthers.text = nil;
        [_m10ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
        [_m20ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
        [_m30ImageView setImage:[UIImage imageNamed:@"pointer_selected.png"]];
    }
}

- (IBAction)didTapContinue:(id)sender {
    [_didTapSelectOthers resignFirstResponder];
    if (amount>0) {
        GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
        CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
        [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
        [_mGiftAmountView setHidden:YES];
        [UIView commitAnimations];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",amount] forKey:@"Amount"];
        [self performSegueWithIdentifier:@"buyGiftToSendGiftCard" sender:self];
    }
}

- (IBAction)didTapBackButton:(id)sender {
    [_didTapSelectOthers resignFirstResponder];
    GIM_AppDelegate *appD = (GIM_AppDelegate*)[[UIApplication sharedApplication] delegate];
    CustomButtonTabController *tabHome = (CustomButtonTabController *)[[(UINavigationController *)[appD.window rootViewController] viewControllers] objectAtIndex:[[(UINavigationController *)[appD.window rootViewController] viewControllers] count]-1];
    [tabHome setCustomNavigationViewFrame:tabHome.navigationViewFrame];
    [_mGiftAmountView setHidden:YES];
    [UIView commitAnimations];
}

#pragma mark TextField Delegate
#pragma mark -------------------------------------------

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    flagAmount = amount;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    amount = [textField.text integerValue];
    if (amount == 0) {
        amount = flagAmount;
    }
//    [_m10ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
//    [_m20ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
//    [_m30ImageView setImage:[UIImage imageNamed:@"pointer_deselected.png"]];
    return YES;
}

-(void)barButtonAddText:(id)sender{
    [_didTapSelectOthers resignFirstResponder];
}
#pragma mark Method to divide an array with section
#pragma mark -------------------------------------------


-(void)sectionArray{
    NSMutableArray *totalName = [[NSMutableArray alloc] init];
    for (int i=0; i<itemGiftCardDetails.count; i++) {
        [totalName addObject:[[itemGiftCardDetails objectAtIndex:i] valueForKey:@"name"]];
    }
    NSMutableArray *demoArray = [[NSMutableArray alloc] init];
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
            char ch = [[[itemGiftCardDetails objectAtIndex:j] valueForKey:@"name"] characterAtIndex:0];
            NSString *fc =[[demoArray objectAtIndex:i] valueForKey:@"key"];
            if ((ch != [[fc lowercaseString] characterAtIndex:0])&&(ch != [[fc uppercaseString] characterAtIndex:0])) {
                [itemGiftCardDetails addObject:[[itemGiftCardDetails objectAtIndex:j] copy]];
                [itemGiftCardDetails removeObjectAtIndex:j];
            }
            [totalName addObject:[[itemGiftCardDetails objectAtIndex:j] copy]];
            [total addObject:@"no"];
        }
        for (NSMutableDictionary *dict in totalName) {
            [itemGiftCardDetails removeObject:dict];
        }
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setObject:[totalName copy] forKey:@"Objects"];
        [dict setObject:[[demoArray objectAtIndex:i] valueForKey:@"key"] forKey:@"key"];
        [finalArray addObject:[dict copy]];
        [dict removeAllObjects];
        [total removeAllObjects];
        [totalName removeAllObjects];
        
    }
    if (itemGiftCardDetails.count>0) {
        for (int j = 0; j<itemGiftCardDetails.count; j++) {
            [totalName addObject:[[itemGiftCardDetails objectAtIndex:j] copy]];
            [total addObject:@"no"];
        }
        for (NSMutableDictionary *dict in totalName) {
            [itemGiftCardDetails removeObject:dict];
        }
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setObject:[totalName copy] forKey:@"Objects"];
        [dict setObject:@"#" forKey:@"key"];
        [finalArray addObject:[dict copy]];
        [dict removeAllObjects];
        [total removeAllObjects];
        [totalName removeAllObjects];
    }
    itemGiftCardDetails = finalArray;
}


@end
