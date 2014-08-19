//
//  GIM_MyGiftCardListViewController.h
//  GiveItMobile
//
//  Created by Administrator on 21/12/13.
//  Copyright (c) 2013 Isis Design Service. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIM_UserModel.h"
#import "GIM_UserController.h"
#import "GiftCardCell.h"
#import "GIM_MyGiftCardDetailsViewController.h"
#import "GIM_AppDelegate.h"
#import "CustomButtonTabController.h"

@interface GIM_MyGiftCardListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,GIM_UserServiceDelegate>
{
    NSMutableArray *itemGiftCardDetails,*otherGiftCardDetails;
    int  flagitemGiftCardDetailsCount;
}

@property (strong, nonatomic) IBOutlet UITableView *tableViewGiftCard;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;





@end
