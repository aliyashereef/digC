//
//  PNGArticlesPageViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticlesPageViewController.h"
#import "PNGArticlesViewController.h"
#import "PNGWeatherIconView.h"
#import "PNGWeatherViewController.h"
#import "UIColor+PNGColor.h"
#import "PNGMenuTableView.h"
#import "PNGMenuTableViewCell.h"
#import "PNGClassifiedsViewController.h"

typedef enum {
	ShowMainView = 0,
	ShowOverlayView,
	ShowResultsView,
} ContainerViewVisibilty;

@interface PNGArticlesPageViewController ()

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) PNGWeatherIconView *weatherView;

@end

@implementation PNGArticlesPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentIndex = 0;
    [self getCategoriesArray];
    [self createBarButtonItems];
    [self showRefreshingView];
    self.sections = [[NSMutableArray alloc] init];
    [self addMenuTable];
    [self addSearchResultsView];
    [self addCategoriesBanner];
    
    [self createViewControllerPages];
    [self.pageViewController setViewControllers:@[[self.sections firstObject]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    for(UIScrollView *srollview in self.pageViewController.view.subviews) {
        if([srollview isKindOfClass:[UIScrollView class]]) {
            srollview.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mainMenuItemSelectedNotification:)
                                                 name:kMenuSelectionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(categoryItemSelectedNotification:)
                                                 name:kCategorySelectionNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginButtonPressed:)
                                                 name:kLoginButtonPressed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoButtonPressed:)
                                                 name:kUserInfoButtonPressed
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSearchView)
                                                 name:kSearchTriggeredNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showRefreshingView)
                                                 name:kRefreshTriggeredNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(subCategorySelected:)
                                                 name:kSubCategoryItemSelected
                                               object:nil];
    [menuTableView refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMenuSelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategorySelectionNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginButtonPressed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserInfoButtonPressed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSearchTriggeredNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRefreshTriggeredNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSubCategoryItemSelected object:nil];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter methods

- (void)setIsSearching:(BOOL)isSearching {
    _isSearching = isSearching;
}

#pragma mark - Properties

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        _pageViewController.dataSource = self;
        _pageViewController.delegate = self;
        
        [self addChildViewController:_pageViewController];
        _pageViewController.view.frame = mainView.bounds;
        [mainView addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
    return _pageViewController;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:PNGStoryboardViewControllerSearchResults]) {
        PNGArticlePageViewController *articlePageViewController = (PNGArticlePageViewController *)segue.destinationViewController;
        articlePageViewController.selectedArticle = selectedArticle;
        articlePageViewController.articles = searchResults;
    } else if([segue.identifier isEqualToString:PNGStoryboardViewControllerClassifieds]) {
        PNGClassifiedsViewController *classifiedsViewController = (PNGClassifiedsViewController *)segue.destinationViewController;
        classifiedsViewController.url = selectedClassifiedsUrl;
    }
}

#pragma mark - PageViewController Helper Methods

- (NSUInteger)indexOfViewController:(PNGArticlesViewController *)viewController {
    NSInteger index = [self.sections indexOfObject:viewController];
//    currentIndex = index;
    [self showRefreshingView];  //  Update navigation bar buttons.
    return index;
}

- (PNGArticlesViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    PNGArticlesViewController *articlesViewController;
    if (self.sections.count > index) {
        articlesViewController = self.sections[index];
    }
    if (!articlesViewController) {
        articlesViewController= [storyboard instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerArticles];
    }
    return articlesViewController;
}


#pragma mark - PageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if(self.isSearching) {
        return nil;
    }
    NSUInteger index = [self indexOfViewController:(PNGArticlesViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if(self.isSearching) {
        return nil;
    }
    NSUInteger index = [self indexOfViewController:(PNGArticlesViewController *)viewController];
    if (index == NSNotFound) {
        nil;
    }
    index++;
    if(index == categories.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    [self showRefreshingView];
    PNGArticlesViewController *vc = [pendingViewControllers firstObject];
    nextIndex = [self indexOfViewController:vc];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(completed){
        currentIndex = nextIndex;
    }
    nextIndex = 0;
}


#pragma mark - Private Methods

//  Adding menu table as a subview.
- (void)addMenuTable {
    menuTableView = [[[NSBundle mainBundle] loadNibNamed:@"PNGMenuTableView" owner:nil options:nil] firstObject];
    [menuContainer addSubview:menuTableView];
    menuTableView.menuItems = categories;
}

//  Adding search result view controller as a child viewcontroller.
- (void)addSearchResultsView {
    resultsViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerArticlesTable];
    resultsViewController.delegate = self;
    [self addChildViewController:resultsViewController];
    resultsViewController.view.frame = searchResultsContainer.bounds;
    [searchResultsContainer addSubview:resultsViewController.view];
}

//  Adding categories labels on the top banner.
- (void)addCategoriesBanner {
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat x = viewWidth/4;
    for(NSDictionary *dict in categories) {
        PNGLatoLabel *label = [[PNGLatoLabel alloc] initWithFrame:CGRectMake(x, 0, viewWidth/2, 32)];
        [titleBanner addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Lato-Bold" size:17];
        label.text = [dict valueForKey:@"title"];
        label.textColor = [PNGUtilities getColorForCategoryItem:[[dict valueForKey:@"categoryId"] intValue]];
        x = x + viewWidth/2;
        if([[dict valueForKey:@"categoryId"] intValue] == Regional) {
            regionCategoryLabel = label;
        }
    }
    bannerWidth.constant = x + viewWidth/4;
}

//  Loading categories from parse server.
- (void)loadSections {
    [self createViewControllerPages];
    [self.pageViewController setViewControllers:@[[self.sections firstObject]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

//  Loading categories from plist
- (void)getCategoriesArray {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Categories" ofType:@"plist"];
    NSURL *dataURL = [NSURL fileURLWithPath:path];
    categories = [[NSArray alloc] initWithContentsOfURL:dataURL];
}

//  Search articles for the given string.
- (void)performSearch:(id)sender {
    PNGArticlesViewController *articlesViewController = [self viewControllerAtIndex:currentIndex storyboard:self.storyboard];
    NSDictionary *category = articlesViewController.category;
    NSNumber *categoryId = [NSNumber numberWithInt:[[category valueForKey:@"categoryId"] intValue]];
    PFQuery *titleQuery = [PNGArticle query];
    [titleQuery whereKey:@"title" containsString:searchField.text.lowercaseString];
    PFQuery *contentQuery = [PNGArticle query];
    [contentQuery whereKey:@"content" containsString:searchField.text.lowercaseString];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[titleQuery,contentQuery]];
    [query whereKey:@"category" containsAllObjectsInArray:@[categoryId]];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"publishedDate" ascending:NO];
    [query orderBySortDescriptor:sortDesc];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            resultsViewController.articles = objects;
            searchResultsContainer.hidden = NO;
            [self changecontainerVisibiityForState:ShowResultsView];
        } else {
            // Log details of the failure
            NSString *errorMsg = error.localizedDescription;
            if(error.code == 100) {
                errorMsg = NSLocalizedString(@"NO_INTERNET", @"");
            }
            [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:errorMsg];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//  Creates an array of view controllers for the pageview controller.
- (void)createViewControllerPages {
    [self.sections removeAllObjects];
    for(NSDictionary *category in categories) {
        PNGArticlesViewController *articlesViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerArticles];
        articlesViewController.category = category;
        articlesViewController.categories = categories;
        [self.sections addObject:articlesViewController];
    }
}

//  Shows classifieds view
- (void)showClassifiedsWithDictionary:(NSDictionary *)classifiedsDictionary {
    selectedClassifiedsUrl = [classifiedsDictionary valueForKey:@"url"];
    [self performSegueWithIdentifier:PNGStoryboardViewControllerClassifieds sender:self];
}

//  Send a story.
- (void)sendStory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:kLoginStatus]) {
        PNGSendStoryViewController *sendStoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PNGStoryboardVCSendStoryId"];
        [self.navigationController pushViewController:sendStoryViewController animated:YES];
    } else {
        UINavigationController *signInController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardNavViewControllerLogin];
        [self.navigationController presentViewController:signInController animated:YES completion:^(){
            [self showOrHideMenuView:nil];
        }];
    }
}

//  Send feedback to a email id. Shows mail composer.
- (void)sendFeedback {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        [mailComposer setMailComposeDelegate:self];
        [mailComposer setSubject:NSLocalizedString(@"FEED_BACK_SUBJECT", @"")];
        NSArray *toRecipients = [NSArray arrayWithObject:kFeedBackEmailID];
        [mailComposer setToRecipients:toRecipients];
        [self presentViewController:mailComposer animated:YES completion:nil];
    } else {
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"MAIL", @"") message:NSLocalizedString(@"NO_EMAIL_ACC", @"")];
    }
}

//  Share application via mail, social media apps.
- (void)shareApplication {
    
    NSString *shareText = NSLocalizedString(@"CHECK_OUT_APP", @"");
    //Replace this with actual url to be shared
    NSURL *shareUrl = [NSURL URLWithString:@"https://www.google.com"];
    NSArray * activityItems = @[shareText, shareUrl];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[]];
    //items to be excluded from activity view controller
    NSArray *excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    activityController.excludedActivityTypes = excludeActivities;
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

//  Opens itunes link.
- (void)rateOrReviewApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kITunesLink]];
}

//  Creating four types of navigation bar buttons, logo view and navigation bar textfield.
- (void)createBarButtonItems {
    menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavMenuIcon"]
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(showOrHideMenuView:)];
    
    filterButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic-sort"]
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(showSubCategories:)];
    
    searchButton = [[UIBarButtonItem alloc] initWithCustomView:[self createNavigationBarSearchIcon]];
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(cancelButtonAction:)];
    searchField = [self createNavigationBarTextField];
    logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PNGStoryboardImageNavigationLogo]];
}

//  Returns custom view for right nav bar button search icon.
- (UIView *)createNavigationBarSearchIcon {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 26)];
    [button setImage:[UIImage imageNamed:@"NavBarSearch"] forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 26)];
    backButtonView.bounds = CGRectOffset(backButtonView.bounds, 0, 0);
    [backButtonView addSubview:button];
    return backButtonView;
}

//  Returns custom textfield for navigation bar search feature.
- (PNGLatoTextField *)createNavigationBarTextField {
    PNGLatoTextField *searchTextField = [[PNGLatoTextField alloc] initWithFrame:CGRectMake(0, 5, 220, 34)];
    searchTextField.delegate = self;
    searchTextField.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    searchTextField.placeholder = NSLocalizedString(@"SEARCH_PLACEHOLDER", @"");
    [searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchTextField.textColor = [UIColor whiteColor];
    [searchTextField addTarget:self action:@selector(performSearch:) forControlEvents:UIControlEventEditingDidEndOnExit];
    return searchTextField;
}

//  Shows search view, navigation bar left button changes to search image, right bar button changes to
//  cancel button. Nav bar title view changes to textfield.
- (void)showSearchView {
    searchField.text = @"";
    [self changecontainerVisibiityForState:ShowOverlayView];
    self.navigationItem.leftBarButtonItem = searchButton;
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.navigationItem.titleView = searchField;
    [searchField becomeFirstResponder];
}

//  Shows default state, navigation bar left button changes to menu button, hide right bar button.
//  Nav bar title view changes to logo imageview.
- (void)showRefreshingView {
//    NSDictionary *category = [categories objectAtIndex: currentIndex];
    PNGArticlesViewController *articlesViewController = [self viewControllerAtIndex:currentIndex storyboard:self.storyboard];
    [self changecontainerVisibiityForState:ShowMainView];
    self.navigationItem.leftBarButtonItem = menuButton;
    if(articlesViewController.subCategories) {
        self.navigationItem.rightBarButtonItem = filterButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationItem.titleView = logoView;
}

//  Changing overLayView & searchResultsContainer visibility
- (void)changecontainerVisibiityForState:(ContainerViewVisibilty)state {
    switch(state) {
        case ShowMainView:
            overLayView.hidden = YES;
            searchResultsContainer.hidden = YES;
            break;
        
        case ShowOverlayView:
            overLayView.hidden = NO;
            searchResultsContainer.hidden = YES;
            break;
        
        case ShowResultsView:
            overLayView.hidden = YES;
            searchResultsContainer.hidden = NO;
            break;
            
            default:
            overLayView.hidden = YES;
            searchResultsContainer.hidden = YES;
            break;
    }
}

#pragma mark - IBActions

//  Show or hide menu view.
- (void)showOrHideMenuView:(id)sender {
    CGFloat menuViewConstantValue = (menuViewLeadingSpace.constant == kMenuViewVisibleLeadingSpace?kMenuViewHiddenLeadingSpace:kMenuViewVisibleLeadingSpace);
    CGFloat overLayViewConstantValue = (overLayViewLeadingSpace.constant == kOverLayViewVisibleLeadingSpace?kOverLayViewHiddenLeadingSpace:kOverLayViewVisibleLeadingSpace);
    [UIView animateWithDuration:kAnimationDuration
                          delay:kAnimationDelay
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^() {
                         menuViewLeadingSpace.constant = menuViewConstantValue;
                         overLayViewLeadingSpace.constant = overLayViewConstantValue;
                         if (menuViewConstantValue == kMenuViewVisibleLeadingSpace) {
                             overLayView.hidden = NO;
                             UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMenuView:)];
                             [overLayView addGestureRecognizer:gestureRecognizer];
                         } else {
                             overLayView.hidden = YES;
                             [overLayView removeGestureRecognizer:[overLayView.gestureRecognizers objectAtIndex:0]];
                         }
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished){}];
}


- (IBAction)showWeather:(id)sender {
    PNGWeatherViewController *weatherViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerWeather];
    [self.navigationController pushViewController:weatherViewController animated:YES];
}

//  search cancel button action.
- (void)cancelButtonAction:(id)sender {
    searchField.text = @"";
    [searchField resignFirstResponder];
    self.isSearching = NO;
    [self showRefreshingView];
}

//  Shows an action sheet with subcategories list.
- (void)showSubCategories:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFilterSelectionNotification object:nil];
}

#pragma mark - Notification methods

//  invoked when login button is pressed.
- (void)loginButtonPressed:(NSNotification *)notif {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:kLoginStatus]) {
        [APP_DELEGATE setLoggedInUser:nil];
        [defaults removeObjectForKey:kUserInfo];
        [defaults removeObjectForKey:kAuthCookie];
        [defaults setBool:NO forKey:kLoginStatus];
        [defaults setBool:NO forKey:kLoggedInWithFacebook];
        [defaults synchronize];
        [menuTableView refresh];
        [self showOrHideMenuView:nil];
    } else {
        UINavigationController *signInController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardNavViewControllerLogin];
        [self.navigationController presentViewController:signInController animated:YES completion:^(){
            [self showOrHideMenuView:nil];
        }];
    }
}

//  invoked when user info button is pressed.
- (void)userInfoButtonPressed:(NSNotification *)notif {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:kLoginStatus]) {
        UINavigationController *signInController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardNavViewControllerProfile];
        [self.navigationController presentViewController:signInController animated:YES completion:nil];
    }
}

//  invoked when a main menu item is selected from the side menu.
- (void)mainMenuItemSelectedNotification:(NSNotification *)notification {
    if([notification.object isKindOfClass:[NSDictionary class]]) {
        [self showClassifiedsWithDictionary:notification.object];
    } else {
        NSIndexPath *indexPath = (NSIndexPath *)notification.object;
        [self showMenuItemsAtIndex:indexPath];
    }
    [self showOrHideMenuView:nil];
}

//  Shows other menu items like send us a story etc...
- (void)showMenuItemsAtIndex:(NSIndexPath *)indexPath {
    if(indexPath.section != 3)  return;
    switch (indexPath.row) {
        case 0:
            [self sendStory];
            break;
        case 1:
            [self sendFeedback];
            break;
        case 2:
            [self shareApplication];
            break;
        case 3:
            [self rateOrReviewApp];
            break;
            
        default:
            break;
    }
}

//  invoked when a category item is selected from the side menu.
- (void)categoryItemSelectedNotification:(NSNotification *)notification {
    NSIndexPath *indexPath = (NSIndexPath *)notification.object;
    currentIndex = indexPath.row;
    [titleBanner setContentOffset:CGPointMake(((currentIndex) * self.view.frame.size.width/2), 0) animated:NO];
    [self showRefreshingView];
    PNGArticlesViewController *articleViewController = [self viewControllerAtIndex:indexPath.row storyboard:self.storyboard];
    [_pageViewController setViewControllers:@[articleViewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [self showOrHideMenuView:nil];
}

//  Invoked on selecting an item from subcategory list.
- (void)subCategorySelected:(NSNotification *)notification {
    NSDictionary *category = notification.object;
    regionCategoryLabel.text = [category valueForKey:@"title"];
}

#pragma mark - ArticlesTableSelectionDelegate

//  Invoked on selecting each article from the search results table
- (void)articlesTableSelection:(PNGArticlesTableViewController *)articlesTableViewController didSelectArticle:(PNGArticle *)article {
    searchResults = articlesTableViewController.articles;
    selectedArticle = article;
    [self performSegueWithIdentifier:PNGStoryboardViewControllerSearchResults sender:self];
}

#pragma mark - UIScrollViewDelegate

// Invoked on any offset changes. Changing category banner view content offset as the page view drags.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat viewWidth = self.view.frame.size.width;
    CGPoint currentOffset = scrollView.contentOffset;
    if(currentOffset.x < viewWidth) {
        [titleBanner setContentOffset:CGPointMake((currentIndex * (viewWidth/2))- viewWidth/2 +(currentOffset.x/2), 0)];
    } else if(currentOffset.x > viewWidth) {
        [titleBanner setContentOffset:CGPointMake((currentIndex * (viewWidth/2))+((currentOffset.x - viewWidth)/2), 0)];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *text = [NSMutableString stringWithString:textField.text];
    [text replaceCharactersInRange:range withString:string];
    if(text.length > 0) {
        self.isSearching = YES;
    } else {
        self.isSearching = NO;
    }
    return YES;
}

#pragma mark - MFMailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(result == MFMailComposeResultSent) {
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"SUCCESS", @"") message:NSLocalizedString(@"FEEDBACK_SENT", @"")];
    } else {
        [PNGUtilities showAlertWithTitle:NSLocalizedString(@"FAILED", @"") message:error.localizedDescription];
    }
	[controller dismissViewControllerAnimated:YES completion:nil];
}

@end
