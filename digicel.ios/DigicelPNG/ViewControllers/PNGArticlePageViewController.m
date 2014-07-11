//
//  PNGArticlePageViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticlePageViewController.h"
#import "PNGArticleViewController.h"
#import "PNGArticleViewController.h"
#import "PNGCommentsViewController.h"
#import "PNGSignInViewController.h"

@interface PNGArticlePageViewController ()

@property (nonatomic, strong) NSMutableArray *articleViewsArray;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation PNGArticlePageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [_selectedCategory valueForKey:@"title"];
    self.articleViewsArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed:)];
    UIBarButtonItem *commentsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:PNGStoryboardImageNavigationComments] style:UIBarButtonItemStyleBordered target:self action:@selector(showComments:)];
    self.navigationItem.rightBarButtonItems = @[actionButton, commentsButton];
    [self loadArticles];
    if(_selectedArticle) {
        currentIndex = [_articles indexOfObject:_selectedArticle];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _pageViewController.view.frame = self.view.frame;
        [self.view addSubview:_pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
    return _pageViewController;
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


#pragma mark - PageViewController Helper Methods

- (NSUInteger)indexOfViewController:(PNGArticleViewController *)viewController {
    return [self.articleViewsArray indexOfObject:viewController];
}

- (PNGArticleViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    PNGArticleViewController *articleViewController;
    
    if (self.articleViewsArray.count > index) {
        articleViewController = self.articleViewsArray[index];
    }
    
    if (!articleViewController) {
        articleViewController= [storyboard instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerArticle];
    }
    
    return articleViewController;
}


#pragma mark - PageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfViewController:(PNGArticleViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:kSwipeArticleStatus]) {
        [defaults setBool:YES forKey:kSwipeArticleStatus];
        [defaults synchronize];
    }
    NSUInteger index = [self indexOfViewController:(PNGArticleViewController *)viewController];
    if (index == NSNotFound) {
        nil;
    }
    index++;
    if(index == _articles.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    PNGArticleViewController *vc = [pendingViewControllers firstObject];
    nextIndex = [self indexOfViewController:vc];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if(completed){
        currentIndex = nextIndex;
    }
    nextIndex = 0;
}

#pragma mark - Private Methods

//  Creates an array of view controllers for the pageview controller.
- (void)createViewControllerPages {
    [self.articleViewsArray removeAllObjects];
    for(PNGArticle *article in _articles) {
        PNGArticleViewController *articleViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerArticle];
        articleViewController.article = article;
        articleViewController.articles = _articles;
        articleViewController.selectedCategory = self.selectedCategory;
        [self.articleViewsArray addObject:articleViewController];
    }
}


- (void)loadArticles {
    [self createViewControllerPages];
    NSInteger index = [_articles indexOfObject:_selectedArticle];
    PNGArticleViewController *articleViewController = [self viewControllerAtIndex:index storyboard:self.storyboard];
    [self.pageViewController setViewControllers:@[articleViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
}

#pragma mark - IBActions

//  Sharing article
- (void)shareButtonPressed:(id)sender {
    PNGArticle *currentArticle = [_articles objectAtIndex:currentIndex];
    NSString *text = currentArticle.title;
    NSString *postURL = currentArticle.postUrl;
    NSURL *url = [NSURL URLWithString:currentArticle.postImageURL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Download image before displaying share options
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *postItems;
            UIImage *postImage = [UIImage imageWithData:imageData];
            //Include image in the post, if available
            if (imageData.length < 1) {
                postItems = @[text, postURL];
            } else {
                postItems = @[text, postURL, postImage];
            }
            //Display share action sheet
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
            NSArray *excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
            activityViewController.excludedActivityTypes = excludeActivities;
            [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)showComments:(id)sender {
    PNGCommentsViewController *commentsViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerComments];
    PNGArticle *currentArticle = [_articles objectAtIndex:currentIndex];
    commentsViewController.postId = currentArticle.wpID;
    [self.navigationController pushViewController:commentsViewController animated:YES];
}

@end
