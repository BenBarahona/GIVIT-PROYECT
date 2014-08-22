//
//  GIM_MyGiftCardListViewController.m
//  GiveItMobile
//
//  Created by Administrator on 21/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import "GIM_MyGiftCardListViewController.h"

@interface GIM_MyGiftCardListViewController ()

@end

@implementation GIM_MyGiftCardListViewController
@synthesize tableViewGiftCard;
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
    [self customNavigationButton];
    tableViewGiftCard.backgroundColor=[UIColor clearColor];
    [self loadGiftCard];
	// Do any additional setup after loading the view.
}

-(void)loadGiftCard{
    GIM_UserModel *userModel = [[GIM_UserModel alloc]init];
    
    userModel.userid = @"97";
    
    GIM_UserController *userController = [[GIM_UserController alloc]init];
    
    userController.delegate = (id)self;
    
    [userController myGiftCard:userModel];
    [_mActivityIndicator startAnimating];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.title = @"My Gift Cards";
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

#pragma mark UITableView Methods
#pragma mark -------------------------------------------



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return itemGiftCardDetails.count;
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"giftCardCell";
    GiftCardCell *cell = (GiftCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[GiftCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
     }
    
    [cell.mCardAmountLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [cell.mGiftCardBalanceLabel setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [cell.mCardValue setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [cell.mBalance setFont:[UIFont fontWithName:@"DroidSans-Bold" size:15]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row<flagitemGiftCardDetailsCount) {
        if ([[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"name"] != [NSNull null])
            cell.mGiftCellGiftedByLabel.text = [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"name"];
        else
            cell.mGiftCellGiftedByLabel.text = @"";
        cell.retailerNameLabel.text = [NSString stringWithFormat:@"%@",[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_name"]];
        cell.mGiftCardBalanceLabel.text = [NSString stringWithFormat:@"$%0.2f",[[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"remaining_amount"] floatValue]];
        cell.mCardAmountLabel.text = [NSString stringWithFormat:@"$%0.2f",[[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"orginal_amount"] floatValue]];
    }
    else{
        if ([[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retailer_name"] != [NSNull null])
            cell.mGiftCellGiftedByLabel.text = [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retailer_name"];//[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_name"];
        else
            cell.mGiftCellGiftedByLabel.text = @"";
        cell.mCardAmountLabel.text = [NSString stringWithFormat:@"$%0.2f",[[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"amount"] floatValue]];
        cell.mGiftCardBalanceLabel.text = @"$0.00";
    }
    if ( [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_full_image"] == nil ||  [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_full_image"] == (id)[NSNull null] || [[NSString stringWithFormat:@"%@", [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_full_image"]] length] == 0 || [[[NSString stringWithFormat:@"%@", [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_full_image"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        cell.mGiftCellImageView.image = [UIImage imageNamed:@"no_image.jpg"];
        [cell.mActivityIndicator stopAnimating];
    }
    else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_full_image"] ]];
        
        cell.mGiftCellImageView.image = nil;
        NSArray *f = [[NSString stringWithFormat:@"%@",[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_full_image"]] componentsSeparatedByString:@"/"];
        NSString *fileName = [f objectAtIndex:f.count-1];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
        if ([img isKindOfClass:[UIImage class]]) {
            cell.mGiftCellImageView.image = img;
            [cell.mActivityIndicator stopAnimating];
        }
        else {
            if ([[NSString stringWithFormat:@"%@",[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"retaler_full_image"]] length]<=6) {
                cell.mGiftCellImageView.image = [UIImage imageNamed:@"no_image.jpg"];
                [cell.mActivityIndicator stopAnimating];
            }
            else{
                [cell.mActivityIndicator startAnimating];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    
                    NSString *fileName = [f objectAtIndex:f.count-1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        
                        cell.mGiftCellImageView.image = [UIImage imageWithData:imageData];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                        [imageData writeToFile:savedImagePath atomically:NO];
                        
                        [cell.mActivityIndicator stopAnimating];
                        
                        
                    });
                });
            }
        }
    }
    NSLog(@"hello%@",[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"]);
    if ([[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"] == nil || [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"] == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"]] length] == 0 || [[[NSString stringWithFormat:@"%@",[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        cell.mGiftCellUserImageView.image = [UIImage imageNamed:@"no_photo.jpg"];
    }
    else{
        NSURL *urlThumb = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"] ]];
        NSArray *f = [[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"] componentsSeparatedByString:@"/"];
        NSString *fileName = [f objectAtIndex:f.count-1];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
        
        if ([img isKindOfClass:[UIImage class]]) {
            cell.mGiftCellUserImageView.image = img;
        }
        else {
            if ([[[itemGiftCardDetails objectAtIndex:indexPath.row] valueForKey:@"gift_user_full_image"] length]<=6) {
                cell.mGiftCellUserImageView.image = [UIImage imageNamed:@"no_photo.jpg"];
            }
            else{
                NSData *imageData = [NSData dataWithContentsOfURL:urlThumb];
                
                NSString *fileName = [f objectAtIndex:f.count-1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    
                    cell.mGiftCellUserImageView.image = [UIImage imageWithData:imageData];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                    [imageData writeToFile:savedImagePath atomically:NO];
                    [cell.mActivityIndicator stopAnimating];
                });
            }
        }
    }
    return cell;
     
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"didMyGiftDetails" sender:self];

  
}


#pragma mark GIM_UserServiceDelegate
#pragma mark -------------------------------------------


-(void)didError:(NSString *)msg{
    [_mActivityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



-(void)didMyGiftCard:(NSDictionary *)returnDict isSuccess:(BOOL)isSuccess{
    [_mActivityIndicator stopAnimating];
    if (isSuccess == YES) {
//        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
//                                                                        ascending:YES selector:@selector(localizedStandardCompare:)] ;
//        NSArray *sa = [[returnDict valueForKey:@"item"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//        NSArray *sa1 = [[returnDict valueForKey:@"others"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//        
        itemGiftCardDetails = [NSMutableArray arrayWithArray:[returnDict valueForKey:@"item"]];
        flagitemGiftCardDetailsCount = itemGiftCardDetails.count;
        [itemGiftCardDetails addObjectsFromArray: [returnDict valueForKey:@"others"]];
        otherGiftCardDetails = [NSMutableArray arrayWithArray:[returnDict valueForKey:@"others"]];
        [tableViewGiftCard reloadData];
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"didMyGiftDetails"]){
        
        NSIndexPath *path = [tableViewGiftCard indexPathForSelectedRow];
        
        GIM_MyGiftCardDetailsViewController *det = [segue destinationViewController];
        det.idd = [itemGiftCardDetails objectAtIndex:path.row];
        //det.detailArray=[[NSMutableArray alloc] init];
        det.detailDict=[itemGiftCardDetails objectAtIndex:path.row];
        
    }
}


#pragma mark Custom Navigation Bar
#pragma mark -------------------------------------------
-(void)customNavigationButton{
    //self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"btn_next_arrow_01.png"] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"btn_next_arrow_02.png"] forState:UIControlStateHighlighted];
    button.adjustsImageWhenDisabled = NO;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"btn_home_01.png"] forState:UIControlStateNormal];
    //[button1 setImage:[UIImage imageNamed:@"btn_home_02.png"] forState:UIControlStateHighlighted];
    button1.adjustsImageWhenDisabled = NO;
    
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, 30, 30);
    button1.frame = CGRectMake(0, 0, 30, 30);
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(gotoHome) forControlEvents:UIControlEventTouchUpInside];
    
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = customBarItem1;
    [self.tabBarController.tabBar setHidden:YES];
}

-(void)back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

-(void)gotoHome{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}



@end
