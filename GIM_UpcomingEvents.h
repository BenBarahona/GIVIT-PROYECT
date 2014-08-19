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
}
@property (weak, nonatomic) IBOutlet UITableView *mUpcomingTableView;

@end
