//
//  PNGArticlesTableViewController.h
//  DigicelPNG
//
//  Created by Arundev K S on 28/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGListArticleCell.h"
#import "PNGArticlePageViewController.h"

/*
 Subclass of UITableViewController. Lists an array of list type articles.
 */

@protocol   ArticlesTableSelectionDelegate;

@interface PNGArticlesTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, strong) id <ArticlesTableSelectionDelegate> delegate;

@end

@protocol ArticlesTableSelectionDelegate <NSObject>

//  Invoked on selecting each article from the search results table
- (void)articlesTableSelection:(PNGArticlesTableViewController *)articlesTableViewController didSelectArticle:(PNGArticle *)article;

@end
