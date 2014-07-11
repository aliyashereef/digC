//
//  PNGArticlesViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGListArticleCell.h"
#import "PNGHighlightedArticleCell.h"
#import "PNGPromotedArticleCell.h"
#import "ADPullToRefreshView.h"
#import "PNGSubCategoryViewController.h"
#import "PNGAdsTableViewCell.h"
#import "PNGLoadMoreCell.h"

/*
 View controller which lists all the articles of a category. Need to set category object to this
 class. Once a category object is set, it will fetch articles from the parse and refresh the table.
 */

#pragma mark - Probably need to use a CollectionView for this screen
@interface PNGArticlesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADPullToRefreshViewDelegate> {

//    NSMutableDictionary *articles;
    NSMutableArray *allArticles;    //  list articles to pass to the article detail view.
    NSMutableArray *articlesArray;
    NSArray *promotedArticles;
    IBOutlet UITableView *articlesTable;
    IBOutlet UIView *titleBottomLine;
    PNGArticle *selectedArticle;
    PNGArticle *secondPromotedArticle;
    PNGArticle *featuredArticle;
    
    BOOL _reloading;
    BOOL articlesFinished;
    UIBarButtonItem *menuButton;
    UIBarButtonItem *weatherButton;
    UIBarButtonItem *logoButton;
    UIBarButtonItem *cancelButton;
    UITextField *searchField;
    UIImageView *logoView;
    
    ADPullToRefreshView *pullToRefreshView;
    PNGSubCategoryViewController *subCategoryViewController;
}

@property (nonatomic, strong) NSDictionary *category;
@property (nonatomic, strong) NSArray *subCategories;
@property (nonatomic, strong) NSArray *categories;

@end
