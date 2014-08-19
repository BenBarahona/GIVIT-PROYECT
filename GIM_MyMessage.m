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
    totalMassege = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"myMessage"]];
    if (totalMassege.count == 0) {
        _demoLabel.hidden = NO;
    }
    else{
        _demoLabel.hidden = YES;
    }
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
}


#pragma mark TableView DataSource Delegate
#pragma mark -------------------------------------------

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
    cell.mYMessageCellTextView.text = [totalMassege objectAtIndex:indexPath.row];
    return cell;
}

@end
