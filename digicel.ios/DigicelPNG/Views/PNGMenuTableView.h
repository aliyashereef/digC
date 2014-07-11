//
//  PNGMenuTableView.h
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGMenuTableViewCell.h"
#import "PNGUser.h"
#import "UIImageView+WebCache.h"

/*
 UIView used as side menu in home screen. Contains a table view and user info view. User info view 
 is shown only if the user is logged in, else user info view is set to 0. Table view contains 
 3 sections. First section contains only 1 cell, shows sign in / sign out text. Second section 
 lists all the available categories from the parse. 3rd section contains some hard coded cells 
 like feedback,review etc.. On selecting the menu item a notification is posting. Observers must be 
 added in home view to get the click events. If the categories list is not avaialable, then there 
 will be only 2 sections.
 */

@interface PNGMenuTableView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    
    IBOutlet UITableView *menuTable;
    IBOutlet UIScrollView *contentScrollView;
    IBOutlet NSLayoutConstraint *userViewHeight;
    IBOutlet NSLayoutConstraint *tableViewHeight;
    IBOutlet NSLayoutConstraint *containerViewHeight;
    IBOutlet UILabel *usernameLabel;
    IBOutlet UIButton *indicator;
    NSArray *mainMenuItems;
    NSArray *classifieds;
}

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, weak) IBOutlet UIImageView *userImagevIew;

//  Reload table view. Hide or show user info view depending on the user login status.
- (void)refresh;

@end
