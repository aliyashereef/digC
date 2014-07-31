//
//  PNGArticleViewController.m
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import "PNGArticleViewController.h"

#define kTitleViewPadding       48
#define kImageViewHeight        200

@interface PNGArticleViewController ()

@end

@implementation PNGArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Article";
    [self createAdsView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    madsAdView.delegate = self;
    [self setArticleDetails];
    [contentScrollView becomeFirstResponder];
    
    //  If the user trying to add a comment, show add a comment view.
    if(showCommentsView && [[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus]) {
        showCommentsView = NO;
        PNGAddCommentViewController *addCommentViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerAddComment];
         addCommentViewController.postId = self.article.wpID;
        [self.navigationController pushViewController:addCommentViewController animated:YES];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                                initWithTarget:self
                                                                        action:@selector(imageTaped)];
    articleImageView.userInteractionEnabled = YES;
    [articleImageView addGestureRecognizer:tapRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    madsAdView.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB Actions

//  Add a new comment. Show login view, if the user is not logged in.
- (IBAction)postCommentButtonAction:(id)sender {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kLoginStatus]) {
        showCommentsView = YES;
        UINavigationController *signInController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardNavViewControllerLogin];
        [self.navigationController presentViewController:signInController animated:YES completion:nil];
    } else {
        PNGAddCommentViewController *addCommentViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:PNGStoryboardViewControllerAddComment];
        addCommentViewController.postId = self.article.wpID;
        [self.navigationController pushViewController:addCommentViewController animated:YES];
    }
}

#pragma mark - Private methods 

//  Creates an inline mads view.
- (void)createAdsView {
    NSString *adZone;
    if(self.selectedCategory) {
        adZone = [_selectedCategory valueForKey:@"ad_id_bottom"];
    } else {
        adZone = kMadsInlineAdZone;
    }
    madsAdView = [[MadsAdView alloc] initWithFrame:adsView.bounds zone:adZone secret:kMadsInlineAdSecret delegate:self];
    madsAdView.madsAdType = MadsAdTypeInline;
    madsAdView.contentAlignment = YES;
    madsAdView.updateTimeInterval = 10;
    [adsView addSubview:madsAdView];
}

//  Updating UI with article details
- (void)setArticleDetails {
    if([[NSUserDefaults standardUserDefaults] boolForKey:kSwipeArticleStatus]) {
        coachMarkTop.hidden = YES;
    } else {
        coachMarkTop.hidden = NO;
    }
    [articleImageView setImageWithURL:[NSURL URLWithString:_article.postImageURL] placeholderImage:[UIImage imageNamed:PNGStoryboardImageArticleFeatured]];
    titleLabel.text = _article.title;
    publishDataLabel.text = [NSString stringWithFormat:@"%@    |    %@",_article.authorName,_article.publishedDate];
    contentLabel.text = _article.content;
    int index = (int)[_articles indexOfObject:_article];
    indexLabel.text = [NSString stringWithFormat:@"%d of %d",++index,(int)_articles.count];
    [self updateViewFrames];
}

//  Updating view frames
- (void)updateViewFrames {
    //  Changing image view height
//    if(_article.medias.fullImage) {
//        CGSize imageSize = [self requiredSizeForImage:_article.medias.fullImage];
//        imageContainerHeight.constant = imageSize.height;
//    } else {
//        imageContainerHeight.constant = 0;
//    }
    
    if (_article.postImageURL.length > 0) {
            imageContainerHeight.constant = kImageViewHeight;
    } else {
            imageContainerHeight.constant = 0;
    }

   
    NSString *publishData = [NSString stringWithFormat:@"%@    |    %@",_article.authorName,_article.publishedDate];
    
    //  Calculating required height for the title label.
    CGSize reqSize = [PNGUtilities getRequiredSizeForText:_article.title
                                                            font:[UIFont fontWithName:@"Lato-Bold" size:24]
                                                        maxWidth:titleLabel.frame.size.width];
    // Calculating required height for publish data label.
    CGSize reqSizeOfPublishData =[PNGUtilities getRequiredSizeForText:publishData
                                                            font:[UIFont fontWithName:@"Lato-Bold" size:12]
                                                        maxWidth:publishDataLabel.frame.size.width];
    //Changing height of title label according to title size.
    titleLabelHeight.constant=reqSize.height+2;
    
    //Changing height of label according to the text size.
    authorDataLabelHeight.constant=reqSizeOfPublishData.height;
    
    //  title label height + publish data label height + padding
    titleContainerHeight.constant = titleLabelHeight.constant +
                                    authorDataLabelHeight.constant+
                                    kTitleViewPadding;

    //  Calculating required height for the content label.
    reqSize = [PNGUtilities getRequiredSizeForText:_article.content
                                              font:[UIFont fontWithName:@"Lato-Regular" size:15]
                                          maxWidth:contentLabel.frame.size.width];
    contentContainerHeight.constant = reqSize.height;
    adsViewHeight.constant = madsAdView.contentSize.height;
    mainViewHeight.constant = imageContainerHeight.constant +
                              titleContainerHeight.constant +
                              pageInfoViewHeight.constant +
                              reqSize.height +
                              madsAdView.contentSize.height;
    [self.view layoutSubviews];
}

//  Returns required image size maintaining the aspect ratio.
- (CGSize)requiredSizeForImage:(PNGImage *)image {
    CGFloat height = image.height;
    CGFloat maxWidth = self.view.frame.size.width;
    height = (height/image.width) * maxWidth;
    return CGSizeMake(maxWidth, height);
}

#pragma mark - MadsAdViewDelegate

//  Sent after an ad view finished loading ad content.
//  The ad will display immediately after this signal.
- (void)didReceiveAd:(id)sender {
    if (self.isViewLoaded && self.view.window) {
        if(adsViewHeight.constant == madsAdView.contentSize.height) {
            return;
        }
        [self updateViewFrames];
        float bottomEdge = contentScrollView.contentOffset.y + contentScrollView.frame.size.height;
        if (bottomEdge == contentScrollView.contentSize.height) {
            [contentScrollView setContentOffset:CGPointMake(0, (contentScrollView.contentOffset.y+madsAdView.contentSize.height)) animated:YES];
        }
    }
}

//  Sent if an ad view failed to load ad content.
- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error {
    if (self.isViewLoaded && self.view.window) {
        [self updateViewFrames];
    }
}

- (void)imageTaped
{
    [self performSegueWithIdentifier:@"fullScreenImageView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fullScreenImageView"]) {
        PNGFullScreenViewController *fullScreen = [segue destinationViewController];
        fullScreen.imageUrl = _article.postImageURL;
    }
}

@end
