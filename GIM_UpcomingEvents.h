//
//  GIM_UpcomingEvents.h
//  GiveItMobile
//
//  Created by Bhaskar on 03/02/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_EventCell.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"
#import "GIM_UserModel.h"
#import "GIM_UserController.h"

@interface GIM_UpcomingEvents : UIViewController{
    NSMutableArray *totalEvent;
    NSMutableArray *showingEvent, *checkArray;
    BOOL isAppevent,isFBevent,isGmailEvent;
}
@property (weak, nonatomic) IBOutlet UITableView *mUpcomingTableView;
@property (weak, nonatomic) IBOutlet UIButton *appEventButton;
@property (weak, nonatomic) IBOutlet UIButton *fEventButton;
@property (weak, nonatomic) IBOutlet UIButton *gEventButton;
@property (weak, nonatomic) IBOutlet UIImageView *mSelectallCheckBoxImageView;
@property (weak, nonatomic) IBOutlet UIView *mDeleteView;
@property (weak, nonatomic) IBOutlet UILabel *mDisplayLabel;

- (IBAction)didTapCheckButton:(id)sender;
- (IBAction)didTapAppEvent:(id)sender;
- (IBAction)didTapFbEvent:(id)sender;
- (IBAction)didTapGmailEvent:(id)sender;
- (IBAction)didTapSelectAll:(id)sender;
- (IBAction)didTapDeleteButton:(id)sender;

@end
