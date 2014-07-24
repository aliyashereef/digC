//
//  PNGArticlesTableViewController.m
//  DigicelPNG
//
//  Created by Arundev K S on 28/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticlesTableViewController.h"

#define kListTypeCellHeight 92
#define kAdCellHeight       162

@interface PNGArticlesTableViewController ()
{
    int indexForLoadMore;
    BOOL articlesFinished;
}
@end

@implementation PNGArticlesTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter methods

//  Setter method for articles.
- (void)setArticles:(NSArray *)articles {
    _articles =[[NSMutableArray alloc]initWithArray:articles];
    indexForLoadMore=0;
    if (articles.count<kNoOfCellInSearchView) {
        articlesFinished = YES;
    }else{
        articlesFinished = NO;
    }
    [self loadArticlesWithAd:_articles];
    if(articles.count > 0) {
       [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _allArticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    PNGArticle *article = [_allArticles objectAtIndex:indexPath.row];
    if([article isKindOfClass:[NSNull class]]) {
        cell = [self loadAdvertCell:tableView cellForRowAtIndexPath:indexPath];
    } else {
        static NSString *cellIdentifier = @"PNGListArticleCell";
        PNGListArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if(cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PNGListArticleCell" owner:nil options:nil] firstObject];
        }
        cell.article = article;
        if(indexPath.row == _allArticles.count-1 && !articlesFinished ) {
            indexForLoadMore++;
            [self loadMoreButtonAction:nil];
        }
        return cell;
    }
    return cell;
}
// Return the ad cell.
- (UITableViewCell *)loadAdvertCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PNGAdsTableViewCell";
    PNGAdsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell.adView) {
        if(cell.adView == nil) {
            cell.adView = [self createAdsView];
            cell.adView.tag = indexPath.row;
            [cell addSubview:cell.adView];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGArticle *article = [_allArticles objectAtIndex:indexPath.row];
    if([article isKindOfClass:[NSNull class]]) {
        return kAdCellHeight;
    }else{
        return kListTypeCellHeight;
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_delegate && [_delegate respondsToSelector:@selector(articlesTableSelection:didSelectArticle:)]) {
        [_delegate articlesTableSelection:self didSelectArticle:[_allArticles objectAtIndex:indexPath.row]];
    }
}

#pragma mark - Private Functions

//Fetching next set of search results from the DB .
- (void)loadMoreButtonAction:(id)sender {
    NSNumber *categoryId = [NSNumber numberWithInt:[[_category valueForKey:@"categoryId"] intValue]];
    PFQuery *titleQuery = [PNGArticle query];
    [titleQuery whereKey:@"title" containsString:_searchFieldText.lowercaseString];
    [titleQuery whereKey:@"title" containsString:_searchFieldText.uppercaseString];
    [titleQuery whereKey:@"title" containsString:_searchFieldText.capitalizedString];
    PFQuery *contentQuery = [PNGArticle query];
    [contentQuery whereKey:@"content" containsString:_searchFieldText.lowercaseString];
    [contentQuery whereKey:@"content" containsString:_searchFieldText.capitalizedString];
    [contentQuery whereKey:@"content" containsString:_searchFieldText.uppercaseString];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[titleQuery,contentQuery]];
    [query whereKey:@"category" containsAllObjectsInArray:@[categoryId]];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"publishedDate" ascending:NO];
    [query orderBySortDescriptor:sortDesc];
    query.limit = kNoOfCellInSearchView;
    query.skip = kNoOfCellInSearchView*indexForLoadMore;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (objects.count>0) {
                [_articles addObjectsFromArray:objects];
                [self loadArticlesWithAd:_articles];
                if (_articles.count%kNoOfCellInSearchView > 0) {
                    articlesFinished=YES;
                }
            }else{
                articlesFinished=YES;
            }
        }
    }];
}

//Loading the fourth cell with a null cell .
- (void)loadArticlesWithAd:(NSMutableArray *)array
{
    NSMutableArray *listType = [[NSMutableArray alloc] initWithArray:array];
    _allArticles = [[NSMutableArray alloc]init];
    if(listType.count > 0) {
        for(int i = 0; i <= listType.count; i++) {
            if (i==0) {
                continue;
            }
            if (i % 5 == 0) {
                [listType insertObject:[NSNull null] atIndex:i-1];
            }
        }
        [_allArticles addObjectsFromArray:listType];
    }
    [self.tableView reloadData];
}

//  Creates an inline mads view.
- (MadsAdView *)createAdsView {
    NSString *adsZone = [_category valueForKey:@"ad_id_bottom"];
    MadsAdView *madsAdView = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 6.0, 320, 150.0) zone:adsZone  secret:kMadsInlineAdSecret delegate:nil];
    madsAdView.madsAdType = MadsAdTypeInline;
    return madsAdView;
}

#pragma mark - MadsAdViewDelegate

//  Sent after an ad view finished loading ad content.
//  The ad will display immediately after this signal.
- (void)didReceiveAd:(id)sender {
    MadsAdView *adView = (MadsAdView *)sender;
    NSLog(@"tag : %ld",(long)adView.tag);
}

//  Sent if an ad view failed to load ad content.
- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
