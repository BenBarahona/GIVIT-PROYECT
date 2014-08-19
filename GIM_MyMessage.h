//
//  GIM_MyMessage.h
//  GiveItMobile
//
//  Created by Bhaskar on 09/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_MyMessageCell.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"

@interface GIM_MyMessage : UIViewController{
    NSMutableArray *totalMassege;
}
@property (weak, nonatomic) IBOutlet UILabel *demoLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableview;

@end
