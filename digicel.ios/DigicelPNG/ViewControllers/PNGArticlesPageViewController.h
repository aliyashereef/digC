//
//  PNGArticlesPageViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGMenuTableView.h"
#import <Parse/Parse.h>
#import "PNGArticlesViewController.h"
#import "PNGUser.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PNGSendStoryViewController.h"
#import "PNGLatoTextField.h"
#import "PNGArticlesTableViewController.h"
#import "GAITrackedViewController.h"
#import "PNGClassifieds.h"

/*
 Home view of the application. Page view controller which listing articles of different categories.
 Initially fecthing all the available categories and populates the side menu. then loading all the 
 articles of the first category.
 */

@interface PNGArticlesPageViewController : GAITrackedViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate,ArticlesTableSelectionDelegate, UIScrollViewDelegate> {
    
    IBOutlet UIView *mainView;
    IBOutlet UIView *menuContainer;
    IBOutlet UIView *overLayView;
    IBOutlet UIView *searchResultsContainer;
    IBOutlet UIScrollView *titleBanner;
    
    IBOutlet NSLayoutConstraint *menuViewLeadingSpace;
    IBOutlet NSLayoutConstraint *mainViewWidth;
    IBOutlet NSLayoutConstraint *bannerWidth;
    IBOutlet NSLayoutConstraint *overLayViewLeadingSpace;
    
    NSArray *categories;
    NSArray *searchResults;
    NSString *selectedClassifiedsUrl;
    UILabel *regionCategoryLabel;

    PNGMenuTableView *menuTableView;
    PNGArticle *selectedArticle;
    PNGArticlesTableViewController *resultsViewController;
    
    UIBarButtonItem *menuButton;
    UIBarButtonItem *searchButton;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *filterButton;
    PNGLatoTextField *searchField;
    UIImageView *logoView;
    NSInteger currentIndex;
    NSInteger nextIndex;
    MadsAdView *madsOverlayAdView;
}

@property (nonatomic, assign) BOOL isSearching;

- (void)showSearchView;

- (void)showRefreshingView;

@end
