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

@interface GIM_MyMessage : UIViewController<UITableViewDelegate,GIM_MyMessageCellDeleGate>{
    NSMutableArray *totalMassege;
    CGFloat heightForCell;
    BOOL isTapToRead;
    int selectedindex;
    NSMutableArray *selectedArray;
    
}

-(void)loadMessage;
@property (weak, nonatomic) IBOutlet UILabel *demoLabel;
@property (weak, nonatomic) IBOutlet UITableView *mTableview;
@property (weak, nonatomic) IBOutlet UIImageView *mSelectAllImageView;
@property (weak, nonatomic) IBOutlet UIView *SelectView;
- (IBAction)didTapSelectAll:(id)sender;
- (IBAction)didTapDeleteButton:(id)sender;

@end
