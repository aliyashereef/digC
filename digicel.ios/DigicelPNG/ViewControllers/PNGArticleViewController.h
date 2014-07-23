//
//  PNGArticleViewController.h
//  DigicelPNG
//
//  Created by Shane Henderson on 17/05/14.
//  Copyright (c) 2014 Marker Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNGArticle.h"
#import "UIImageView+WebCache.h"
#import "PNGUser.h"
#import "PNGSignInEmailViewController.h"
#import "PNGAddCommentViewController.h"
#import <MadsSDK/MadsSDK.h>
#import "GAITrackedViewController.h"

@interface PNGArticleViewController : GAITrackedViewController <MadsAdViewDelegate> {
    
    IBOutlet UIImageView *articleImageView;
    IBOutlet PNGLatoLabel *titleLabel;
    IBOutlet PNGLatoLabel *publishDataLabel;
    IBOutlet PNGLatoLabel *contentLabel;
    IBOutlet PNGLatoLabel *indexLabel;
    IBOutlet UIView *coachMarkTop;
    IBOutlet UIView *adsView;
    IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet NSLayoutConstraint *imageContainerHeight;
    IBOutlet NSLayoutConstraint *titleContainerHeight;
    IBOutlet NSLayoutConstraint *titleLabelHeight;
    IBOutlet NSLayoutConstraint *contentContainerHeight;
    IBOutlet NSLayoutConstraint *pageInfoViewHeight;
    IBOutlet NSLayoutConstraint *adsViewHeight;
    IBOutlet NSLayoutConstraint *mainViewHeight;
    IBOutlet NSLayoutConstraint *authorDataLabelHeight;
    
    BOOL showCommentsView;
    MadsAdView *madsAdView;
}

@property (nonatomic, strong) PNGArticle *article;
@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, strong) NSDictionary *selectedCategory;

@end
