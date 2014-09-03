//
//  PNGArticlesViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticlesViewController.h"
#import "PNGArticleListTableViewCell.h"
#import "PNGArticlePageViewController.h"

#define kFeaturedCellHeight 206
#define kPromotedCellHeight 202
#define kListTypeCellHeight 92
#define kAdCellHeight       162
#define kLoadMoreCellHeight 60

@interface PNGArticlesViewController ()

@end

@implementation PNGArticlesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Articles View";
    articlesFinished = NO;
    allArticles = [[NSMutableArray alloc] init];
    articlesArray = [[NSMutableArray alloc] init];
    if ([_category valueForKey:@"parentId"] == [NSNumber numberWithInt:1]){
        [self fetchCategoryArticles];
    }else{
        [self fetchClassifiedArticles];
    }
    [self addCategoryView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [articlesTable deselectRowAtIndexPath:articlesTable.indexPathForSelectedRow animated:YES];
    if (pullToRefreshView == nil) {
		ADPullToRefreshView *view = [[ADPullToRefreshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - articlesTable.bounds.size.height, self.view.frame.size.width, articlesTable.bounds.size.height)];
		view.delegate = self;
		[articlesTable addSubview:view];
		pullToRefreshView = view;
        pullToRefreshView.searchColor = [PNGUtilities getColorForCategoryItem:[[_category valueForKey:@"categoryId"] intValue]];
        pullToRefreshView.refreshIcon = [UIImage imageNamed:@"ic-refresh"];
        pullToRefreshView.searchIcon = [UIImage imageNamed:@"SearchIcon"];
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOrHideSubCategoryView:)
                                                 name:kFilterSelectionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(subCategorySelected:)
                                                 name:kSubCategoryItemSelected
                                               object:nil];
    
    UIColor *color = [PNGUtilities getColorForCategoryItem:[[_category valueForKey:@"categoryId"] intValue]];
    titleBottomLine.backgroundColor = color;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFilterSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSubCategoryItemSelected object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter methods

//  Setter method for category.
- (void)setCategory:(NSDictionary *)category {
    _category = category;
    articlesFinished = NO;
    if([_category valueForKey:@"subCategories"]) {
        _subCategories = [_category valueForKey:@"subCategories"];
    }
}

#pragma mark - IBActions

//  show detail view of the selected promoted article.
- (IBAction)showPromotedArticle:(id)sender {
    NSInteger index = [sender tag];
    if(index < promotedArticles.count) {
        selectedArticle = [promotedArticles objectAtIndex:index];
        [self performSegueWithIdentifier:PNGStoryboardViewControllerArticleDetail sender:self];
    }
}

//  Fetching next set of categories.
- (void)loadMoreButtonAction:(id)sender {
    NSNumber *categoryId = [NSNumber numberWithInt:[[_category valueForKey:@"categoryId"] intValue]];
    int page = (int)allArticles.count/20;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFCloud callFunctionInBackground:@"getFeed" withParameters:@{@"category": categoryId, @"page":[NSString stringWithFormat:@"%d",page]} block:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            int index = (allArticles.count-3)%4;
            NSMutableArray *listType = [[NSMutableArray alloc] initWithArray:[objects valueForKey:@"feed"]];
            if(listType.count > 0) {
                [allArticles addObjectsFromArray:listType];
                if(allArticles.count%20 > 0) {
                    articlesFinished = YES;
                }
                for(int i = 1; i <= listType.count; i++) {
                    if ((i+index) % 5 == 0) {
                        [listType insertObject:[NSNull null] atIndex:i-1];
                    }
                }
                [articlesArray addObjectsFromArray:listType];
            } else {
                articlesFinished = YES;
            }
            [articlesTable reloadData];
        } else {
            NSString *errorMsg = error.localizedDescription;
            if(error.code == 100) {
                errorMsg = NSLocalizedString(@"NO_INTERNET", @"");
            }
            [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
        }
    }];
}

#pragma mark - Private methods

//  Fetch articles of a particular category & categorizing articles into a dictionary.
- (void)fetchCategoryArticles {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSNumber *categoryId = [NSNumber numberWithInt:[[_category valueForKey:@"categoryId"] intValue]];
    NSDictionary *params = @{@"category":categoryId, @"page":[NSNumber numberWithInt:0]};
    [PFCloud callFunctionInBackground:@"getFeed"
                       withParameters:params
                                block:^(NSDictionary *result, NSError *error) {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [self doneLoadingTableViewData];
                                    if (!error) {
                                        if(allArticles) {
                                            [allArticles removeAllObjects];
                                        }
                                        if(articlesArray) {
                                            [articlesArray removeAllObjects];
                                        }
                                        featuredArticle = nil;
                                        promotedArticles = nil;
                                        NSArray *featured = [result valueForKey:@"featured"];
                                        if(featured.count > 0) {
                                            featuredArticle = featured.firstObject;
                                            featuredArticle.type = FeaturedArticle;
                                            [allArticles addObject:featuredArticle];
                                            [articlesArray addObject:featuredArticle];
                                        }
                                        NSArray *promoted = [result valueForKey:@"priority"];
                                        if(promoted.count > 1) {
                                            PNGArticle *promotedArticle1 = promoted.firstObject;
                                            promotedArticle1.type = PromotedArticle;
                                            secondPromotedArticle = [promoted objectAtIndex:1];
                                            secondPromotedArticle.type = PromotedArticle;
                                            promotedArticles = @[promotedArticle1,secondPromotedArticle];
                                            [allArticles addObjectsFromArray:@[promotedArticle1,secondPromotedArticle]];
                                            [articlesArray addObject:promotedArticle1];
                                        } else if(promoted.count > 0) {
                                            PNGArticle *promotedArticle = promoted.firstObject;
                                            promotedArticle.type = PromotedArticle;
                                            promotedArticles = @[promotedArticle];
                                            [allArticles addObject:promotedArticle];
                                            [articlesArray addObject:promotedArticle];
                                        }
                                        NSMutableArray *listType = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"feed"]];
                                        if(listType.count > 0) {
                                            [allArticles addObjectsFromArray:listType];
                                            if(allArticles.count < 20) {
                                                articlesFinished = YES;
                                            }
                                            for(int i = 1; i <= listType.count; i++) {
                                                if (i % 5 == 0) {
                                                    [listType insertObject:[NSNull null] atIndex:i-1];
                                                }
                                            }
                                            [articlesArray addObjectsFromArray:listType];
                                        }
                                        [articlesTable reloadData];
                                        if(articlesArray.count > 0) {
                                            [articlesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                        }
                                    } else {
                                        NSString *errorMsg = error.localizedDescription;
                                        if(error.code == 100) {
                                            errorMsg = NSLocalizedString(@"NO_INTERNET", @"");
                                        }
                                        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
                                    }
                                }];
}

//  Fetch articles of a particular classified.
- (void)fetchClassifiedArticles{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    PFQuery *query = [PFQuery queryWithClassName:@"Classifieds"];
    [query whereKey:@"ad_category_parent_id" equalTo:[_category valueForKey:@"categoryId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self doneLoadingTableViewData];
        if (!error) {
            
            if(articlesArray) {
                [articlesArray removeAllObjects];
            }
            for (PFObject *object in objects) {
                [articlesArray addObject:object];
            }
            if (articlesArray.count > 2) {
                secondPromotedArticle = [articlesArray objectAtIndex:2];
                [articlesArray removeObjectAtIndex:2];
            }
            [articlesTable reloadData];
        } else {
            NSString *errorMsg = error.localizedDescription;
            if(error.code == 100) {
                errorMsg = NSLocalizedString(@"NO_INTERNET", @"");
            }
            [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
        }
    }];
}

//  Adding category view as a subview.
- (void)addCategoryView {
    if([_category valueForKey:@"subCategories"]) {
        _subCategories = [_category valueForKey:@"subCategories"];
        subCategoryViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerSubcategoryList];
        subCategoryViewController.view.frame = self.view.bounds;
        [self addChildViewController:subCategoryViewController];
        [self.view addSubview:subCategoryViewController.view];
        subCategoryViewController.subCategories = _subCategories;
        subCategoryViewController.view.hidden = YES;
    }
}

//  Creates an inline mads view.
- (MadsAdView *)createAdsView {
    NSString *adsZone = [_category valueForKey:@"ad_id_bottom"];
    MadsAdView *madsAdView = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 6.0, 320, 150.0) zone:adsZone secret:kMadsInlineAdSecret delegate:nil];
    madsAdView.madsAdType = MadsAdTypeInline;
    return madsAdView;
}

#pragma mark - Notification methods

//  Invoked on clicking the navigation bar filter button on the articles pageview.
- (void)showOrHideSubCategoryView:(NSNotification *)notification {
    subCategoryViewController.view.hidden = !subCategoryViewController.view.hidden;
}

//  Invoked on selecting an item from subcategory list.
- (void)subCategorySelected:(NSNotification *)notification {
    subCategoryViewController.view.hidden = YES;
    self.category = notification.object;
    if ([_category valueForKey:@"parentId"] == [NSNumber numberWithInt:1]){
        [self fetchCategoryArticles];
    }else{
        [self fetchClassifiedArticles];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PNGStoryboardViewControllerArticleDetail]) {
        PNGArticlePageViewController *controller = (PNGArticlePageViewController *)segue.destinationViewController;
        controller.selectedArticle = selectedArticle;
        controller.articles = allArticles;
        controller.selectedCategory = _category;
    }
}

#pragma mark - TableViewController DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return articlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGArticle *article = [articlesArray objectAtIndex:indexPath.row];
    if([article isKindOfClass:[NSNull class]]) {
        return kAdCellHeight;
    } else if([article isKindOfClass:[NSString class]]) {
        return kLoadMoreCellHeight;
    } else {
        if ([_category valueForKey:@"parentId"] == [NSNumber numberWithInt:1]){
            switch (article.type) {
                case FeaturedArticle:
                    return kFeaturedCellHeight;
                    break;
                case PromotedArticle:
                    return kPromotedCellHeight;
                    break;
                default:
                    return kListTypeCellHeight;
                    break;
            }
        }else{
            switch (indexPath.row){
                case 0:
                    return kFeaturedCellHeight;
                    break;
                case 1:
                    return kPromotedCellHeight;
                    break;
                default:
                    return kListTypeCellHeight;
                break;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    PNGArticle *article = [articlesArray objectAtIndex:indexPath.row];
    if([article isKindOfClass:[NSNull class]]) {
        cell = [self loadAdvertCell:tableView cellForRowAtIndexPath:indexPath];
    } else {
        if ([_category valueForKey:@"parentId"] == [NSNumber numberWithInt:1]){

            switch (article.type) {
                case FeaturedArticle:
                    cell = [self loadHighlightedArticleCell:tableView cellForRowAtIndexPath:indexPath];
                    break;
                case PromotedArticle:
                    cell = [self loadPromotedArticleCell:tableView cellForRowAtIndexPath:indexPath];
                    break;
                default:
                    cell = [self loadListArticleCell:tableView cellForRowAtIndexPath:indexPath];
                    break;
            }
        }else{
            switch (indexPath.row){
                case 0:
                    cell = [self loadHighlightedArticleCell:tableView cellForRowAtIndexPath:indexPath];
                    break;
                case 1:
                    cell = [self loadPromotedArticleCell:tableView cellForRowAtIndexPath:indexPath];
                    break;
                default:
                    cell = [self loadListArticleCell:tableView cellForRowAtIndexPath:indexPath];
                    break;
            }
            
        }
        if(indexPath.row == articlesArray.count-1 && !articlesFinished) {
            [self loadMoreButtonAction:nil];
        }
    }
    return cell;
}

#pragma mark - Custom cell loading

//  Loading advertisement cell
- (UITableViewCell *)loadAdvertCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PNGAdsTableViewCell";
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

//  Loading HighlightedArticleCell
- (PNGHighlightedArticleCell *)loadHighlightedArticleCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PNGHighlightedArticleCell";
    PNGHighlightedArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PNGHighlightedArticleCell" owner:nil options:nil] firstObject];
    }
    cell.parent  = [_category valueForKey:@"parentId"];
    cell.article = [articlesArray objectAtIndex:indexPath.row];
    return cell;
}

//  Loading ListArticleCell
- (PNGListArticleCell *)loadListArticleCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PNGListArticleCell";
    PNGListArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PNGListArticleCell" owner:nil options:nil] firstObject];  
    }
    cell.parent  = [_category valueForKey:@"parentId"];
    cell.article = [articlesArray objectAtIndex:indexPath.row];
    return cell;
}

//  Loading PromotedArticleCell
- (PNGPromotedArticleCell *)loadPromotedArticleCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"PNGPromotedArticleCell";
    PNGPromotedArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PNGPromotedArticleCell" owner:nil options:nil] firstObject];
    }
    cell.parent  = [_category valueForKey:@"parentId"];
    cell.article = [articlesArray objectAtIndex:indexPath.row];
    if(secondPromotedArticle) {
        cell.secondArticle = secondPromotedArticle;
        cell.secondArticleContainer.hidden = NO;
    } else {
        cell.secondArticleContainer.hidden = YES;
    }
    return cell;
}

#pragma mark - TableView Delegate

//  Table view cell selection delegate method.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [articlesArray objectAtIndex:indexPath.row];
    if(![object isKindOfClass:[NSNull class]]) {
        if ([_category valueForKey:@"parentId"] == [NSNumber numberWithInt:1]){
            selectedArticle = [articlesArray objectAtIndex:indexPath.row];
            if(selectedArticle.type != PromotedArticle) { //    For promoted articles, we have 2 buttons in single cell
                [self performSegueWithIdentifier:PNGStoryboardViewControllerArticleDetail sender:self];
            }
        }else{
            [self performSegueWithIdentifier:PNGStoryboardViewControllerArticleDetail sender:self];
        }
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
	[pullToRefreshView refreshScrollViewDataSourceDidFinishedLoading:articlesTable];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[pullToRefreshView refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[pullToRefreshView refreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - ADPullToRefreshViewDelegate <NSObject>

- (void)refreshTableHeaderDidTriggerRefresh:(ADPullToRefreshView*)view {
//	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTriggeredNotification object:nil];
    if ([_category valueForKey:@"parentId"] == [NSNumber numberWithInt:1]){
        [self fetchCategoryArticles];
    }else{
        [self fetchClassifiedArticles];
    }
}

- (void)refreshTableHeaderDidTriggerSearch:(ADPullToRefreshView*)view {
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSearchTriggeredNotification object:nil];
}

- (BOOL)refreshTableHeaderDataSourceIsLoading:(ADPullToRefreshView*)view {
	return _reloading; // should return if data source model is reloading
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

@end
