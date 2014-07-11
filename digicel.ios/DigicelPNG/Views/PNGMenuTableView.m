//
//  PNGMenuTableView.m
//  DigicelPNG
//
//  Created by Arundev K S on 19/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGMenuTableView.h"

@implementation PNGMenuTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuItems" ofType:@"plist"];
    NSURL *dataURL = [NSURL fileURLWithPath:path];
    NSDictionary *menuData = [[NSDictionary alloc] initWithContentsOfURL:dataURL];
    mainMenuItems = [menuData valueForKey:@"OtherMenu"];
    classifieds = [menuData valueForKey:@"Classifieds"];

    UINib *cellNib = [UINib nibWithNibName:@"PNGMenuTableViewCell" bundle:[NSBundle mainBundle]];
    [menuTable registerNib:cellNib forCellReuseIdentifier:@"PNGMenuTableViewCell"];
}

- (void)drawRect:(CGRect)rect {
    [self updateViewFrames];
}

#pragma mark - Setter method

//  Setter method for menu items
- (void)setMenuItems:(NSArray *)menuItems {
    _menuItems = menuItems;
    [self refresh];
}

#pragma mark - IB Actions

//  Shows login view.
- (IBAction)showUserProfile:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoButtonPressed object:nil];
}

//    Shows bottom part of the menu view.
- (IBAction)menuIndicatorButtonAction:(id)sender {
    if(contentScrollView.contentOffset.y > 180 + userViewHeight.constant) {
        [contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [contentScrollView setContentOffset:CGPointMake(0, contentScrollView.frame.size.height) animated:YES];
    }
}

//  Main menu item selected.
- (IBAction)mainMenuSelected:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self mainMenuSelectedAtIndex:[NSIndexPath indexPathForRow:mainMenuItems.count + button.tag inSection:3]];
}

#pragma mark - Private methods

//  Set title text for cell in different sections.
- (void)setTitleForCell:(PNGMenuTableViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        if([def boolForKey:kLoginStatus]) {
            cell.menuTitleLabel.text = NSLocalizedString(@"LOGOUT", @"");
        } else {
            cell.menuTitleLabel.text = NSLocalizedString(@"LOGIN", @"");
        }
        cell.iconView.hidden = YES;
        cell.menuTitleLabel.textAlignment = NSTextAlignmentCenter;
        cell.menuItem = nil;
    } else if (indexPath.section == 1) {
        cell.menuItem = [classifieds objectAtIndex:indexPath.row];
    } else if(indexPath.section == 2) {
        if(_menuItems.count > 0) {
            cell.menuItem = [_menuItems objectAtIndex:indexPath.row];
        }
    } else {
        cell.menuItem = [mainMenuItems objectAtIndex:indexPath.row];
    }
}

//    Manage user login or logout.
- (void)performLoginAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginButtonPressed object:nil];
}

//  Main menu item selected.
- (void)mainMenuSelectedAtIndex:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMenuSelectionNotification object:indexPath];
}

//  Category item selected.
- (void)categoriesSelectedAtIndex:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:kCategorySelectionNotification object:indexPath];
}

//  Classifieds item selected.
- (void)classifiedsSelectedAtIndex:(NSIndexPath *)indexPath {
    NSDictionary *classifiedsDictionary = [classifieds objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMenuSelectionNotification object:classifiedsDictionary];
}

// Method to set up the profile image view.
- (void)setUpProfileImageView {
    self.userImagevIew.layer.cornerRadius=20;
    self.userImagevIew.layer.borderWidth=2;
    self.userImagevIew.layer.borderColor=[UIColor whiteColor].CGColor;
    self.userImagevIew.clipsToBounds=YES;
}

#pragma mark - Public methods

//  Reload table view. Hide or show user info view depending on the user login status.
- (void)refresh {
    
    // calls the method to set up the profile image view.
    [self setUpProfileImageView];
    //  Updating table and container view heights
    [self updateViewFrames];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if([def boolForKey:kLoginStatus]) {
        userViewHeight.constant = kUserInfoViewheight;
        PNGUser *user = [APP_DELEGATE loggedInUser];
        usernameLabel.text = user.displayname;
        [self.userImagevIew setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:PNGStoryboardProfilePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        }];
    } else {
        userViewHeight.constant = kZeroValue;
    }
    [menuTable reloadData];
}

//  Change table view height and container view height.
- (void)updateViewFrames {
    CGFloat tableHeight = (classifieds.count + _menuItems.count + mainMenuItems.count + 1) * 50;
    tableViewHeight.constant = tableHeight;
    CGFloat height = 2*contentScrollView.frame.size.height;
    if(height > (tableHeight + 150)) {
        containerViewHeight.constant = height;
    } else {
        containerViewHeight.constant = tableHeight + 150;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offeset = scrollView.contentOffset;
    if(offeset.y > 180 + userViewHeight.constant) {
        [indicator setImage:[UIImage imageNamed:@"menu-up-indicator"]
                   forState:UIControlStateNormal];
        [indicator setImage:[UIImage imageNamed:@"menu-up-indicator-pressed"]
                   forState:UIControlStateHighlighted];
    } else {
        [indicator setImage:[UIImage imageNamed:@"menu-indicator"]
                   forState:UIControlStateNormal];
        [indicator setImage:[UIImage imageNamed:@"menu-indicator-pressed"]
                   forState:UIControlStateHighlighted];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return classifieds.count;
            break;
        case 2:
            return _menuItems.count;
            break;
        case 3:
            return mainMenuItems.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PNGMenuTableViewCell";
    PNGMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PNGMenuTableViewCell" owner:nil options:nil] firstObject];
    }
    [self setTitleForCell:cell atIndex:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [self performLoginAction];
            break;
        case 1:
            [self classifiedsSelectedAtIndex:indexPath];
            break;
        case 2:
            [self categoriesSelectedAtIndex:indexPath];
            break;
        case 3:
            [self mainMenuSelectedAtIndex:indexPath];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
