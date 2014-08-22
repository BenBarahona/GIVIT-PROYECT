//
//  GIM_MyMessageCell.h
//  GiveItMobile
//
//  Created by Bhaskar on 09/01/14.
//  Copyright (c) 2014 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GIM_MyMessageCellDeleGate <NSObject>

@required

-(void)checkButtonClickedwithTag:(int)tag;
-(void)gotoButtonClickedwithTag:(int)tag;
@optional



@end

@interface GIM_MyMessageCell : UITableViewCell
@property (nonatomic,strong) id <GIM_MyMessageCellDeleGate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *mMymessageLabel;
@property (weak, nonatomic) IBOutlet UIView *mBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *mCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *mGotoButton;
- (IBAction)didTapCheckButton:(id)sender;
- (IBAction)didTapGotoButton:(id)sender;

@end
